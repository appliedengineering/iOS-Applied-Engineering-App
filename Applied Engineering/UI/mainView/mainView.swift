//
//  mainView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/7/21.
//

import Foundation
import UIKit

class mainViewController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = .blue;
        
        //log.add("called mainviewcontroller")
        NotificationCenter.default.addObserver(self, selector: #selector(self.setContent), name: NSNotification.Name(rawValue: mainViewSetContentViewNotification), object: nil);
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: mainViewSetContentViewNotification), object: nil);
    }
    
    @objc func setContent(_ sender: NSNotification){
        
        guard let dict = sender.userInfo as NSDictionary? else{
            return;
        }
        
        guard let contentIndex = dict["contentIndex"] as? Int else{
            return;
        }
        
        print("got content - \(contentIndex)");
        
    }
}
