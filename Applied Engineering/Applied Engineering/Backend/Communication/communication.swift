//
//  communication.swift
//  Applied Engineering
//
//  Created by Richard Wei on 4/18/21.
//

import Foundation
import SwiftyZeroMQ5
import Network

class communicationClass{
    static public let obj = communicationClass();
    
    private var connectionString = "";
    
    private var context : SwiftyZeroMQ.Context?;
    private var sub : SwiftyZeroMQ.Socket?;

    private var isConnected = false;
    
    private init(){
        printVersion();
        LocalNetworkPermissionService.obj.triggerDialog();
        do{
            context = try SwiftyZeroMQ.Context();
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
    
    public func recvData() throws -> Data?{
        return sub?.recv();
    }
    
    //
    
    public func connect(_ address: String) -> Bool{
        
        connectionString = address;
            
        do{
            
            sub = try context?.socket(.subscribe);
            
            try sub?.setRecvTimeout(Int32(preferences.zeromqReceiveReconnectTimeout));
            
            try sub?.connect(connectionString);
            try sub?.setSubscribe("");
            
        }
        catch{
            log.addc("Connect communication error - \(error) - \(convertErrno(zmq_errno()))");
            return false;
        }
        
        isConnected = true;
        
        return true;
    }
    
    public func disconnect() -> Bool{
        
        do{
            try sub?.disconnect(connectionString);
            try sub?.close();
        }
        catch{
            log.addc("Disconnect communication error - \(error) - \(convertErrno(zmq_errno()))");
            sub = nil;
            isConnected = false;
            return false;
        }
        
        sub = nil;
        isConnected = false;
        
        return true;
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
        return isConnected;
    }
    
    public func createFullAddress() -> String{
        return "tcp://\(preferences.connectionIPAddress):\(preferences.connectionPort)";
    }
    
}

