//
//  mainView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 2/28/21.
//

import UIKit
import SwiftyZeroMQ5

class mainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = .white;
        print("zeromq ver: \(SwiftyZeroMQ.version)");
        
    }


}

