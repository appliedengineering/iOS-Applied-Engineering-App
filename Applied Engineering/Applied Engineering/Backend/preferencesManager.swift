//
//  preferencesManager.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation

class preferencesManager{
    static public let obj : preferencesManager = preferencesManager();
    
    // List of defaults
    private let d_connectionIPAddress : String = "192.168.2.1"; // default ip address (static ip assigned to rpi)
    private let d_connectionPort : String = "5556";
    private let d_zeromqReceiveReconnectTimeout : Int = 3000; // in ms
    private let d_receiveTimeout : Int = 1000; // in ms
    private let d_reconnectTimeout : Int = 3; // seconds
    private let d_graphBufferSize : Int = 60; // number of points
    //
    
    // List of accessible variables
    public let numberOfSettings = 6;
    public let settingsNameArray : [String] = ["Connection IP", "Connection Port", "ZMQ RCNT (ms)", "RCV Timeout (ms)", "RCNT Timeout (s)", "Graph Point Buffer"];
    
    public var connectionIPAddress : String = "";
    public var connectionPort : String = "";
    public var zeromqReceiveReconnectTimeout : Int = -1;
    public var receiveTimeout : Int = -1;
    public var reconnectTimeout : Int = -1;
    public var graphBufferSize : Int = -1;
    //
    
    private init(){ // load what was saved
        connectionIPAddress = UserDefaults.standard.string(forKey: "connectionIPAddress") ?? d_connectionIPAddress;
        connectionPort = UserDefaults.standard.string(forKey: "connectionPort") ?? d_connectionPort;
        zeromqReceiveReconnectTimeout = UserDefaults.standard.integer(forKey: "zeromqReceiveReconnectTimeout") == 0 ? d_zeromqReceiveReconnectTimeout : UserDefaults.standard.integer(forKey: "zeromqReceiveReconnectTimeout");
        receiveTimeout = UserDefaults.standard.integer(forKey: "receiveTimeout") == 0 ? d_receiveTimeout : UserDefaults.standard.integer(forKey: "receiveTimeout");
        reconnectTimeout = UserDefaults.standard.integer(forKey: "reconnectTimeout") == 0 ? d_reconnectTimeout : UserDefaults.standard.integer(forKey: "reconnectTimeout");
        graphBufferSize = UserDefaults.standard.integer(forKey: "graphBufferSize") == 0 ? d_graphBufferSize : UserDefaults.standard.integer(forKey: "graphBufferSize");
    }
    
    public func resetDefaults(){
        connectionIPAddress = d_connectionIPAddress;
        connectionPort = d_connectionPort;
        zeromqReceiveReconnectTimeout = d_zeromqReceiveReconnectTimeout;
        receiveTimeout = d_receiveTimeout;
        reconnectTimeout = d_reconnectTimeout;
        graphBufferSize = d_graphBufferSize;
        save();
    }
    
    public func save(){
        UserDefaults.standard.setValue(connectionIPAddress, forKey: "connectionIPAddress");
        UserDefaults.standard.setValue(connectionPort, forKey: "connectionPort");
        UserDefaults.standard.setValue(zeromqReceiveReconnectTimeout, forKey: "zeromqReceiveReconnectTimeout");
        UserDefaults.standard.setValue(receiveTimeout, forKey: "receiveTimeout");
        UserDefaults.standard.setValue(reconnectTimeout, forKey: "reconnectTimeout");
        UserDefaults.standard.setValue(graphBufferSize, forKey: "graphBufferSize");
    }
    
    public func getStringValueForIndex(_ index: Int) -> String{
        switch index {
        case 0:
            return connectionIPAddress;
        case 1:
            return connectionPort;
        case 2:
            return String(zeromqReceiveReconnectTimeout);
        case 3:
            return String(receiveTimeout);
        case 4:
            return String(reconnectTimeout);
        case 5:
            return String(graphBufferSize);
        default:
            return "";
        }
    }
    
    public func saveStringValueForIndex(_ index: Int, _ val: String){
        switch index {
        case 0:
            connectionIPAddress = val;
        case 1:
            if val.count <= 4{
                connectionPort = val;
            }
        case 2:
            zeromqReceiveReconnectTimeout = Int(val) ?? d_zeromqReceiveReconnectTimeout;
        case 3:
            receiveTimeout = Int(val) ?? d_receiveTimeout;
        case 4:
            reconnectTimeout = Int(val) ?? d_reconnectTimeout;
        case 5:
            graphBufferSize = Int(val) ?? d_graphBufferSize;
        default:
            print("saveStringValueForIndex recv invalid index");
        }
        save();
    }
    
}
