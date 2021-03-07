//
//  layoutView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 2/28/21.
//

import UIKit
import SwiftyZeroMQ5

class layoutViewController: UIViewController {

    private var mainViewContainer = UIView();
    private var mainView : mainViewController = mainViewController();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = .white;
        print("zeromq ver: \(SwiftyZeroMQ.version)");
        
        setupLayout();
        
    }
    
    private func linkViewControllerToView(view: UIView, controller: UIViewController){
        controller.view.frame = view.frame;
        view.addSubview(controller.view);
        self.addChild(controller);
        controller.didMove(toParent: self);
    }
    
    private func setupLayout(){
        // mainView
        
        mainViewContainer.frame = self.view.frame;
        self.view.addSubview(mainViewContainer);
        
        linkViewControllerToView(view: mainViewContainer, controller: mainView);
    
        
    }


}

