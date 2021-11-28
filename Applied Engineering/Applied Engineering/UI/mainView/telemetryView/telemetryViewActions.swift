//
//  telemetryViewActions.swift
//  Applied Engineering
//
//  Created by Richard Wei on 11/28/21.
//

import Foundation
import UIKit

extension telemetryViewController{
    @objc internal func handleRefresh(_ refreshControl: UIRefreshControl){
        self.refreshControl.endRefreshing();
    }
    
    @objc internal func updateData(_ notification: NSNotification){
        print("update data")
    
        guard let notificationDict = notification.object as? [String : Any] else{
            log.add("Invalid dictionary in notification");
            return;
        }
        
        guard let keyArray = notificationDict[notificationDictionaryUpdateKeys] as? [String] else{
            log.add("Invalid keyArray in updateData");
            return;
        }
        
        print(keyArray);
        
    }
    
    @objc internal func openGraph(_ button: GraphUIButton){
        print(button.graphIndex);
    }
}
