//
//  graphViewController.swift
//  Applied Engineering
//
//  Created by Richard Wei on 11/17/21.
//

import Foundation
import UIKit

class graphViewController : UIViewController{
    
    internal var graphKey : String = "";

    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = .systemBlue;
    }
    
    //
    
    public func setGraphKey(_ key: String){
        graphKey = key;
    }
    
    @objc internal func dismissVC(_ button: UIButton){
        self.dismiss(animated: true);
    }

}
