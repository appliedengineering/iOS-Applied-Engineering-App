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
    
    internal let horizontalPadding = AppUtility.getCurrentScreenSize().width / 14;
    internal let verticalPadding : CGFloat = 10;
    
    internal var nextY : CGFloat = 0;
    internal var defaultNextY : CGFloat = 0;
    
    internal let mainScrollView : UIScrollView = UIScrollView();
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    //
    
    internal var isDisplayingData : [String : Bool] = [:];
    internal var graphForData : [String : GraphUIButton] = [:];
    
    internal let noDataLabel : UILabel = UILabel();
    
    //
    
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
        //mainScrollView.showsVerticalScrollIndicator = false;
        mainScrollView.showsHorizontalScrollIndicator = false;
        mainScrollView.alwaysBounceVertical = true;
        
        //
        
        mainScrollView.addSubview(refreshControl);
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged);
        
        //
        
        let graphLabelWidth = AppUtility.getCurrentScreenSize().width - 2*horizontalPadding;
        let graphLabelFrame = CGRect(x: horizontalPadding, y: 0, width: graphLabelWidth, height: graphLabelWidth * 0.15);
        let graphLabel = UILabel(frame: graphLabelFrame);
        
        graphLabel.text = "Telemetry Data";
        graphLabel.font = UIFont(name: Inter_Bold, size: graphLabel.frame.height / 2);
        graphLabel.textAlignment = .left;
        graphLabel.textColor = InverseBackgroundColor;
        
        mainScrollView.addSubview(graphLabel);
        nextY += graphLabel.frame.height;
        
        //
        
        let noDataLabelWidth = AppUtility.getCurrentScreenSize().width - 2*horizontalPadding;
        let noDataLabelFrame = CGRect(x: horizontalPadding, y: nextY, width: noDataLabelWidth, height: noDataLabelWidth * 0.15);
        noDataLabel.frame = noDataLabelFrame;
        
        noDataLabel.text = "No Data.";
        noDataLabel.font = UIFont(name: Inter_Regular, size: noDataLabel.frame.height * 0.35);
        noDataLabel.textAlignment = .center;
        noDataLabel.textColor = InverseBackgroundColor;
            
        mainScrollView.addSubview(noDataLabel);
        //nextY += noDataLabel.frame.height + verticalPadding;
        
        //
        
        mainScrollView.contentSize = CGSize(width: AppUtility.getCurrentScreenSize().width, height: nextY);
        
        //
        
        defaultNextY = nextY;
        
    }
    
    //
    
    
    internal func renderData(){
        for subview in mainScrollView.subviews{
            if (subview.tag == 1){
                subview.removeFromSuperview();
            }
        }
        
        nextY = defaultNextY;

        //
        
        if (!isDisplayingData.isEmpty){
            noDataLabel.isHidden = true;
            
            self.renderGraphs();
            self.renderStaticData();
        }
        else{
            noDataLabel.isHidden = false;
            mainScrollView.contentSize = CGSize(width: AppUtility.getCurrentScreenSize().width, height: nextY);
        }
    }
    
    internal func renderGraphs(){
            
        let graphViewHorizontalPadding : CGFloat = horizontalPadding/2;
     
        for graph in graphForData{
            
            let graphButton = graph.value;
            
            let graphButtonWidth = AppUtility.getCurrentScreenSize().width - 2*graphViewHorizontalPadding;
            let graphButtonFrame = CGRect(x: graphViewHorizontalPadding, y: nextY, width: graphButtonWidth, height: graphButtonWidth * 0.5333);
                        
            graphButton.updateFrame(graphButtonFrame);
            graphButton.frame = graphButtonFrame;
            graphButton.tag = 1;
            //graphButton.backgroundColor = .systemRed;
            
            mainScrollView.addSubview(graphButton);
            nextY += graphButton.frame.height + verticalPadding;
            
           // print("frame - \(graphButtonFrame) - \(graph.value.frame)")
            
        }
        
        mainScrollView.contentSize = CGSize(width: AppUtility.getCurrentScreenSize().width, height: nextY);

    }
    
    internal func renderStaticData(){
        
    }
    
}
