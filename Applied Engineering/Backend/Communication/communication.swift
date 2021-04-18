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
    static let obj = communicationClass();
    
    private var connectionString = "";
    private var connectionGroup = "";
    private var context : SwiftyZeroMQ.Context?;
    public var dish : SwiftyZeroMQ.Socket?;

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
    
    public func connect(_ address: String,_ group: String) -> Bool{
        
        connectionGroup = group;
        connectionString = address;
        
        //print("connect - \(address) - \(group)")
        
        do{
            
            dish = try context?.socket(.dish);
            
            try dish?.bind(connectionString);
            try dish?.joinGroup(connectionGroup);
            try dish?.setRecvTimeout(Int32(preferences.zeromqReceiveReconnectTimeout));
            try dish?.setRecvBufferSize(Int32(preferences.zeromqReceiveBuffer));
            
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
            try dish?.leaveGroup(connectionGroup);
            try dish?.unbind(connectionString);
        }
        catch{
            log.addc("Disconnect communication error - \(error) - \(convertErrno(zmq_errno()))");
            dish = nil;
            return false;
        }
        
        dish = nil;
        isConnected = false;
        
        return true;
    }

    public func newConnection(_ address: String, _ group: String) -> Bool{
        
        if (!disconnect()){
            log.add("Failed to disconnect");
        }
        
        if (!connect(address, group)){
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
        return "udp://\(preferences.connectionIPAddress):\(preferences.connectionPort)";
    }
    
}

