//
//  layoutView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 2/28/21.
//

import UIKit
import SwiftyZeroMQ5

class layoutViewController: UIViewController {

    internal var mainViewContainer = UIView();
    internal var mainView : mainViewController = mainViewController();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = .white;
        print("zeromq ver: \(SwiftyZeroMQ.version)");
        
        // set up all the view controllers
        setupLayout();
        
        // set up pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan));
        mainViewContainer.addGestureRecognizer(panGesture);
        
        mainViewContainer.backgroundColor = .green;
       
    }

    
    private func setupLayout(){
        // mainView
        
        mainViewContainer.frame = CGRect(x: 0, y: AppUtility.topSafeAreaInsetHeight, width: self.view.frame.width, height: self.view.frame.height - AppUtility.topSafeAreaInsetHeight);
        
        self.view.addSubview(mainViewContainer);
        
        linkViewControllerToView(view: mainViewContainer, controller: mainView);
        
        
    }


}

