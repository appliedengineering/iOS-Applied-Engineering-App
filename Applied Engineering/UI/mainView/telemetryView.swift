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
        
        renderGraphs();
    }
    
    private func renderGraphs(){
        
        let graphViewHorizontalPadding = horizontalPadding / 2;
        
        for graphIndex in 0..<numberOfGraphableVars{
            
            let graphButtonWidth = AppUtility.getCurrentScreenSize().width - 2*graphViewHorizontalPadding;
            let graphButtonFrame = CGRect(x: graphViewHorizontalPadding, y: nextY, width: graphButtonWidth, height: graphButtonWidth * 0.5333);
            let graphButton = GraphUIButton(frame: graphButtonFrame, index: graphIndex);
            
            //graphButton.backgroundColor = .systemBlue;
            //
            
            let graphView = LineChartView(frame: CGRect(x: 0, y: 0, width: graphButton.frame.width, height: graphButton.frame.height));
            
            graphView.backgroundColor = .clear;
            graphView.isUserInteractionEnabled = false;
            graphView.xAxis.drawGridLinesEnabled = false;
            graphView.leftAxis.drawAxisLineEnabled = false;
            graphView.leftAxis.drawGridLinesEnabled = false;
            graphView.rightAxis.drawAxisLineEnabled = false;
            graphView.legend.enabled = false;
            graphView.rightAxis.enabled = false;
            graphView.xAxis.enabled = false;
            graphView.drawGridBackgroundEnabled = false;
            
            graphButton.addSubview(graphView);
            
            
            let graphLine = LineChartDataSet(entries: dataMgr.getGraphData(graphIndex), label: graphNameArray[graphIndex]);
            
            graphLine.fill = .fillWithLinearGradient(CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [graphColorArray[graphIndex].cgColor, UIColor.clear.cgColor] as CFArray, locations: [1.0, 0.0])!, angle: 90);
            graphLine.drawFilledEnabled = true;
            graphLine.drawCirclesEnabled = false;
            graphLine.drawValuesEnabled = false;
            graphLine.colors = [graphColorArray[graphIndex]];
            
            
            let graphLineData = LineChartData();
            
            graphLineData.addDataSet(graphLine);
            
            graphView.data = graphLineData;
            
            //
            
            graphButton.tag = 1;
            mainScrollView.addSubview(graphButton);
            nextY += graphButton.frame.height + verticalPadding;
            
        }
        
        mainScrollView.contentSize = CGSize(width: AppUtility.getCurrentScreenSize().width, height: nextY);
        
    }
    
    
}
