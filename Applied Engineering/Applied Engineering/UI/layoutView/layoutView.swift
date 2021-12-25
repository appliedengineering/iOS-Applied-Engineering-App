//
//  layoutView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 2/28/21.
//

import UIKit

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
        
        // set up all the view controllers
        setupLayout();
        
        // set up pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan));
        self.view.addGestureRecognizer(panGesture);
        
        self.view.backgroundColor = BackgroundColor;
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToSettings), name: NSNotification.Name(rawValue: layoutSettingsViewNotification), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToMain), name: NSNotification.Name(rawValue: layoutMainViewNotification), object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentInstrumentClusterPage), name: NSNotification.Name(rawValue: layoutContentInstrumentClusterPage), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentGraphPage), name: NSNotification.Name(rawValue: layoutContentGraphPage), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentLogPage), name: NSNotification.Name(rawValue: layoutContentLogPage), object: nil);
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: layoutSettingsViewNotification), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: layoutMainViewNotification), object: nil);
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: layoutContentInstrumentClusterPage), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: layoutContentGraphPage), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: layoutContentLogPage), object: nil);
    }

    
    private func setupLayout(){
        // mainView
        
        mainViewContainer.frame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: self.view.frame.width, height: self.view.frame.height - AppUtility.safeAreaInset.top);
        /*mainViewContainer.layer.cornerRadius = 10;
        mainViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner];
        mainViewContainer.clipsToBounds = true;*/
        
        self.view.addSubview(mainViewContainer);
        
        linkViewControllerToView(view: mainViewContainer, controller: mainView, parentController: self);
        
        // rightBar
        
        let rightBarWidth = CGFloat(self.view.frame.width * 2 / 3);
        rightBarContainer.frame = CGRect(x: mainViewContainer.frame.maxX, y: AppUtility.safeAreaInset.top, width: rightBarWidth, height: self.view.frame.height - AppUtility.safeAreaInset.top);
        /*rightBarContainer.layer.cornerRadius = 10;
        rightBarContainer.layer.maskedCorners = [.layerMinXMinYCorner];
        rightBarContainer.clipsToBounds = true;*/
        
        self.view.addSubview(rightBarContainer);
        
        linkViewControllerToView(view: rightBarContainer, controller: rightBar, parentController: self);
        
        // leftBar
        
        let leftBarWidth = CGFloat(self.view.frame.width * 2 / 3);
        leftBarContainer.frame = CGRect(x: -leftBarWidth, y: AppUtility.safeAreaInset.top, width: leftBarWidth, height: self.view.frame.height - AppUtility.safeAreaInset.top);
        //leftBarContainer.layer.cornerRadius = 10;
        //leftBarContainer.layer.maskedCorners = [.layerMaxXMinYCorner];
        //leftBarContainer.clipsToBounds = true;
        
        self.view.addSubview(leftBarContainer);
        
        linkViewControllerToView(view: leftBarContainer, controller: leftBar, parentController: self);
        
    }


}

