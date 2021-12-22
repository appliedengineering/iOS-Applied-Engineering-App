//
//  communication.swift
//  Applied Engineering
//
//  Created by Richard Wei on 4/18/21.
//

import Foundation
import SwiftyZeroMQ5
import Network
import SwiftyPing

class communicationClass{
    static public let obj = communicationClass();
    
    internal var connectionString = "";
    
    internal var context : SwiftyZeroMQ.Context?;
    internal var sub : SwiftyZeroMQ.Socket?;
    
    internal var req : SwiftyZeroMQ.Socket?;
    
    internal let replyTimeoutCounterDefault : Int = 5; // in seconds
    internal var replyTimeoutCounter : Int = 5;
    
    internal var zmqIsConnected = false;
    
    //
    
    internal var pinger : SwiftyPing? = nil;
    
    //
    
    private init(){
        printVersion();
        LocalNetworkPermissionService.obj.triggerDialog();
        do{
            context = try SwiftyZeroMQ.Context();
            sub = try context?.socket(.subscribe);
            req = try context?.socket(.request);
        }
        catch{
            log.addc("Unable to create ZeroMQ context");
        }
    }
    
    private func printVersion(){
        let (major, minor, patch, _) = SwiftyZeroMQ.version;
        log.add("ZeroMQ library version is \(major).\(minor) with patch level .\(patch)");
        log.add("SwiftyZeroMQ version is \(SwiftyZeroMQ.frameworkVersion)");
    }
    
    //
    
    public func getTelemetrySocket() -> SwiftyZeroMQ.Socket?{
        return sub;
    }
    
    //
    
    public func connect(_ address: String) -> Bool{
        
        connectionString = address;
            
        do{
            
            try sub?.setRecvTimeout(Int32(preferences.zeromqReceiveReconnectTimeout));
            
            try sub?.connect(connectionString);
            try sub?.setSubscribe("");
            
            try req?.connect(connectionString + "1"); // adds one to the port
            
        }
        catch{
            log.addc("Connect communication error - \(error) - \(convertErrno(zmq_errno()))");
            return false;
        }
        
        zmqIsConnected = true;
        
        pinger = try? SwiftyPing(host: preferences.connectionIPAddress, configuration: PingConfiguration(interval: 1), queue: DispatchQueue.global(qos: .background));
        
        pinger?.observer = { (response) in
            //let duration = response.duration;
            //print(response.error == nil);
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: connectionStatusUpdatedNotification), object: nil, userInfo: ["isConnected" : response.error == nil]);
        }
        
        try? pinger?.startPinging();
        
        return true;
    }
    
    public func disconnect() -> Bool{
        var isSuccessful = true;
        
        do{
            try sub?.disconnect(connectionString);
            try req?.disconnect(connectionString + "1");
        }
        catch{
            log.addc("Disconnect communication error - \(error) - \(convertErrno(zmq_errno()))");
            isSuccessful = false;
        }
        
        zmqIsConnected = false;
        
        pinger?.stopPinging();
        pinger = nil;
        
        return isSuccessful;
    }

    public func newConnection(_ address: String) -> Bool{
        
        if (!disconnect()){
            log.add("Failed to disconnect");
        }
        
        if (!connect(address)){
            return false;
        }
        
        return true;
    }
    
    public func convertErrno(_ errorn: Int32) -> String{
        switch errorn {
        case EAGAIN:
            return "EAGAIN - Non-blocking mode was requested and no messages are available at the moment.";
        case ENOTSUP:
            return "ENOTSUP - The zmq_recv() operation is not supported by this socket type.";
        case EFSM:
            return "EFSM - The zmq_recv() operation cannot be performed on this socket at the moment due to the socket not being in the appropriate state.";
        case ETERM:
            return "ETERM - The ØMQ context associated with the specified socket was terminated.";
        case ENOTSOCK:
            return "ENOTSOCK - The provided socket was invalid.";
        case EINTR:
            return "EINTR - The operation was interrupted by delivery of a signal before a message was available.";
        case EFAULT:
            return "EFAULT - The message passed to the function was invalid.";
        default:
            return "Not valid errno code";
        }
    }
    
    public func getIsConnected() -> Bool{
        return zmqIsConnected;
    }
    
    public func createTelemetryFullAddress() -> String{
        return "tcp://\(preferences.connectionIPAddress):\(preferences.connectionPort)";
    }
    
}

