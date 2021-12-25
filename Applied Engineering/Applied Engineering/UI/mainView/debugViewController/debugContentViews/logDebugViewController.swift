//
//  logDebugViewController.swift
//  Applied Engineering
//
//  Created by Richard Wei on 12/22/21.
//

import Foundation
import UIKit

class logDebugViewController : debugContentViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.debugTitle = "Logs";
        self.widthToHeightRatio = 0.1;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
        
    internal let button : UIButton = UIButton();
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //
        
        let buttonHorizontalPadding : CGFloat = 6 * horizontalPadding;
        
        //
        
        self.view.addSubview(button);
        button.translatesAutoresizingMaskIntoConstraints = false;
        
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: buttonHorizontalPadding).isActive = true;
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -buttonHorizontalPadding).isActive = true;
        button.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true;
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
        
        button.backgroundColor = BackgroundGray;
        button.layer.cornerRadius = 5;
        
        button.setTitle("Open Logs", for: .normal);
        button.setTitleColor(InverseBackgroundColor, for: .normal);
        button.titleLabel?.font = UIFont(name: Inter_Medium, size: AppUtility.getCurrentScreenSize().width * 0.05);
        button.titleLabel?.textAlignment = .center;
        
        button.addTarget(self, action: #selector(self.openLogViewController), for: .touchUpInside);
        
    }
    
    @objc internal func openLogViewController(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: layoutContentLogPage), object: nil, userInfo: nil);
    }
    
}
