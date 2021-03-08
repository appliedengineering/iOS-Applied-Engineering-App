//
//  layoutViewMisc.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/7/21.
//

import Foundation
import UIKit

extension layoutViewController{
    internal func linkViewControllerToView(view: UIView, controller: UIViewController){
        controller.willMove(toParent: self);
        controller.view.frame = view.bounds;
        view.addSubview(controller.view);
        self.addChild(controller);
        controller.didMove(toParent: self);
    }

    @objc func handlePan(panGesture: UIPanGestureRecognizer){
        
        if (panGesture.state == .began || panGesture.state == .changed){
            let translation = panGesture.translation(in: mainViewContainer);
            panGesture.setTranslation(.zero, in: mainViewContainer);
            
            mainViewContainer.frame = CGRect(x: mainViewContainer.frame.minX + translation.x, y: mainViewContainer.frame.minY, width: mainViewContainer.frame.width, height: mainViewContainer.frame.height);
            
        }
        else if (panGesture.state == .ended){ // snap mainView to either side or return to original position
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.mainViewContainer.frame = CGRect(x: 0, y: self.mainViewContainer.frame.minY, width: self.mainViewContainer.frame.width, height: self.mainViewContainer.frame.height);
                
            });
            
        }
        
    }
}
