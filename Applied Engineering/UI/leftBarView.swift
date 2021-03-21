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
    
    private let leftBarContentTitles : [String] = ["Telemetry", "Task\nTracking", "Instrument\nCluster", "Settings"];
    private let leftBarContentImageNames : [String] = ["list.bullet.rectangle", "doc.plaintext", "speedometer", "gearshape"];
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        renderTopView();
        renderList();
        
        self.view.backgroundColor = BackgroundColor;
    }
    
    @objc func updateMainView(_ sender: UIButton){
        print(sender.tag);
    }
    
    private func renderTopView(){
        topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.frame.height / 12));
        self.view.addSubview(topView);
        
        let iconImageViewPadding = CGFloat(10);
        let iconImageViewSize = topView.frame.height;
        let iconImageViewFrame = CGRect(x: iconImageViewPadding, y: 0, width: iconImageViewSize - 2 * iconImageViewPadding, height: iconImageViewSize);
        let iconImageView = UIImageView(frame: iconImageViewFrame);
        iconImageView.image = UIImage(named: "AELogo");
        iconImageView.contentMode = .scaleAspectFit;
        
        topView.addSubview(iconImageView);
        
        let titleLabelPadding = CGFloat(5);
        let titleLabelFrame = CGRect(x: iconImageView.frame.width + 2*iconImageViewPadding + titleLabelPadding, y: 0, width: topView.frame.width - iconImageView.frame.width - 2*titleLabelPadding - 2 * iconImageViewPadding, height: topView.frame.height);
        let titleLabel = UILabel(frame: titleLabelFrame);
        
        titleLabel.numberOfLines = 0;
        titleLabel.text = "Applied\nEngineering";
        titleLabel.textColor = InverseBackgroundColor;
        titleLabel.font = UIFont(name: Inter_Bold, size: titleLabel.frame.height / 3);
        
        topView.addSubview(titleLabel);
        
        let seperatorViewHeight = CGFloat(1);
        let seperatorViewFrame = CGRect(x: 0, y: topView.frame.height - seperatorViewHeight, width: topView.frame.width, height: seperatorViewHeight);
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
        let versionLabelText = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0";
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
