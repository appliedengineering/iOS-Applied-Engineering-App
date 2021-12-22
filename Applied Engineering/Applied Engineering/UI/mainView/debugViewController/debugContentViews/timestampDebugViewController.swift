//
//  timestampDebugViewController.swift
//  Applied Engineering
//
//  Created by Richard Wei on 12/19/21.
//

import Foundation
import UIKit

class timestampDebugViewController : debugContentViewController{
        
    init() {
        super.init(nibName: nil, bundle: nil);
        self.debugTitle = "Timestamp";
        self.widthToHeightRatio = 0.5;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    
    internal let receiveTimestampLabel : UILabel = UILabel();
    internal var receiveTimestampLabelHeightConstraint : NSLayoutConstraint? = nil;
    
    internal let currentTimestampLabel : UILabel = UILabel();
    internal var currentTimestampLabelHeightConstraint : NSLayoutConstraint? = nil;
    
    internal let startTimestampLabel : UILabel = UILabel();
    internal var startTimestampLabelHeightConstraint : NSLayoutConstraint? = nil;
        
    internal let syncButton : UIButton = UIButton();
    internal var syncButtonHeightConstraint : NSLayoutConstraint? = nil;
    
    internal let resultLabel : UILabel = UILabel();
    internal var resultLabelHeightConstraint : NSLayoutConstraint? = nil;
    
    private var waitingOnSyncResult : Bool = false;
    private var resultLabelTimer : Timer? = nil;
    
    internal var timestampTimer : Timer? = nil;
    
    //
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateReceivedTimestamp),name: NSNotification.Name(rawValue: dataUpdatedNotification), object: nil);

        //
        
        let verticalPaddingSum : CGFloat = verticalPadding * 2;
        let contentHeight = self.view.frame.height - verticalPaddingSum;
        
        //
        
        let labelContentHeight = contentHeight * 0.6;
        
        receiveTimestampLabelHeightConstraint?.constant = labelContentHeight / 3;
        currentTimestampLabelHeightConstraint?.constant = labelContentHeight / 3;
        startTimestampLabelHeightConstraint?.constant = labelContentHeight / 3;
        
        //
        
        syncButtonHeightConstraint?.constant = contentHeight * 0.22;
        resultLabelHeightConstraint?.constant = contentHeight * 0.18;
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: dataUpdatedNotification), object: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let labelFont = UIFont(name: Inter_SemiBold, size: AppUtility.getCurrentScreenSize().width * 0.05);
        
        //
        
        self.view.addSubview(receiveTimestampLabel);
        receiveTimestampLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        receiveTimestampLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        receiveTimestampLabel.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true;
        receiveTimestampLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        receiveTimestampLabelHeightConstraint = receiveTimestampLabel.heightAnchor.constraint(equalToConstant: 0)
        receiveTimestampLabelHeightConstraint?.isActive = true;
        
        receiveTimestampLabel.textColor = InverseBackgroundColor;
        receiveTimestampLabel.textAlignment = .left;
        receiveTimestampLabel.font = labelFont;
        receiveTimestampLabel.text = "Receive Timestamp = -1";
        receiveTimestampLabel.numberOfLines = 0;
        
        //receiveTimestampLabel.backgroundColor = .systemGreen;
        
        //
        
        self.view.addSubview(currentTimestampLabel);
        currentTimestampLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        currentTimestampLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        currentTimestampLabel.topAnchor.constraint(equalTo: receiveTimestampLabel.bottomAnchor).isActive = true;
        currentTimestampLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        currentTimestampLabelHeightConstraint = currentTimestampLabel.heightAnchor.constraint(equalToConstant: 0);
        currentTimestampLabelHeightConstraint?.isActive = true;
        
        currentTimestampLabel.textColor = InverseBackgroundColor;
        currentTimestampLabel.textAlignment = .left;
        currentTimestampLabel.font = labelFont;
        currentTimestampLabel.text = "Current Timestamp = -1";
        currentTimestampLabel.numberOfLines = 0;
        
        //
        
        self.view.addSubview(startTimestampLabel);
        startTimestampLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        startTimestampLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        startTimestampLabel.topAnchor.constraint(equalTo: currentTimestampLabel.bottomAnchor).isActive = true;
        //startTimestampLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
        startTimestampLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        startTimestampLabelHeightConstraint = startTimestampLabel.heightAnchor.constraint(equalToConstant: 0);
        startTimestampLabelHeightConstraint?.isActive = true;
        
        startTimestampLabel.textColor = InverseBackgroundColor;
        startTimestampLabel.textAlignment = .left;
        startTimestampLabel.font = labelFont;
        startTimestampLabel.text = "Start Timestamp = \(dataMgr.getStartTimestamp().truncate(places: 1))";
        startTimestampLabel.numberOfLines = 0;
        
        //
        
        self.view.addSubview(syncButton);
        syncButton.translatesAutoresizingMaskIntoConstraints = false;
        
        syncButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 7*horizontalPadding).isActive = true;
        syncButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -7*horizontalPadding).isActive = true;
        syncButton.topAnchor.constraint(equalTo: startTimestampLabel.bottomAnchor, constant: verticalPadding).isActive = true;

        syncButtonHeightConstraint = syncButton.heightAnchor.constraint(equalToConstant: 0);
        syncButtonHeightConstraint?.isActive = true;
        
        syncButton.backgroundColor = BackgroundGray;
        syncButton.layer.cornerRadius = 5;
        syncButton.clipsToBounds = true;
        
        syncButton.setTitle("Sync", for: .normal);
        syncButton.setTitleColor(InverseBackgroundColor, for: .normal);
        syncButton.titleLabel?.textAlignment = .center;
        syncButton.titleLabel?.font = UIFont(name: Inter_Medium, size: AppUtility.getCurrentScreenSize().width * 0.05);
        
        syncButton.addTarget(self, action: #selector(self.sendSyncRequest), for: .touchUpInside);
        
        //
        
        self.view.addSubview(resultLabel);
        resultLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        resultLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        resultLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        resultLabel.topAnchor.constraint(equalTo: syncButton.bottomAnchor, constant: verticalPadding).isActive = true;
        //resultLabel.bottomAnchor.constraint(equalTo: self.)
        
        resultLabelHeightConstraint = resultLabel.heightAnchor.constraint(equalToConstant: 0);
        resultLabelHeightConstraint?.isActive = true;
        
        resultLabel.textAlignment = .center;
        resultLabel.textColor = InverseBackgroundColor;
        resultLabel.font = UIFont(name: Inter_SemiBold, size: AppUtility.getCurrentScreenSize().width * 0.045);
        //resultLabel.text = "Success";
        
        //
        
        timestampTimer = Timer.scheduledTimer(timeInterval: CGFloat(preferences.receiveTimeout) / 1000, target: self, selector: #selector(self.updateCurrentTimestamp), userInfo: nil, repeats: true);
    }
    
    //
    
    @objc internal func updateReceivedTimestamp(){
        DispatchQueue.main.sync {
            
            let receive = dataMgr.getLatestTimestamp().truncate(places: 1);
            let curr = NSDate().timeIntervalSince1970.truncate(places: 1);
            
            receiveTimestampLabel.text = "Receive Timestamp = \(dataMgr.getLatestTimestamp().truncate(places: 1))";
            
            if (min(curr - receive, 0 ) >= 60 || receive < dataMgr.getStartTimestamp()){
                receiveTimestampLabel.textColor = .systemRed;
            }
            else{
                receiveTimestampLabel.textColor = InverseBackgroundColor;
            }
            
        }
    }
    
    @objc internal func updateCurrentTimestamp(){
        currentTimestampLabel.text = "Current Timestamp = \(NSDate().timeIntervalSince1970.truncate(places: 1))";
    }
    
    @objc internal func sendSyncRequest(){
        if (!waitingOnSyncResult){
            UINotificationFeedbackGenerator().notificationOccurred(.success);
            
            resultLabelTimer?.invalidate();
            resultLabelTimer = nil;
                        
            waitingOnSyncResult = true;
            resultLabel.text = "Waiting for reply...";
            resultLabel.textColor = InverseBackgroundColor;
            
            communication.sendSyncTimestampRequest(replyCompletion: { (reply) in
                //print("sync request outcome - \(reply)");
                
                self.resultLabel.text = reply ? "Successful" : "Failed";
                self.resultLabel.textColor = reply ? .systemGreen : .systemRed;
                
                self.waitingOnSyncResult = false;
                self.resultLabelTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.resetResultLabel), userInfo: nil, repeats: false);
            });
        }
    }
    
    @objc internal func resetResultLabel(){
        self.resultLabel.text = "";
        self.resultLabel.textColor = InverseBackgroundColor;
    }
}
