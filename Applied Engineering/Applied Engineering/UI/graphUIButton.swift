//
//  graphUIButton.swift
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
    private var graphTitleLabelText : String = "";
    private let graphTitleLabelFont = Inter_SemiBold;
    
    private var graphColor : UIColor = .systemBlue;
    public let chartView : LineChartView = LineChartView();
        
    //
    
    private let noDataLabel = UILabel();
    
    init(frame: CGRect, key: String){
        super.init(frame: frame);
        graphKey = key;
        graphTitleLabelText = dataMgr.getGraphTitleFor(graphKey);
        graphColor = dataMgr.getGraphColorFor(graphKey);
        
        setupGraph();
        renderTitleLabel();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func getTitleLabelSize(_ parentFrame: CGRect) -> CGSize{
        let graphTitleLabelFont = UIFont(name: Inter_SemiBold, size: parentFrame.height / 10)!;
        let graphTitleLabelWidth = parentFrame.size.width;
        let graphTitleLabelHeight = graphTitleLabelText.getHeight(withConstrainedWidth: graphTitleLabelWidth, font: graphTitleLabelFont);
        return CGSize(width: graphTitleLabelWidth, height: graphTitleLabelHeight);
    }
    
    private func renderTitleLabel(){

        let graphTitleLabelSize = getTitleLabelSize(self.frame);
        
        let graphTitleLabelFrame = CGRect(x: 0, y: 0, width: graphTitleLabelSize.width, height: graphTitleLabelSize.height);
        graphTitleLabel.frame = graphTitleLabelFrame;
        
        graphTitleLabel.textAlignment = .right;
        graphTitleLabel.text = graphTitleLabelText;
        graphTitleLabel.font = UIFont(name: graphTitleLabelFont, size: graphTitleLabelSize.height * 0.7)!;
        graphTitleLabel.textColor = InverseBackgroundColor;
        //graphTitleLabel.backgroundColor = InverseBackgroundColor;
        graphTitleLabel.numberOfLines = 1;
        
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
        
        let graphLine = LineChartDataSet(entries: dataMgr.getGraphDataFor(self.graphKey), label: graphTitleLabelText);
        
        graphLine.fill = .fillWithLinearGradient(CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [graphColor.cgColor, UIColor.clear.cgColor] as CFArray, locations: [1.0, 0.0])!, angle: 90);
        graphLine.drawFilledEnabled = true;
        graphLine.drawCirclesEnabled = false;
        graphLine.drawValuesEnabled = false;
        graphLine.colors = [graphColor];
        
        //
        
        let graphLineData = LineChartData();
        graphLineData.addDataSet(graphLine);
        self.chartView.data = graphLineData;
    }
    
    //
    
    public func updateFrame(_ newFrame: CGRect){
        self.frame = frame;
        
        self.chartView.frame = CGRect(x: 0, y: 0, width: newFrame.size.width, height: newFrame.size.height);
        self.chartView.setNeedsDisplay();
        self.chartView.setNeedsLayout();
        
        let graphTitleLabelSize = getTitleLabelSize(newFrame);
        self.graphTitleLabel.frame = CGRect(x: 0, y: 0, width: graphTitleLabelSize.width, height: graphTitleLabelSize.height);
        self.graphTitleLabel.font = UIFont(name: graphTitleLabelFont, size: graphTitleLabelSize.height * 0.7);
        
        //print("\(self.frame) = new frames - \(self.chartView.frame) and \(self.graphTitleLabel.frame)")
        
    }
    
}
//
