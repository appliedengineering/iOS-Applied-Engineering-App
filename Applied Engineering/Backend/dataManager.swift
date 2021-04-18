//
//  dataManager.swift
//  Applied Engineering
//
//  Created by Richard Wei on 4/18/21.
//

import Foundation
import UIKit
import SwiftyZeroMQ5

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
