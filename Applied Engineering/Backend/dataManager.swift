//
//  dataManager.swift
//  Applied Engineering
//
//  Created by Richard Wei on 4/18/21.
//

import Foundation
import UIKit
import SwiftyZeroMQ5
// ["RPM", "Torque", "Throttle (%)", "Duty (%)", "PWM Frequency", "Temperature (C)", "Source Voltage", "PWM Current", "Power Change (Δ)", "Voltage Change (Δ)"];
public struct APiData : Decodable{
    var psuMode : Int = 0; // power supply mode - 3
    // graphable data
    var throttlePercent : Int = 0;
    var dutyPercent : Int = 0;
    var pwmFrequency : Int = 0;
    var rpm : Float32 = 0.0;
    var torque : Float32 = 0.0;
    var tempC : Float32 = 0.0;
    var sourceVoltage : Float32 = 0.0;
    var pwmCurrent : Float32 = 0.0;
    var powerChange : Float32 = 0.0;
    var voltageChange : Float32 = 0.0;
    // graphable data
    var mddStatus : Bool = false; // minimum duty detection - 0
    var ocpStatus : Bool = false; // over current protection - 1
    var ovpStatus : Bool = false; // over voltage prevention - 2
    var timeStamp : Float64 = 0.0;
}

class dataManager{
    
    static public let obj = dataManager();
    
    private init(){
        communicationThread();
    }
    
    private func communicationThread(){
        DispatchQueue.global(qos: .background).async{
            while true{ // keeps on reconnecting
                
                while communication.getIsConnected(){
                 
                    do{
                        let data = try communication.dish?.recv();
                        print("data recv - \(data)");
                    }
                    catch{
                        print(error);
                        if (errno != EAGAIN){
                            log.addc("Communication error - \(error) with errno \(errno) = \(communication.convertErrno(errno))");
                        }
                    }
                    
                }
                
                sleep(UInt32(preferences.reconnectTimeout));
                
            }
            
        }
    }
    
}
