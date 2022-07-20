//
//  dataManager.swift
//  Applied Engineering
//
//  Created by Richard Wei on 4/18/21.
//

import Foundation
import UIKit
import SwiftyZeroMQ5
import SwiftMsgPack
import Charts


class dataManager{
    
    static public let obj = dataManager();
    
    //
    
    private var graphDataStorage : [String : [ChartDataEntry]] = [:];
    private var staticDataStorage : [String : AnyObject] = [:];
    private var latestTimestamp : Float64 = 0.0;
    
    private var startTimeStamp : Float64 = 0.0;
    private var recvTimeoutTimestamp : CFAbsoluteTime = CFAbsoluteTimeGetCurrent();
    
    private var shouldReceiveData : Bool = true;
    
    //
    
    struct graphAttributes{
        static public let defaultColor : UIColor = .rgb(68, 75, 55); // branding default color
        
        var title : String = "";
        var color : UIColor = defaultColor;
    }
    
    private let graphAttributeLookup : [String : graphAttributes] = [
        "TP" : graphAttributes(title: "Throttle %", color: .rgb(68, 81, 181)), // X
        "DP" : graphAttributes(title: "Duty %", color: .rgb(0, 150, 136)), // X
        "CP" : graphAttributes(title: "Chip Temp (°C)", color: .rgb(76, 175, 80)), // X
        "BV" : graphAttributes(title: "Battery Voltage", color: .rgb(255, 235, 59)), // on instrument cluster
        "speed" : graphAttributes(title: "Speed (m/s)", color: .rgb(255, 152, 0)),
        //"pwmFrequency" : graphAttributes(title: "PWM Frequency", color: .rgb(255, 87, 34)),
        //"tempC" : graphAttributes(title: "Temperature (C)", color: .rgb(244, 67, 54)), // on instrument cluster
        //"sourceVoltage" : graphAttributes(title: "Source Voltage (V)", color: .rgb(233, 30, 99)),
        //"voltageChange" : graphAttributes(title: "Voltage Change (Δ)", color: .rgb(206, 147, 216))
    ];
    
    /*private let graphNameLookup : [String : String] = [
        "rpm" : "RPM",
        "torque" : "Torque (N⋅m)",
        "throttleDuty" : "Throttle Duty",
        "throttlePercent" : "Throttle (%)",
        "dutyPercent" : "Duty (%)",
        "pwmFrequency" : "PWM Frequency",
        "tempC" : "Temperature (C)",
        "sourceVoltage" : "Source Voltage (V)",
        "voltageChange" : "Voltage Change (Δ)"
    ];
    
    private let graphColorLookup : [String : UIColor] = [
        "rpm" : UIColor.rgb(63, 81, 181),
        "torque" : UIColor.rgb(0, 150,136),
        "throttleDuty" : UIColor.rgb(76, 175, 80),
        "throttlePercent" : UIColor.rgb(255, 235, 59),
        "dutyPercent" : UIColor.rgb(255, 152, 0),
        "pwmFrequency" : UIColor.rgb(255, 87, 34),
        "tempC" : UIColor.rgb(244, 67, 54),
        "sourceVoltage" : UIColor.rgb(233, 30, 99),
        "voltageChange" : UIColor.rgb(206, 147, 216)
    ];*/
    
    //
    
    private init(){
        startTimeStamp = NSDate().timeIntervalSince1970;
        recvTimeoutTimestamp = CFAbsoluteTimeGetCurrent();
        communicationThread();
    }
    
    private func communicationThread(){
        DispatchQueue.global(qos: .background).async{
            while true{ // keeps on reconnecting
                
                while (communication.getIsConnected() && communication.getTelemetrySocket() != nil) {
                    
                    do{
                        self.updateWithNewData(try communication.getTelemetrySocket()?.recv() ?? Data());
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
        
        if (shouldReceiveData && (CFAbsoluteTimeGetCurrent() - recvTimeoutTimestamp >= Double(preferences.receiveTimeout / 1000))){
            
            var data : [String : AnyObject]? = nil;
            
            do {
                data = try rawData.unpack() as? [String : AnyObject];
            } catch {
                log.addc("Failed to decode recv message with MessagePack - \(error)");
                return;
            }
            
            //print("recv data - \(data)")
            
            guard var data = data else {
                log.add("Decoded data was invalid - \(data)");
                return;
            }
            
            //
            
            guard let currentTimestamp = data["timeStamp"] as? Float64 else{
                log.add("Invalid timestamp in data - \(data)");
                return;
            }
            data["timeStamp"] = nil; // remove from raw data
            
            if (currentTimestamp >= latestTimestamp){
                
                latestTimestamp = currentTimestamp;
                
                // remove excess data points from storage
                
                for key in graphDataStorage.keys{
                    if (data[key] == nil){
                        graphDataStorage[key] = nil;
                    }
                }
                
                for key in staticDataStorage.keys{
                    if (data[key] == nil){
                        staticDataStorage[key] = nil;
                    }
                }
                
                // update all other values
                
                for point in data{
                    if (isGraphableData(point.key)){
                        if (graphDataStorage[point.key] == nil){
                            graphDataStorage[point.key] = [];
                        }
                        
                        graphDataStorage[point.key]!.append(createDataPoint(currentTimestamp, castToFloat(point.value)));
                        
                        graphDataStorage[point.key]!.sort(by: { $0.x < $1.x });
                        
                        while ((graphDataStorage[point.key]?.count ?? -1) > preferences.graphBufferSize){
                            graphDataStorage[point.key]?.removeFirst();
                        }
                    }
                    else{
                        if (staticDataStorage[point.key] == nil){
                            staticDataStorage[point.key] = point.value;
                        }
                    }
                }
                
                //
                
                let notificationDict : [String : [String]] = [notificationDictionaryUpdateKeys : Array(data.keys)];
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: dataUpdatedNotification), object: notificationDict);
                
            }
            else{
                log.add("Received dataset with smaller timestamp \(currentTimestamp) compared to latest \(latestTimestamp)");
            }
            
            recvTimeoutTimestamp = CFAbsoluteTimeGetCurrent();
            
        }
        
    }
    
    //
    
    public func isGraphableData(_ key: String) -> Bool{
        return !nonGraphableDataPoints.contains(key); // defined in misc
    }
    
    public func getGraphDataFor(_ key: String) -> [ChartDataEntry]{
        guard let dataSet = graphDataStorage[key] else{
            log.add("No dataset for graph \(key)");
            return [];
        }
        return dataSet;
    }
    
    public func getGraphTitleFor(_ key: String) -> String{
        return graphAttributeLookup[key]?.title ?? key;
    }
    
    public func getGraphColorFor(_ key: String) -> UIColor{
        return graphAttributeLookup[key]?.color ?? graphAttributes.defaultColor;
    }
    
    public func setShouldReceiveData(_ recvData: Bool){
        shouldReceiveData = recvData;
    }
    
    public func isReceivingData() -> Bool{
        return shouldReceiveData;
    }
    
    public func getLatestTimestamp() -> Float64{
        return latestTimestamp;
    }
    
    public func getStartTimestamp() -> Float64{
        return startTimeStamp;
    }
    
    //
    
    private func castToFloat(_ obj: AnyObject) -> Float64{
        guard let f = obj as? Float64 else{
            log.add("Failed to cast \(obj) to Float64");
            return 0.0;
        }
        return f;
    }
    
    private func createDataPoint(_ timeStamp: Float64, _ data: Float64) -> ChartDataEntry{
        
        let pointTimeStamp = (timeStamp - startTimeStamp).truncate(places: 3);
        
        guard pointTimeStamp >= 0 else{
            log.addc("Recieved timeStamp (\(timeStamp)) is smaller than starting timeStamp");
            return ChartDataEntry(x: 0, y: Double(data));
        }
        
        return ChartDataEntry(x: pointTimeStamp, y: Double(data));
    }
    
}
