//
//  telemetryView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/20/21.
//

import Foundation
import UIKit

class telemetryViewController : UIViewController{
    
    private let horizontalPadding = AppUtility.getCurrentScreenSize().width / 14;
    private let verticalPadding = CGFloat(10);
    
    private var nextY : CGFloat = 0;
    private let mainScrollView : UIScrollView = UIScrollView();
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.addSubview(mainScrollView);
        
        let graphLabelWidth = AppUtility.getCurrentScreenSize().width - 2*horizontalPadding;
        let graphLabelFrame = CGRect(x: horizontalPadding, y: 0, width: graphLabelWidth, height: graphLabelWidth * 0.15);
        let graphLabel = UILabel(frame: graphLabelFrame);
        
        graphLabel.text = "Telemetry Data";
        graphLabel.font = UIFont(name: Inter_Bold, size: graphLabel.frame.height / 2);
        graphLabel.textAlignment = .left;

        mainScrollView.addSubview(graphLabel);
        nextY += graphLabel.frame.height;
        
        //
        
        let seperatorViewFrame = CGRect(x: 0, y: nextY, width: AppUtility.getCurrentScreenSize().width, height: 1);
        let seperatorView = UIView(frame: seperatorViewFrame);
        
        seperatorView.backgroundColor = BackgroundGray;
        
        mainScrollView.addSubview(seperatorView);
        nextY += seperatorView.frame.height + verticalPadding;
        
        //
        
        renderGraphs();
    }
    
    private func renderGraphs(){
        
        let graphViewHorizontalPadding = horizontalPadding / 2;
        
        for graphIndex in 0..<numberOfGraphableVars{
            
            let graphButtonWidth = AppUtility.getCurrentScreenSize().width - 2*graphViewHorizontalPadding;
            let graphButtonFrame = CGRect(x: graphViewHorizontalPadding, y: nextY, width: graphButtonWidth, height: graphButtonWidth * 0.5333);
            let graphButton = UIButton(frame: graphButtonFrame);
            
            graphButton.backgroundColor = .systemBlue;
            
            graphButton.tag = graphIndex;
            mainScrollView.addSubview(graphButton);
            nextY += graphButton.frame.height + verticalPadding;
            
        }
        
        mainScrollView.contentSize = CGSize(width: AppUtility.getCurrentScreenSize().width, height: nextY);
        
    }
    
}
