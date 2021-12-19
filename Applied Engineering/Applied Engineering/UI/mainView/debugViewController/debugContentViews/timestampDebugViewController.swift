//
//  timestampDebugViewController.swift
//  Applied Engineering
//
//  Created by Richard Wei on 12/19/21.
//

import Foundation
import UIKit

class timestampDebugViewController : debugContentViewController{
        
    init() {
        super.init(nibName: nil, bundle: nil);
        self.debugTitle = "Timestamp";
        self.widthToHeightRatio = 0.25;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //self.view.backgroundColor = .systemBlue;
        
    }
}
