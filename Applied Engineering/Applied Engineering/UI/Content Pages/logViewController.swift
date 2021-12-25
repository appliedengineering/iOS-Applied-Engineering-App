//
//  logViewController.swift
//  Applied Engineering
//
//  Created by Richard Wei on 12/24/21.
//

import Foundation
import UIKit

class logViewController : contentViewController{
    
    //
    
    internal let topBarRatio : CGFloat = 0.03;
    
    internal let verticalPadding : CGFloat = 10;
    internal let horizontalPadding : CGFloat = AppUtility.getCurrentScreenSize().width / 20;
        
    internal let mainScrollView : UIScrollView = UIScrollView();
    internal let refreshControl = UIRefreshControl();
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        let topBarButton = UIButton();
        
        topBarButton.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(topBarButton);
        
        topBarButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        topBarButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: AppUtility.safeAreaInset.top).isActive = true;
        topBarButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        let topBarButtonHeight = self.view.frame.height * topBarRatio;
        topBarButton.heightAnchor.constraint(equalToConstant: topBarButtonHeight).isActive = true;
        
        topBarButton.setTitle("Logs", for: .normal);
        topBarButton.setTitleColor(InverseBackgroundColor, for: .normal);
        topBarButton.titleLabel?.contentMode = .center;
        topBarButton.titleLabel?.font = UIFont(name: Inter_Bold, size: self.view.frame.width * 0.05);
        
        topBarButton.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside);
        
        //
        
        let topBarImageView = UIImageView();
        
        topBarImageView.translatesAutoresizingMaskIntoConstraints = false;
        topBarButton.addSubview(topBarImageView);
        
        topBarImageView.leadingAnchor.constraint(equalTo: topBarButton.leadingAnchor, constant: horizontalPadding).isActive = true;
        topBarImageView.topAnchor.constraint(equalTo: topBarButton.topAnchor).isActive = true;
        topBarImageView.bottomAnchor.constraint(equalTo: topBarButton.bottomAnchor).isActive = true;
        topBarImageView.widthAnchor.constraint(equalToConstant: topBarButtonHeight).isActive = true;
        
        topBarImageView.tintColor = InverseBackgroundColor;
        topBarImageView.image = UIImage(systemName: "chevron.left");
        topBarImageView.contentMode = .scaleAspectFit;
        
        //
        
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(mainScrollView);
        
        mainScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        mainScrollView.topAnchor.constraint(equalTo: topBarButton.bottomAnchor, constant: verticalPadding).isActive = true;
        mainScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
        mainScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        mainScrollView.alwaysBounceVertical = true;
        
        mainScrollView.addSubview(refreshControl);
        
        refreshControl.addTarget(self, action: #selector(self.renderScrollView), for: .valueChanged);
        
        renderScrollView();
    }
    
    //
    
    @objc internal func renderScrollView(){
        self.refreshControl.endRefreshing();
        
        for subview in mainScrollView.subviews{
            if (subview.tag == 1){
                subview.removeFromSuperview();
            }
        }
        
        //
        
        var nextY : CGFloat = verticalPadding;
        
        for log in log.getBuffer(){
            
            let isCriticalLog = (log.range(of: "Critical:")?.lowerBound.utf16Offset(in: log) ?? -1) == 0;
            
            let logLabelText = log;
            let logLabelWidth = AppUtility.getCurrentScreenSize().width - 2*horizontalPadding;
            let logLabelFont = UIFont(name: Inter_SemiBold, size: AppUtility.getCurrentScreenSize().width * 0.035)!;
            let logLabelHeight = logLabelText.getHeight(withConstrainedWidth: logLabelWidth, font: logLabelFont);
            let logLabelFrame = CGRect(x: horizontalPadding, y: nextY, width: logLabelWidth, height: logLabelHeight);
            let logLabel = UILabel(frame: logLabelFrame);
            
            logLabel.text = logLabelText;
            logLabel.font = logLabelFont;
            logLabel.textAlignment = .left;
            logLabel.textColor = isCriticalLog ? .systemRed : InverseBackgroundColor;
            logLabel.numberOfLines = 0;
            
            logLabel.tag = 1;
            
            mainScrollView.addSubview(logLabel);
            nextY += logLabel.frame.height + verticalPadding;
        }
        
        mainScrollView.contentSize = CGSize(width: AppUtility.getCurrentScreenSize().width, height: nextY);
        
    }
    
    @objc internal func dismissVC(_ button: UIButton){
        self.dismiss(animated: true);
    }
    
}
