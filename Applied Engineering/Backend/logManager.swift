//
//  logManager.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/7/21.
//

import Foundation

class log{
    static private var logBuffer : [String] = [String]();
    static public func add(_ s: Any){
        let str = "\(s)";
        print(str);
        logBuffer.append(str);
    }
    static public func addc(_ s: Any){ // critical
        let str = "Critical: \(s)";
        print(str);
        logBuffer.append(str);
    }
    static public func getBuffer() -> [String]{
        return logBuffer;
    }
}
