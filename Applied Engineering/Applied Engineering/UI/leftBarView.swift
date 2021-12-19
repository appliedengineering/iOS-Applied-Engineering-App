//
//  leftBarView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/7/21.
//

import Foundation
import UIKit

class leftBarViewController : UIViewController{
    
    internal var topView : UIView = UIView();
    internal var hasSetup = false;
    
    //

    private let leftBarContentTitles : [String] = ["Telemetry", "Instrument\nCluster", "Debug", "Settings"];
    private let leftBarContentImageNames : [String] = ["list.bullet.rectangle", "speedometer", "ladybug", "gearshape"]; // system image names
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    
        if (!hasSetup){
            renderTopView();
            renderList();
            
            self.view.backgroundColor = BackgroundColor;
            hasSetup = true;
        }
    }
    
    @objc func updateMainView(_ sender: UIButton){
        //print(sender.tag);
        if (sender.tag == leftBarContentTitles.firstIndex(of: "Instrument\nCluster")!){ // instrument cluster page
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: layoutMainViewNotification), object: nil, userInfo: nil);
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: layoutContentInstrumentClusterPage), object: nil, userInfo: nil);
        }
        else if (sender.tag == leftBarContentTitles.firstIndex(of: "Settings")!){ // settings was clicked
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: layoutSettingsViewNotification), object: nil, userInfo: nil);
        }
        else{
            var dataDict : [String : Any] = [:];
            dataDict["contentIndex"] = sender.tag;
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: mainViewSetContentViewNotification), object: nil, userInfo: dataDict);
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: layoutMainViewNotification), object: nil, userInfo: nil);
        }
    }
    
    private func renderTopView(){
        topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.frame.height / 12));
        self.view.addSubview(topView);

        // vars needed beforehand to calculate width of topContentView
        
        let iconImageViewPadding = CGFloat(5);
        let iconImageViewSize = topView.frame.height - 2*iconImageViewPadding;
        
        let titleLabelVerticalPadding = CGFloat(10);
        
        let titleTopLabelText = "applied";
        let titleBottomLabelText = "engineering";
        let titleLabelHeight = topView.frame.height / 2 - titleLabelVerticalPadding;
        let titleLabelFont = UIFont(name: Inter_Bold, size: titleLabelHeight * 0.8)!;
        let titleLabelsMaxWidth = max(titleTopLabelText.getWidth(withConstrainedHeight: titleLabelHeight, font: titleLabelFont), titleBottomLabelText.getWidth(withConstrainedHeight: titleLabelHeight, font: titleLabelFont));
        
        //
        
        let topContentViewWidth = 2*iconImageViewPadding + iconImageViewSize + titleLabelsMaxWidth + 10;
        let topContentViewFrame = CGRect(x: (topView.frame.width / 2) - (topContentViewWidth / 2), y: 0, width: topContentViewWidth, height: topView.frame.height);
        let topContentView = UIView(frame: topContentViewFrame);
        
        //topContentView.backgroundColor = .systemRed;
        
        topView.addSubview(topContentView);
        
        let iconImageViewFrame = CGRect(x: iconImageViewPadding, y: iconImageViewPadding, width: iconImageViewSize, height: iconImageViewSize);
        let iconImageView = UIImageView(frame: iconImageViewFrame);
        iconImageView.image = UIImage(named: "AELogo");
        iconImageView.contentMode = .scaleAspectFit;
        //iconImageView.backgroundColor = .systemRed;
        
        topContentView.addSubview(iconImageView);
        
        let titleTopLabelFrame = CGRect(x: iconImageView.frame.width + 2*iconImageViewPadding, y: titleLabelVerticalPadding, width: topContentView.frame.width - iconImageView.frame.width - 2*iconImageViewPadding, height: topContentView.frame.height / 2 - titleLabelVerticalPadding);
        let titleTopLabel = UILabel(frame: titleTopLabelFrame);
        
        //titleLabel.numberOfLines = 0;
        titleTopLabel.text = titleTopLabelText;
        titleTopLabel.textColor = InverseBackgroundColor;
        titleTopLabel.font = titleLabelFont;
        //titleTopLabel.backgroundColor = .systemPink
        
        topContentView.addSubview(titleTopLabel);
        
        //
        
        let titleBottomLabelFrame = CGRect(x: titleTopLabel.frame.minX, y: titleTopLabel.frame.maxY, width: titleTopLabel.frame.width, height: titleTopLabel.frame.height);
        let titleBottomLabel = UILabel(frame: titleBottomLabelFrame);
        
        titleBottomLabel.text = titleBottomLabelText;
        titleBottomLabel.textColor = InverseBackgroundColor;
        titleBottomLabel.font = titleLabelFont;
        //titleBottomLabel.backgroundColor = .systemBlue;
        
        topContentView.addSubview(titleBottomLabel);
        
        // --
        
        let seperatorViewHeight = CGFloat(1);
        let seperatorViewFrame = CGRect(x: 0, y: topView.frame.height + 2*seperatorViewHeight, width: topView.frame.width, height: seperatorViewHeight);
        let seperatorView = UIView(frame: seperatorViewFrame);
        seperatorView.backgroundColor = BackgroundGray;
        
        topView.addSubview(seperatorView);
        
    }
    
    private func renderList(){
        let listViewFrame = CGRect(x: 0, y: topView.frame.height, width: self.view.frame.width, height: self.view.frame.height - topView.frame.height);
        let listView = UIScrollView(frame: listViewFrame);
        //listView.backgroundColor = .systemRed;
        self.view.addSubview(listView);
        
        let listHeightPadding = CGFloat(2);
        var nextY : CGFloat = listHeightPadding;
        
        for i in 0..<leftBarContentTitles.count{
            
            let buttonFrame = CGRect(x: 0, y: nextY, width: listView.frame.width, height: listView.frame.height / 8);
            let button = UIButton(frame: buttonFrame);
            //button.layer.borderWidth = 1;
            //button.layer.borderColor = BackgroundGray.cgColor;
            //button.backgroundColor = BackgroundGray;
            
            //
            let imageViewPadding = CGFloat(15);
            let imageViewSize = button.frame.height - 2*imageViewPadding;
            let imageViewFrame = CGRect(x: imageViewPadding, y: imageViewPadding, width: imageViewSize, height: imageViewSize);
            let imageView = UIImageView(frame: imageViewFrame);
            
            //imageView.backgroundColor = .systemRed;
            imageView.image = UIImage(systemName: leftBarContentImageNames[i]);
            imageView.contentMode = .scaleAspectFit;
            imageView.tintColor = AccentColor;
            
            button.addSubview(imageView);
            
            //
            let labelHorizontalPadding = CGFloat(5);
            let labelFrame = CGRect(x: imageView.frame.width + 2*imageViewPadding + labelHorizontalPadding, y: 0, width: button.frame.width - imageView.frame.width - 2*labelHorizontalPadding - 2*imageViewPadding, height: button.frame.height);
            let label = UILabel(frame: labelFrame);
            
            label.textAlignment = .left;
            label.text = leftBarContentTitles[i];
            label.font = UIFont(name: Inter_Regular, size: label.frame.height / 4);
            label.numberOfLines = 0;
            
            button.addSubview(label);
            
            //
            let seperatorViewHeight = CGFloat(1);
            let seperatorViewFrame = CGRect(x: 0, y: button.frame.height - seperatorViewHeight, width: button.frame.width, height: seperatorViewHeight);
            let seperatorView = UIView(frame: seperatorViewFrame);
            seperatorView.backgroundColor = BackgroundGray;
            
            button.addSubview(seperatorView);
            
            button.tag = i;
            button.addTarget(self, action: #selector(self.updateMainView), for: .touchUpInside);
            
            listView.addSubview(button);
            nextY += button.frame.height + listHeightPadding;

        }
        
        listView.contentSize = CGSize(width: listView.frame.width, height: nextY);
        
        // version number
        
        let versionLabelPadding = CGFloat(20);
        let versionLabelText = AppUtility.getAppVersionString();
        let versionLabelFont = UIFont(name: Inter_Bold, size: self.view.frame.width / 15)!;
        let versionLabelTextHeight = versionLabelText.getHeight(withConstrainedWidth: self.view.frame.width, font: versionLabelFont);
        let versionLabelFrame = CGRect(x: versionLabelPadding, y: self.view.frame.height - versionLabelPadding - versionLabelTextHeight, width: self.view.frame.width, height: versionLabelTextHeight);
        let versionLabel = UILabel(frame: versionLabelFrame);
        
        versionLabel.text = versionLabelText;
        versionLabel.font = versionLabelFont;
        versionLabel.textAlignment = .left;
        
        self.view.addSubview(versionLabel);
        
    }
}
