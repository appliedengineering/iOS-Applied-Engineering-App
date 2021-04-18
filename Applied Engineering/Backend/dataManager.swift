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
        
    }
    
    private func communicationThread(){
        DispatchQueue.global(qos: .background).async{
            while true{ // keeps on reconnecting
                
                
                
            }
        }
    }
    
}
