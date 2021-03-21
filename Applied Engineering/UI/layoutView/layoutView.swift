//
//  layoutView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 2/28/21.
//

import UIKit
import SwiftyZeroMQ5

class layoutViewController: UIViewController {

    
    // view controllers
    
    internal var mainViewContainer = UIView();
    internal let mainView : mainViewController = mainViewController();
    
    internal var rightBarContainer = UIView();
    internal let rightBar : rightBarViewController = rightBarViewController();
    
    internal var leftBarContainer = UIView();
    internal let leftBar : leftBarViewController = leftBarViewController();
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        print("zeromq ver: \(SwiftyZeroMQ.version)");
        
        // set up all the view controllers
        setupLayout();
        
        // set up pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan));
        self.view.addGestureRecognizer(panGesture);
        
        self.view.backgroundColor = BackgroundColor;
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToSettings), name: NSNotification.Name(rawValue: layoutSettingsViewNotification), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToMain), name: NSNotification.Name(rawValue: layoutMainViewNotification), object: nil);
        //mainViewContainer.backgroundColor = .green;
       
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: layoutSettingsViewNotification), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: layoutMainViewNotification), object: nil);
    }

    
    private func setupLayout(){
        // mainView
        
        mainViewContainer.frame = CGRect(x: 0, y: AppUtility.topSafeAreaInsetHeight, width: self.view.frame.width, height: self.view.frame.height - AppUtility.topSafeAreaInsetHeight);
        /*mainViewContainer.layer.cornerRadius = 10;
        mainViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner];
        mainViewContainer.clipsToBounds = true;*/
        
        self.view.addSubview(mainViewContainer);
        
        linkViewControllerToView(view: mainViewContainer, controller: mainView);
        
        // rightBar
        
        let rightBarWidth = CGFloat(self.view.frame.width * 2 / 3);
        rightBarContainer.frame = CGRect(x: mainViewContainer.frame.maxX, y: AppUtility.topSafeAreaInsetHeight, width: rightBarWidth, height: self.view.frame.height - AppUtility.topSafeAreaInsetHeight);
        /*rightBarContainer.layer.cornerRadius = 10;
        rightBarContainer.layer.maskedCorners = [.layerMinXMinYCorner];
        rightBarContainer.clipsToBounds = true;*/
        
        self.view.addSubview(rightBarContainer);
        
        linkViewControllerToView(view: rightBarContainer, controller: rightBar);
        
        // leftBar
        
        let leftBarWidth = CGFloat(self.view.frame.width * 2 / 3);
        leftBarContainer.frame = CGRect(x: -leftBarWidth, y: AppUtility.topSafeAreaInsetHeight, width: leftBarWidth, height: self.view.frame.height - AppUtility.topSafeAreaInsetHeight);
        //leftBarContainer.layer.cornerRadius = 10;
        //leftBarContainer.layer.maskedCorners = [.layerMaxXMinYCorner];
        //leftBarContainer.clipsToBounds = true;
        
        self.view.addSubview(leftBarContainer);
        
        linkViewControllerToView(view: leftBarContainer, controller: leftBar);
        
    }


}

