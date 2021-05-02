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
    
    private var graphButtonArray : [GraphUIButton] = [];
    private var statusLabelArray : [UILabel] = [];
    
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
        
        renderGraphs();
        renderLabels();
        
        mainScrollView.contentSize = CGSize(width: AppUtility.getCurrentScreenSize().width, height: nextY);
    }
    
    private func renderGraphs(){
        
        let graphViewHorizontalPadding = horizontalPadding / 2;
        
        for graphIndex in 0..<numberOfGraphableVars{
            
            let graphButtonWidth = AppUtility.getCurrentScreenSize().width - 2*graphViewHorizontalPadding;
            let graphButtonFrame = CGRect(x: graphViewHorizontalPadding, y: nextY, width: graphButtonWidth, height: graphButtonWidth * 0.5333);
            let graphButton = GraphUIButton(frame: graphButtonFrame, index: graphIndex);
            
            //graphButton.backgroundColor = .systemBlue;
            //
            
            //let graphView = LineChartView(frame: CGRect(x: 0, y: 0, width: graphButton.frame.width, height: graphButton.frame.height));
            
            graphButton.chartView.backgroundColor = .clear;
            graphButton.chartView.isUserInteractionEnabled = false;
            graphButton.chartView.xAxis.drawGridLinesEnabled = false;
            graphButton.chartView.leftAxis.drawAxisLineEnabled = false;
            graphButton.chartView.leftAxis.drawGridLinesEnabled = false;
            graphButton.chartView.rightAxis.drawAxisLineEnabled = false;
            graphButton.chartView.legend.enabled = false;
            graphButton.chartView.rightAxis.enabled = false;
            graphButton.chartView.xAxis.enabled = false;
            graphButton.chartView.drawGridBackgroundEnabled = false;
            
            //graphButton.addSubview(graphView);
            
            
            let graphLine = LineChartDataSet(entries: dataMgr.getGraphData(graphIndex), label: graphNameArray[graphIndex]);
            
            graphLine.fill = .fillWithLinearGradient(CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [graphColorArray[graphIndex].cgColor, UIColor.clear.cgColor] as CFArray, locations: [1.0, 0.0])!, angle: 90);
            graphLine.drawFilledEnabled = true;
            graphLine.drawCirclesEnabled = false;
            graphLine.drawValuesEnabled = false;
            graphLine.colors = [graphColorArray[graphIndex]];
            
            
            let graphLineData = LineChartData();
            
            graphLineData.addDataSet(graphLine);
            
            graphButton.chartView.data = graphLineData;
            
            //
            
            graphButton.tag = 1;
            graphButtonArray.append(graphButton);
            mainScrollView.addSubview(graphButton);
            nextY += graphButton.frame.height + verticalPadding;
            
        }
        
    }
    
    private func renderLabels(){
        
        let miscLabelWidth = AppUtility.getCurrentScreenSize().width - 2*horizontalPadding;
        let miscLabelFrame = CGRect(x: horizontalPadding, y: nextY, width: miscLabelWidth, height: miscLabelWidth * 0.15);
        let miscLabel = UILabel(frame: miscLabelFrame);
        miscLabel.text = "Miscellaneous";
        miscLabel.textColor = InverseBackgroundColor;
        miscLabel.font = UIFont(name: Inter_Bold, size: miscLabel.frame.height / 2);
        miscLabel.textAlignment = .left;
        
        nextY += miscLabel.frame.height + verticalPadding;
        mainScrollView.addSubview(miscLabel);
        
        let statusViewWidth = AppUtility.getCurrentScreenSize().width - 2*horizontalPadding;
        for statusIndex in 0..<numberOfStatusVars{
            let statusViewFrame = CGRect(x: horizontalPadding, y: nextY, width: statusViewWidth, height: statusViewWidth * 0.15);
            let statusView = UIView(frame: statusViewFrame);
            
            //
            let statusLeftLabel = UILabel();
            statusView.addSubview(statusLeftLabel);
            
            statusLeftLabel.translatesAutoresizingMaskIntoConstraints = false;
            statusLeftLabel.leadingAnchor.constraint(equalTo: statusView.leadingAnchor).isActive = true;
            statusLeftLabel.topAnchor.constraint(equalTo: statusView.topAnchor).isActive = true;
            statusLeftLabel.heightAnchor.constraint(equalTo: statusView.heightAnchor).isActive = true;
            
            statusLeftLabel.text = statusNameArray[statusIndex];
            statusLeftLabel.font = UIFont(name: Inter_SemiBold, size: statusView.frame.height * 0.34);
            statusLeftLabel.textAlignment = .left;
            statusLeftLabel.textColor = InverseBackgroundColor;
        
            //
            let statusRightLabel = UILabel();
            statusLabelArray.append(statusRightLabel);
            statusView.addSubview(statusRightLabel);
            
            statusRightLabel.translatesAutoresizingMaskIntoConstraints = false;
            statusRightLabel.leadingAnchor.constraint(equalTo: statusLeftLabel.leadingAnchor).isActive = true;
            statusRightLabel.topAnchor.constraint(equalTo: statusView.topAnchor).isActive = true;
            statusRightLabel.heightAnchor.constraint(equalTo: statusView.heightAnchor).isActive = true;
            statusRightLabel.trailingAnchor.constraint(equalTo: statusView.trailingAnchor).isActive = true;
            
            statusRightLabel.textAlignment = .right;
            statusRightLabel.textColor = .systemRed;
            
            statusRightLabel.font = UIFont(name: Inter_SemiBold, size: statusView.frame.height * 0.34);
            statusRightLabel.text = "No Data.";
            
            
            //
            
            nextY += statusView.frame.height + verticalPadding;
            mainScrollView.addSubview(statusView);
        }
        
    }
    
    
    @objc private func updateData(){
        
        for graphIndex in 0..<numberOfGraphableVars{
            let graphButton = graphButtonArray[graphIndex];
            let newData = dataMgr.getGraphData(graphIndex);
            
            guard let graphData = graphButton.chartView.data as? LineChartData else{
                continue;
            }
            
            guard let dataSet = graphData.dataSets[0] as? LineChartDataSet else{
                continue;
            }
            
            dataSet.replaceEntries(newData); // can be optimized
            
            graphButton.hasData = newData.count > 0;
            
            graphData.notifyDataChanged();
            
            DispatchQueue.main.sync {
                graphButton.chartView.notifyDataSetChanged();
            }
            
        }
        
    }
    
}
