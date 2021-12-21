//
//  timestampCommunication.swift
//  Applied Engineering
//
//  Created by Richard Wei on 12/20/21.
//

import Foundation
import SwiftyZeroMQ5
import Network
import SwiftyPing
import SwiftMsgPack

extension communicationClass{
    
    public func sendSyncTimestampRequest(replyCompletion: @escaping (Bool) -> Void){
        let timestamp = NSDate().timeIntervalSince1970;
        
        var rawData : Data = Data();
        
        do{
            try rawData.pack(timestamp);
            try pair?.send(data: rawData);
        }
        catch{
            log.addc("Failed to sync timestamp \(timestamp) : \(error) - \(convertErrno(zmq_errno()))");
            replyCompletion(false);
        }

        //
            
        DispatchQueue.global(qos: .background).async {
            self.awaitSyncTimestamp(completion: { (isSuccessful) in
                DispatchQueue.main.sync {
                    replyCompletion(isSuccessful);
                }
            });
        }
    }
    
    //

    
    private func awaitSyncTimestamp(completion: @escaping (Bool) -> Void){
                        
        var replyRawData : Data? = nil;
        
        while (replyTimeoutCounter > 0 && replyRawData == nil){
            do{
                try replyRawData = pair?.recv(options: .dontWait);
            }
            catch{
                if (errno != EAGAIN){
                    log.addc("Failed to receive reply request - \(error) - \(convertErrno(zmq_errno()))");
                    resetCounter();
                    completion(false);
                    return;
                }
            }
            sleep(UInt32(1));
            replyTimeoutCounter -= 1;
        }
        
        if (replyRawData == nil){
            resetCounter();
            completion(false);
            return;
        }
        
        var replyOutcome : Bool? = nil;
        
        do{
            replyOutcome = try replyRawData?.unpack() as? Bool;
        }
        catch{
            log.addc("Failed to unpack sync timestamp reply raw data");
            resetCounter();
            completion(false);
            return;
        }
        
        guard let reply = replyOutcome else{
            log.addc("Received and unpacked timestamp sync data was invalid");
            resetCounter();
            completion(false);
            return;
        }
        
        resetCounter();
        completion(reply);
        
    }
    
    private func resetCounter(){
        replyTimeoutCounter = replyTimeoutCounterDefault;
    }
    
}

