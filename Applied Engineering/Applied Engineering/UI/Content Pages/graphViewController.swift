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

    private let horizontalTopBarRatio : CGFloat = 0.006;
    private let verticalTopBarRatio : CGFloat = 0.025;
    
    internal let backButton : UIButton = UIButton();
    internal var backButtonHeightConstraint : NSLayoutConstraint? = nil;
    internal var backButtonTopAnchorConstraint : NSLayoutConstraint? = nil;
    
    internal let dataButton : UIButton = UIButton();
    internal var dataButtonTrailingConstraint : NSLayoutConstraint? = nil;
    internal var dataButtonWidthConstraint : NSLayoutConstraint? = nil;
    
    internal var graphKey : String = "";
    private var graphColor : UIColor = .systemRed;
    private var graphTitleLabelText : String = "";
    
    internal let graphView : LineChartView = LineChartView();
    internal let graphTitleLabel : UILabel = UILabel();
    
    internal let graphValueLabel : UILabel = UILabel();
    //internal let graphValueLabelTextPrecision : Int = 0;
    
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
        
        backButtonTopAnchorConstraint = backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: AppUtility.safeAreaInset.top);
        backButtonTopAnchorConstraint?.isActive = true;
        
        backButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        backButtonHeightConstraint = backButton.heightAnchor.constraint(equalToConstant: 0);
        backButtonHeightConstraint?.isActive = true;
        
        //backButton.backgroundColor = .systemBlue;
        backButton.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside);
        
        setupTopBar();
        
        //
        
        self.view.addSubview(dataButton);
        
        dataButton.translatesAutoresizingMaskIntoConstraints = false;
        
        dataButtonTrailingConstraint = dataButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0);
        dataButtonTrailingConstraint?.isActive = true;
        
        dataButton.topAnchor.constraint(equalTo: backButton.topAnchor).isActive = true;
        
        dataButtonWidthConstraint = dataButton.widthAnchor.constraint(equalToConstant: 0);
        dataButtonWidthConstraint?.isActive = true;
        
        dataButton.heightAnchor.constraint(equalTo: backButton.heightAnchor).isActive = true;
        
        //dataButton.backgroundColor = .systemBlue;
        dataButton.tintColor = InverseBackgroundColor;
        dataButton.imageView?.contentMode = .scaleAspectFit;
        dataButton.addTarget(self, action: #selector(self.toggleDataButton), for: .touchUpInside);
        updateDataButton();
        
        //
        
        self.view.addSubview(graphView);
        
        graphView.translatesAutoresizingMaskIntoConstraints = false;
        
        graphView.topAnchor.constraint(equalTo: backButton.bottomAnchor).isActive = true;
        graphView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
        graphView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        graphView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        //
        
        let graphValueLabelHorizontalPadding : CGFloat = 10;
        
        self.view.addSubview(graphValueLabel);
        
        graphValueLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        graphValueLabel.topAnchor.constraint(equalTo: graphView.topAnchor).isActive = true;
        graphValueLabel.trailingAnchor.constraint(equalTo: graphView.trailingAnchor, constant: -graphValueLabelHorizontalPadding).isActive = true;
        graphValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: graphView.leadingAnchor, constant: graphValueLabelHorizontalPadding).isActive = true;
        
        graphValueLabel.textAlignment = .right;
        graphValueLabel.textColor = InverseBackgroundColor;
        graphValueLabel.font = UIFont(name: Inter_Regular, size: AppUtility.originalWidth * 0.03);
        graphValueLabel.numberOfLines = 0;
        
        //
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        AppUtility.lockOrientation(.all);
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil);
        
        self.updateViewsWithScreenSize(AppUtility.getCurrentScreenSize());
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData), name: NSNotification.Name(rawValue: dataUpdatedNotification), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDataButtonStatus), name: NSNotification.Name(rawValue: connectionStatusUpdatedNotification), object: nil);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: dataUpdatedNotification), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: connectionStatusUpdatedNotification), object: nil);

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
    
    @objc internal func toggleDataButton(_ button: UIButton){
        dataMgr.setShouldReceiveData(!dataMgr.isReceivingData());
        updateDataButton();
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        //print("graph value selected - \(entry)");
        graphValueLabel.text = "Selected point (\(entry.x), \(entry.y))";
    }
    
    //
    
    private func updateViewsWithScreenSize(_ screenSize: CGSize){
        UIView.animate(withDuration: 1, animations: {
            
            let isPortrait : Bool = AppUtility.getCurrentScreenOrientation() == .portrait;
            
            self.backButtonHeightConstraint?.constant = (screenSize.width * (isPortrait ? self.verticalTopBarRatio : self.horizontalTopBarRatio)) + AppUtility.safeAreaInset.top;
            
            self.backButtonTopAnchorConstraint?.constant = (isPortrait ? AppUtility.safeAreaInset.top : 0);
            
            self.dataButtonWidthConstraint?.constant = self.backButtonHeightConstraint?.constant ?? 0;
            
            self.dataButtonTrailingConstraint?.constant = -(isPortrait ? 10 : 20);
            
        });
    }
    
    private func updateDataButton(){
        self.dataButton.setImage((dataMgr.isReceivingData() ? dataButtonOnImage : dataButtonOffImage), for: .normal);
    }
    
    @objc private func updateDataButtonStatus(_ notification: NSNotification){
        
        guard let dict = notification.userInfo as NSDictionary? else{
            return;
        }
        
        guard let isConnected = dict["isConnected"] as? Bool else{
            return;
        }
        
        dataButton.tintColor = isConnected ? dataButtonOnColor : dataButtonOffColor;
        
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
        
        //
        
        graphTitleLabel.text = graphTitleLabelText;
    }
    
    private func setupTopBar(){
        backButton.backgroundColor = BackgroundColor;
        
        //
        
        backButton.addSubview(graphTitleLabel);
        
        graphTitleLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        graphTitleLabel.centerXAnchor.constraint(equalTo: backButton.centerXAnchor).isActive = true;
        graphTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true;
        
        graphTitleLabel.numberOfLines = 1;
        graphTitleLabel.textColor = InverseBackgroundColor;
        graphTitleLabel.font = UIFont(name: Inter_Bold, size: AppUtility.originalWidth * 0.05);
        graphTitleLabel.textAlignment = .center;
        
        //
        
        let chevronImageView = UIImageView();
        let chevronImageViewHorizontalPadding : CGFloat = 20;
        
        backButton.addSubview(chevronImageView);
        
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        chevronImageView.leadingAnchor.constraint(equalTo: backButton.leadingAnchor, constant: chevronImageViewHorizontalPadding).isActive = true;
        
        /*chevronImageView.topAnchor.constraint(greaterThanOrEqualTo: backButton.topAnchor, constant: chevronImageViewPadding).isActive = true;
        chevronImageView.bottomAnchor.constraint(lessThanOrEqualTo: backButton.bottomAnchor, constant: -chevronImageViewPadding).isActive = true;*/
        chevronImageView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true;
        
        chevronImageView.image = UIImage(systemName: "chevron.left");
        chevronImageView.tintColor = InverseBackgroundColor;
        
    }
    
}
