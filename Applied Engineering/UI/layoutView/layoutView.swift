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
    internal let rightBarWidth : CGFloat = 300;
    
    internal var leftBarContainer = UIView();
    internal let leftBar : leftBarViewController = leftBarViewController();
    internal let leftBarWidth : CGFloat = 300;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        print("zeromq ver: \(SwiftyZeroMQ.version)");
        
        
        // set up all the view controllers
        setupLayout();
        
        // set up pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan));
        self.view.addGestureRecognizer(panGesture);
        
        //mainViewContainer.backgroundColor = .green;
       
    }

    
    private func setupLayout(){
        // mainView
        
        mainViewContainer.frame = CGRect(x: 0, y: AppUtility.topSafeAreaInsetHeight, width: self.view.frame.width, height: self.view.frame.height - AppUtility.topSafeAreaInsetHeight);
        mainViewContainer.layer.cornerRadius = 10;
        mainViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner];
        mainViewContainer.clipsToBounds = true;
        
        self.view.addSubview(mainViewContainer);
        
        linkViewControllerToView(view: mainViewContainer, controller: mainView);
        
        // rightBar
        
        rightBarContainer.frame = CGRect(x: mainViewContainer.frame.maxX, y: AppUtility.topSafeAreaInsetHeight, width: rightBarWidth, height: self.view.frame.height - AppUtility.topSafeAreaInsetHeight);
        
        self.view.addSubview(rightBarContainer);
        
        linkViewControllerToView(view: rightBarContainer, controller: rightBar);
        
        // leftBar
        
        leftBarContainer.frame = CGRect(x: -leftBarWidth, y: AppUtility.topSafeAreaInsetHeight, width: leftBarWidth, height: self.view.frame.height - AppUtility.topSafeAreaInsetHeight);
        
        self.view.addSubview(leftBarContainer);
        
        linkViewControllerToView(view: leftBarContainer, controller: leftBar);
        
    }


}

