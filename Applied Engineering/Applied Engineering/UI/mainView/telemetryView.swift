//
//  telemetryView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/20/21.
//

import Foundation
import UIKit
import Charts

class telemetryViewController : UIViewController{
    
    private let horizontalPadding = AppUtility.getCurrentScreenSize().width / 14;
    private let verticalPadding = CGFloat(10);
    
    private var nextY : CGFloat = 0;
    private let mainScrollView : UIScrollView = UIScrollView();

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
     
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData), name: NSNotification.Name(rawValue: dataUpdatedNotification), object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: dataUpdatedNotification), object: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.addSubview(mainScrollView);
        mainScrollView.showsVerticalScrollIndicator = false;
        mainScrollView.showsHorizontalScrollIndicator = false;
        
        let graphLabelWidth = AppUtility.getCurrentScreenSize().width - 2*horizontalPadding;
        let graphLabelFrame = CGRect(x: horizontalPadding, y: 0, width: graphLabelWidth, height: graphLabelWidth * 0.15);
        let graphLabel = UILabel(frame: graphLabelFrame);
        
        graphLabel.text = "Telemetry Data";
        graphLabel.font = UIFont(name: Inter_Bold, size: graphLabel.frame.height / 2);
        graphLabel.textAlignment = .left;

        mainScrollView.addSubview(graphLabel);
        nextY += graphLabel.frame.height;
        
        /*
        
        let seperatorViewFrame = CGRect(x: 0, y: nextY, width: AppUtility.getCurrentScreenSize().width, height: 1);
        let seperatorView = UIView(frame: seperatorViewFrame);
        
        seperatorView.backgroundColor = BackgroundGray;
        
        mainScrollView.addSubview(seperatorView);
        nextY += seperatorView.frame.height + verticalPadding;
        
        */
        

        
        mainScrollView.contentSize = CGSize(width: AppUtility.getCurrentScreenSize().width, height: nextY);
    }
    
    //
    
    @objc internal func updateData(_ notification: NSNotification){
        
    }
    
    @objc internal func openGraph(_ button: GraphUIButton){
        print(button.graphIndex);
    }
    
}
