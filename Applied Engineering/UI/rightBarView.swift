//
//  rightBarView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/7/21.
//

import Foundation
import UIKit

// The right bar is also the settings page

class rightBarViewController : UIViewController{
    internal var topView : UIView = UIView();
    internal var settingsScrollView : UIScrollView = UIScrollView();
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        self.view.backgroundColor = BackgroundColor;
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 24));
        //topView.backgroundColor = .darkGray;
        self.view.addSubview(topView);
        
        settingsScrollView = UIScrollView(frame: CGRect(x: 0, y: topView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - topView.frame.height));
        //settingsScrollView.backgroundColor = .systemRed;
        self.view.addSubview(settingsScrollView);
        
        renderTopView();
        renderSettings();
        
    }
    
    private func renderTopView(){
        let titleLabelText = "Settings";
        let titleLabelFont = UIFont(name: Inter_Bold, size: topView.frame.height * 0.8)!;
        let titleLabelHeight = topView.frame.height;
        let titleLabelWidth = titleLabelText.getWidth(withConstrainedHeight: titleLabelHeight, font: titleLabelFont);
        let titleLabelFrame = CGRect(x: (topView.frame.width / 2) - (titleLabelWidth / 2), y: 0, width: titleLabelWidth, height: titleLabelHeight);
        let titleLabel = UILabel(frame: titleLabelFrame);
        
        titleLabel.text = titleLabelText;
        titleLabel.font = titleLabelFont;
        titleLabel.textColor = InverseBackgroundColor;
        titleLabel.textAlignment = .center;
        
        topView.addSubview(titleLabel);
        
        //
        
        let seperatorViewHeight = CGFloat(1);
        let seperatorViewFrame = CGRect(x: 0, y: topView.frame.height + 3*seperatorViewHeight, width: topView.frame.width, height: seperatorViewHeight);
        let seperatorView = UIView(frame: seperatorViewFrame);
        seperatorView.backgroundColor = BackgroundGray;
        
        topView.addSubview(seperatorView);
    }
    
    private func renderSettings(){
        
    }
    
}
