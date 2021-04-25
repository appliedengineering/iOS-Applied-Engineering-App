//
//  dataManager.swift
//  Applied Engineering
//
//  Created by Richard Wei on 4/18/21.
//

import Foundation
import UIKit
import SwiftyZeroMQ5
import MessagePacker
import Charts

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
    
    //
    
    private var graphData : [[ChartDataEntry]] = Array(repeating: [], count: numberOfGraphableVars);
    private var startTimeStamp : Float64 = 0.0;
    
    private init(){
        startTimeStamp = NSDate().timeIntervalSince1970;
        communicationThread();
    }
    
    private func communicationThread(){
        DispatchQueue.global(qos: .background).async{
            while true{ // keeps on reconnecting
                
                while communication.getIsConnected(){
                 
                    do{
                        self.updateWithNewData(try MessagePackDecoder().decode(APiData.self, from: try communication.dish?.recv() ?? Data()));
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
    
    private func updateWithNewData(_ data: APiData){
        
        for i in 0..<numberOfGraphableVars{
            graphData[i].append(createDataPoint(data.timeStamp, specificDataAttribute(with: i, data: data)));
            
            while (graphData[i].count > preferences.graphBufferSize){
                graphData[i].removeFirst();
            }
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: dataUpdatedNotification), object: nil);
        
    }
    
    public func getGraphData(_ index: Int) -> [ChartDataEntry]{
        guard index < numberOfGraphableVars && index > -1 else{
            return [];
        }
        return graphData[index];
    }
    
    // Helper functions
    
    private func specificDataAttribute(with index: Int, data: APiData) -> Float32{
        switch index{
        case 0:
            return data.rpm;
        case 1:
            return data.torque;
        case 2:
            return Float32(data.throttlePercent);
        case 3:
            return Float32(data.dutyPercent);
        case 4:
            return Float32(data.pwmFrequency);
        case 5:
            return Float32(data.tempC);
        case 6:
            return data.sourceVoltage;
        case 7:
            return data.pwmCurrent;
        case 8:
            return data.powerChange;
        case 9:
            return data.voltageChange;
        default:
            return 0;
        }
    }
    
    private func createDataPoint(_ timeStamp: Float64, _ data: Float32) -> ChartDataEntry{
        return ChartDataEntry(x: max(timeStamp - startTimeStamp, 0), y: Double(data));
    }
    
}
