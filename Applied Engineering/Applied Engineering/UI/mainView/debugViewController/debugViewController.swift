//
//  debugViewController.swift
//  Applied Engineering
//
//  Created by Richard Wei on 12/19/21.
//

import Foundation
import UIKit
import Charts

class debugViewController : contentViewController{
    
    private let debugViewControllers : [debugContentViewController] = [timestampDebugViewController(), logDebugViewController()];
    
    //
    
    internal let horizontalPadding = AppUtility.getCurrentScreenSize().width / 28;
    internal let verticalPadding : CGFloat = 10;
    
    internal let mainScrollView : UIScrollView = UIScrollView();
    
    //

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.addSubview(mainScrollView);
        
        mainScrollView.showsHorizontalScrollIndicator = false;
        mainScrollView.alwaysBounceVertical = true;
        
        //
        
        //mainScrollView.backgroundColor = .systemBlue;
        
        var nextY : CGFloat = 0;
        
        for vc in debugViewControllers{
            
            let contentWidth = AppUtility.getCurrentScreenSize().width - 2*horizontalPadding;
            
            //
            
            let vcTitleLabelHeight = contentWidth * 0.11;
            let vcTitleLabelFrame = CGRect(x: horizontalPadding, y: nextY, width: contentWidth, height: vcTitleLabelHeight);
            let vcTitleLabel = UILabel(frame: vcTitleLabelFrame);
            
            vcTitleLabel.text = vc.getDebugTitle();
            vcTitleLabel.textAlignment = .left;
            vcTitleLabel.textColor = InverseBackgroundColor;
            vcTitleLabel.font = UIFont(name: Inter_Bold, size: vcTitleLabel.frame.height * 0.7);
            //vcTitleLabel.backgroundColor = .systemBlue

            mainScrollView.addSubview(vcTitleLabel);
            nextY += vcTitleLabel.frame.height + verticalPadding;
            
            //
            
            let parentViewHeight = contentWidth * vc.getWidthToHeightRatio();
            let parentViewFrame = CGRect(x: horizontalPadding, y: nextY, width: contentWidth, height: parentViewHeight);
            let parentView = UIView(frame: parentViewFrame);
            
            //parentView.backgroundColor = .systemGreen;
            
            linkViewControllerToView(view: parentView, controller: vc, parentController: self);
            
            mainScrollView.addSubview(parentView);
            nextY += parentView.frame.height + verticalPadding;
            
        }
        
    }
}
