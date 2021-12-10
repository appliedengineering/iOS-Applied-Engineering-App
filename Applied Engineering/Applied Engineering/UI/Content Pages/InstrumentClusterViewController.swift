//
//  InstrumentClusterViewController.swift
//  Applied Engineering
//
//  Created by Richard Wei on 5/2/21.
//

import Foundation
import UIKit

class instrumentClusterViewController : contentViewController{
    override func viewDidLoad() {
        super.viewDidLoad();
        
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight);
        
        self.view.backgroundColor = .systemRed;
        
        let button = UIButton();
        self.view.addSubview(button);
        button.translatesAutoresizingMaskIntoConstraints = false;
        
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        button.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true;
        button.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true;
        button.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true;
        
        button.setTitle("button", for: .normal);
        
        button.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside);
    }

    //
    
    @objc func dismissVC(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil);
    }
}
