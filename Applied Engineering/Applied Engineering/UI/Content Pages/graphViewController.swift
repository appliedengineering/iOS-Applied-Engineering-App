//
//  graphViewController.swift
//  Applied Engineering
//
//  Created by Richard Wei on 11/17/21.
//

import Foundation
import UIKit
import Charts

class graphViewController : contentViewController{
    
    internal var graphKey : String = "";

    internal let backButton : UIButton = UIButton();
    internal var backButtonHeightConstraint : NSLayoutConstraint? = nil;
    
    internal let graphView : LineChartView = LineChartView();
    
    //
    
    public func setGraphKey(_ key: String){
        graphKey = key;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = .systemRed;
        
        //
        
        self.view.addSubview(backButton);
        
        backButton.translatesAutoresizingMaskIntoConstraints = false;
        
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true;
        backButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        backButtonHeightConstraint = backButton.heightAnchor.constraint(equalToConstant: 0);
        backButtonHeightConstraint?.isActive = true;
        
        backButton.backgroundColor = .systemBlue;
        backButton.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside); 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        AppUtility.lockOrientation(.all);
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil);
        
        self.updateViewsWithScreenSize(AppUtility.getCurrentScreenSize());
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData), name: NSNotification.Name(rawValue: dataUpdatedNotification), object: nil);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: dataUpdatedNotification), object: nil);
    }
    
    //
    
    @objc internal func dismissVC(_ button: UIButton){
        self.dismiss(animated: true);
    }

    @objc internal func rotated(){
        updateViewsWithScreenSize(AppUtility.getCurrentScreenSize());
    }
    
    @objc internal func updateData(_ notification: NSNotification){
        print("update data")
    }
    
    private func updateViewsWithScreenSize(_ screenSize: CGSize){
        UIView.animate(withDuration: 1, animations: {
            self.backButtonHeightConstraint?.constant = (screenSize.width * (AppUtility.getCurrentScreenOrientation() == .portrait ? 0.1 : 0.01)) + AppUtility.safeAreaInset.top;
        });
    }
    
}
