//
//  layoutViewMisc.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/7/21.
//

import Foundation
import UIKit

extension layoutViewController{

    @objc func handlePan(panGesture: UIPanGestureRecognizer){
        
        if (panGesture.state == .began || panGesture.state == .changed){
            let translation = panGesture.translation(in: mainViewContainer);
            panGesture.setTranslation(.zero, in: mainViewContainer);
            
            let mainViewContainerMinX = min(max(mainViewContainer.frame.minX + translation.x, -rightBarContainer.frame.width), leftBarContainer.frame.width);
            
            updateContainerViews(mainViewContainerMinX: mainViewContainerMinX);
            
            if (mainViewContainerMinX < 0){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: dismissRightBarKeyboardNotification), object: nil, userInfo: nil);
            }
            
        }
        else if (panGesture.state == .ended){ // snap mainView to either side or return to original position
        
            let thresholdPercent : CGFloat = 0.5; // if at least 30 percent of one of the bar views are showing, then move to that otherwise move back to main view
            
            let mainViewContainerMinX = mainViewContainer.frame.minX;
            
            if (mainViewContainerMinX >= thresholdPercent * leftBarContainer.frame.width){
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.updateContainerViews(mainViewContainerMinX: self.leftBarContainer.frame.width);
                    
                });
                
            }
            else if (mainViewContainerMinX <= -(thresholdPercent * rightBarContainer.frame.width)){
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.updateContainerViews(mainViewContainerMinX: -self.rightBarContainer.frame.width);
                    
                });
                
            }
            else{ // snap back to main view
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.updateContainerViews(mainViewContainerMinX: 0);
                    
                });
                
            }
            
        }
        
    }
    
    
    private func updateContainerViews(mainViewContainerMinX: CGFloat){
        mainViewContainer.frame = CGRect(x: mainViewContainerMinX, y: mainViewContainer.frame.minY, width: mainViewContainer.frame.width, height: mainViewContainer.frame.height);
        
        rightBarContainer.frame = CGRect(x: mainViewContainer.frame.maxX, y: rightBarContainer.frame.minY, width: rightBarContainer.frame.width, height: rightBarContainer.frame.height);
        
        leftBarContainer.frame = CGRect(x: mainViewContainer.frame.minX - leftBarContainer.frame.width, y: leftBarContainer.frame.minY, width: leftBarContainer.frame.width, height: leftBarContainer.frame.height);
    }
    
    @objc func moveToSettings(_ sender: NSNotification){
        //print("called");
        UIView.animate(withDuration: 0.3, animations: {
            
            self.updateContainerViews(mainViewContainerMinX: -self.rightBarContainer.frame.width);
            
        });
    }
    
    @objc func moveToMain(_ sender: NSNotification){
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.updateContainerViews(mainViewContainerMinX: 0);
            
        });
        
    }
    
    @objc func presentInstrumentClusterPage(_ sender: NSNotification){
        self.presentContentPage(instrumentClusterViewController());
    }
    
    @objc func presentGraphPage(_ sender: NSNotification){
        
        guard let dict = sender.userInfo as? [String : Any] else{
            print("invalid dictionary")
            return;
        }
        
        guard let graphKey = dict["graphKey"] as? String else{
            print("graphkey not found")
            return;
        }
        
        //print("present")
        
        let vc = graphViewController();
        
        self.presentContentPage(vc);
        
        vc.setGraphKey(graphKey);
    }
    
    @objc func presentLogPage(_ sender: NSNotification){
        self.presentContentPage(logViewController());
    }
    
    @objc func presentContentPage(_ vc: UIViewController){
        vc.modalPresentationStyle = .fullScreen;
        self.present(vc, animated: true, completion: nil);
    }
}
