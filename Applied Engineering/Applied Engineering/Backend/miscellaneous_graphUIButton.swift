//
//  miscellaneous_graphUIButton.swift
//  Applied Engineering
//
//  Created by Richard Wei on 11/28/21.
//

import Foundation
import UIKit
import Charts

class GraphUIButton : UIButton{
    public var graphKey : String = "";
    
    private let graphTitleLabel : UILabel = UILabel();
    public let chartView : LineChartView = LineChartView();
    
    //
    
    private let noDataLabel = UILabel();
    
    init(frame: CGRect, key: String){
        super.init(frame: frame);
        graphKey = key;
        renderTitleLabel();
        setupGraph();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func renderTitleLabel(){
        
        let graphTitleLabelFont = UIFont(name: Inter_SemiBold, size: frame.height / 10)!;
        let graphTitleLabelText = "Graph Name";
        let graphTitleLabelWidth = frame.size.width;
        let graphTitleLabelHeight = graphTitleLabelText.getHeight(withConstrainedWidth: graphTitleLabelWidth, font: graphTitleLabelFont);
        
        let graphTitleLabelFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: graphTitleLabelHeight);
        graphTitleLabel.frame = graphTitleLabelFrame;
        
        graphTitleLabel.textAlignment = .right;
        graphTitleLabel.text = graphTitleLabelText;
        graphTitleLabel.font = graphTitleLabelFont;
        graphTitleLabel.textColor = InverseBackgroundColor;
        
        self.addSubview(graphTitleLabel);
    }
    
    private func setupGraph(){
        chartView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height);
        
        chartView.backgroundColor = .clear;
        chartView.isUserInteractionEnabled = false;
        chartView.xAxis.drawGridLinesEnabled = false;
        chartView.leftAxis.drawAxisLineEnabled = false;
        chartView.leftAxis.drawGridLinesEnabled = false;
        chartView.rightAxis.drawAxisLineEnabled = false;
        chartView.legend.enabled = false;
        chartView.rightAxis.enabled = false;
        chartView.xAxis.enabled = false;
        chartView.drawGridBackgroundEnabled = false;
        
        self.addSubview(chartView);
        
        //
        
        let testGraphName = "Graph Name";
        let testGraphColor = UIColor.systemBlue;
        
        let graphLine = LineChartDataSet(entries: dataMgr.getGraphDataFor(self.graphKey), label: testGraphName);
        
        graphLine.fill = .fillWithLinearGradient(CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [testGraphColor.cgColor, UIColor.clear.cgColor] as CFArray, locations: [1.0, 0.0])!, angle: 90);
        graphLine.drawFilledEnabled = true;
        graphLine.drawCirclesEnabled = false;
        graphLine.drawValuesEnabled = false;
        graphLine.colors = [testGraphColor];
        
        //
        
        let graphLineData = LineChartData();
        graphLineData.addDataSet(graphLine);
        self.chartView.data = graphLineData;
    }
    
    //
    
    public func updateFrame(_ newFrame: CGRect){
        self.frame = frame;
        
        self.chartView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height);
        self.graphTitleLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: self.graphTitleLabel.frame.height);
    }
    
}
//
