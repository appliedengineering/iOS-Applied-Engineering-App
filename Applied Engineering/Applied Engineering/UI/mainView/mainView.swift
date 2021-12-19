//
//  mainView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/7/21.
//

import Foundation
import UIKit

class mainViewController : UIViewController{
    
    internal let contentViewControllers : [UIViewController?] = [telemetryViewController(), nil, debugViewController(), nil];
    internal var previousViewControllerIndex : Int = -1;
    internal var hasSetup = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        NotificationCenter.default.addObserver(self, selector: #selector(self.setContentHandler), name: NSNotification.Name(rawValue: mainViewSetContentViewNotification), object: nil);
        self.hideKeyboardWhenTappedAround();
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: mainViewSetContentViewNotification), object: nil);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!hasSetup){
            setContent(0);
            hasSetup = true;
        }
        
    }
    
    @objc func setContentHandler(_ sender: NSNotification){
        
        guard let dict = sender.userInfo as NSDictionary? else{
            return;
        }
        
        guard let contentIndex = dict["contentIndex"] as? Int else{
            return;
        }
        
        setContent(contentIndex);
        
    }
    
    private func setContent(_ contentIndex: Int){
        if (previousViewControllerIndex != contentIndex){
            
            if (previousViewControllerIndex != -1){
                for views in self.view.subviews{
                    views.removeFromSuperview();
                }
                
                let vc = contentViewControllers[previousViewControllerIndex]!;
                
                vc.willMove(toParent: nil);
                vc.view.removeFromSuperview();
                vc.removeFromParent();
            }
            
            previousViewControllerIndex = contentIndex;
            linkViewControllerToView(view: self.view, controller: contentViewControllers[contentIndex]!, parentController: self);
        }
    }
}
