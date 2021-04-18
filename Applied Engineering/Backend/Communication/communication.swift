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
    private var dish : SwiftyZeroMQ.Socket?;
    
    private init(){
        printVersion();
        
    }
    
    private func printVersion(){
        let (major, minor, patch, _) = SwiftyZeroMQ.version;
        log.add("ZeroMQ library version is \(major).\(minor) with patch level .\(patch)");
        log.add("SwiftyZeroMQ version is \(SwiftyZeroMQ.frameworkVersion)");
    }
    
}

