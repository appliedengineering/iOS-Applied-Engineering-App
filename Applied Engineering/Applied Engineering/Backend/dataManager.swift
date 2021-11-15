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
    private var statusData : [Int] = Array(repeating: -1, count: numberOfStatusVars);
    private var startTimeStamp : Float64 = 0.0;
    
    private var recvTimeoutTimestamp : CFAbsoluteTime = CFAbsoluteTimeGetCurrent();
    
    private init(){
        startTimeStamp = NSDate().timeIntervalSince1970;
        recvTimeoutTimestamp = CFAbsoluteTimeGetCurrent();
        communicationThread();
    }
    
    private func communicationThread(){
        DispatchQueue.global(qos: .background).async{
            while true{ // keeps on reconnecting
                
                while communication.getIsConnected(){
                 
                    do{
                        self.updateWithNewData(try communication.recvData() ?? Data());
                    }
                    catch{
                        //print(error);
                        if (errno != EAGAIN){
                            log.addc("Communication error - \(error) with errno \(errno) = \(communication.convertErrno(errno))");
                        }
                    }
                    
                }
                
                sleep(UInt32(preferences.reconnectTimeout));
                
            }
            
        }
    }
    
    private func updateWithNewData(_ rawData: Data){
        
        if (CFAbsoluteTimeGetCurrent() - recvTimeoutTimestamp >= Double(preferences.receiveTimeout / 1000)){
            
            var data : APiData? = nil;
            
            do {
                data = try MessagePackDecoder().decode(APiData.self, from: rawData);
            } catch {
                log.addc("Failed to decode recv message with MessagePacker - \(error)");
                return;
            }
            
            for i in 0..<numberOfGraphableVars{
                graphData[i].append(createDataPoint(data!.timeStamp, specificDataAttribute(with: i, data: data!)));
                
                while (graphData[i].count > preferences.graphBufferSize){
                    graphData[i].removeFirst();
                }
                
            }
            
            for i in 0..<numberOfStatusVars{
                statusData[i] = specificStatusDataAttribute(with: i, data: data!);
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: dataUpdatedNotification), object: nil);
            
            recvTimeoutTimestamp = CFAbsoluteTimeGetCurrent();
            
        }
        
        //print("new data point at \(graphData[0][graphData[0].count - 1].x) - \(graphData[0].count)");
        
    }
    
    public func getGraphData(_ index: Int) -> [ChartDataEntry]{
        guard index < numberOfGraphableVars && index > -1 else{
            return [];
        }
        return graphData[index];
    }
    
    public func getStatusData(_ index: Int) -> Int{
        guard index < numberOfStatusVars && index > -1 else{
            return 0;
        }
        return statusData[index];
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
    
    private func specificStatusDataAttribute(with index: Int, data: APiData) -> Int{
        switch index {
        case 0:
            return data.mddStatus ? 1 : 0;
        case 1:
            return data.ocpStatus ? 1 : 0;
        case 2:
            return data.ovpStatus ? 1 : 0;
        case 3:
            return data.psuMode;
        default:
            return -1;
        }
    }
    
    private func createDataPoint(_ timeStamp: Float64, _ data: Float32) -> ChartDataEntry{
        return ChartDataEntry(x: max(timeStamp - startTimeStamp, 0).truncate(places: 3), y: Double(data));
    }
    
}
