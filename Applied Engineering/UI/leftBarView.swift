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
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        renderTopView();
        renderList();
        
        self.view.backgroundColor = BackgroundColor;
    }
    
    private func renderTopView(){
        topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.frame.height / 12));
        self.view.addSubview(topView);
        
        let iconImageViewSize = topView.frame.height;
        let iconImageViewFrame = CGRect(x: 0, y: 0, width: iconImageViewSize, height: iconImageViewSize);
        let iconImageView = UIImageView(frame: iconImageViewFrame);
        iconImageView.image = UIImage(named: "AELogo");
        iconImageView.contentMode = .scaleAspectFit;
        
        topView.addSubview(iconImageView);
        
        let titleLabelPadding = CGFloat(5);
        let titleLabelFrame = CGRect(x: iconImageView.frame.width + titleLabelPadding, y: 0, width: topView.frame.width - iconImageView.frame.width - 2*titleLabelPadding, height: topView.frame.height);
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
        
    }
}
