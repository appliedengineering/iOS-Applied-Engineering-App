//
//  graphViewController.swift
//  Applied Engineering
//
//  Created by Richard Wei on 11/17/21.
//

import Foundation
import UIKit
import Charts

class graphViewController : contentViewController, ChartViewDelegate{

    internal let backButton : UIButton = UIButton();
    internal var backButtonHeightConstraint : NSLayoutConstraint? = nil;
    
    internal var graphKey : String = "";
    private var graphColor : UIColor = .systemRed;
    private var graphTitleLabelText : String = "";
    
    internal let graphView : LineChartView = LineChartView();
    
    //
    
    public func setGraphKey(_ key: String){
        graphKey = key;
        graphColor = dataMgr.getGraphColorFor(key);
        graphTitleLabelText = dataMgr.getGraphTitleFor(key);
        setupGraph();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        self.view.addSubview(backButton);
        
        backButton.translatesAutoresizingMaskIntoConstraints = false;
        
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true;
        backButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        backButtonHeightConstraint = backButton.heightAnchor.constraint(equalToConstant: 0);
        backButtonHeightConstraint?.isActive = true;
        
        backButton.backgroundColor = .systemBlue;
        backButton.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside);
        
        //
        
        self.view.addSubview(graphView);
        
        graphView.translatesAutoresizingMaskIntoConstraints = false;
        
        graphView.topAnchor.constraint(equalTo: backButton.bottomAnchor).isActive = true;
        graphView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
        graphView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        graphView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        AppUtility.lockOrientation(.all);
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil);
        
        self.updateViewsWithScreenSize(AppUtility.getCurrentScreenSize());
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData), name: NSNotification.Name(rawValue: dataUpdatedNotification), object: nil);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: dataUpdatedNotification), object: nil);
    }
    
    //
    
    @objc internal func dismissVC(_ button: UIButton){
        self.dismiss(animated: true);
    }

    @objc internal func rotated(){
        updateViewsWithScreenSize(AppUtility.getCurrentScreenSize());
    }
    
    @objc internal func updateData(_ notification: NSNotification){
        //print("update data")
        
        guard let graphData = graphView.data as? LineChartData else{
            log.add("Missing Graph Data for graph \(graphKey)");
            return;
        }
        
        guard let dataSet = graphData.dataSets[0] as? LineChartDataSet else{
            log.add("Missing dataSet for graph \(graphKey)");
            return;
        }
        
        dataSet.replaceEntries(dataMgr.getGraphDataFor(graphKey)); // can be optimized
        
        //
        
        graphData.notifyDataChanged();
        
        DispatchQueue.main.sync {
            //print("graph button frame for \(graphKey) = \(graphButton.frame)")
            graphView.notifyDataSetChanged();
        }
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        print("graph value selected - \(entry)");
    }
    
    //
    
    private func updateViewsWithScreenSize(_ screenSize: CGSize){
        UIView.animate(withDuration: 1, animations: {
            self.backButtonHeightConstraint?.constant = (screenSize.width * (AppUtility.getCurrentScreenOrientation() == .portrait ? 0.1 : 0.01)) + AppUtility.safeAreaInset.top;
        });
    }
    
    private func setupGraph(){
        graphView.backgroundColor = .clear;
        graphView.isUserInteractionEnabled = true;
        graphView.xAxis.drawGridLinesEnabled = false;
        graphView.leftAxis.drawAxisLineEnabled = false;
        graphView.leftAxis.drawGridLinesEnabled = false;
        graphView.rightAxis.drawAxisLineEnabled = false;
        graphView.legend.enabled = false;
        graphView.rightAxis.enabled = false;
        graphView.xAxis.enabled = false;
        graphView.drawGridBackgroundEnabled = false;
        graphView.delegate = self;
        
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
        self.graphView.data = graphLineData;
    }
    
}
