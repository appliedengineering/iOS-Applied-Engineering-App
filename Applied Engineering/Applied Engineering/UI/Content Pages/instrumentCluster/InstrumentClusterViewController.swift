//
//  InstrumentClusterViewController.swift
//  Applied Engineering
//
//  Created by Richard Wei on 5/2/21.
//

import Foundation
import UIKit

class instrumentClusterViewController : contentViewController{
    
    internal let dismissButton : UIButton = UIButton();
    internal var dismissButtonHeightAnchor : NSLayoutConstraint? = nil;
    
    //
    
    internal let speedometerGague : UIView = UIView(); // left side of screen
    
    //internal let throttleGague : SemiCircleGagueView = SemiCircleGagueView();
    //internal let temperatureGague : SemiCircleGagueView = SemiCircleGagueView();
    
    internal let batteryGague : UIView = UIView();
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft);
        
        self.view.backgroundColor = BackgroundColor;
        
        //
                
        dismissButton.translatesAutoresizingMaskIntoConstraints = false;
        
        self.view.addSubview(dismissButton);
        
        dismissButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        dismissButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true;
        dismissButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        dismissButtonHeightAnchor = dismissButton.heightAnchor.constraint(equalToConstant: (AppUtility.getCurrentScreenSize().width * 0.006) + AppUtility.safeAreaInset.top);
        dismissButtonHeightAnchor?.isActive = true;
        
        //dismissButton.backgroundColor = .systemRed;
        dismissButton.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside);
        
        setupTopBar();
        
        //
        
        renderContent();
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("transitioning to \(size)")
    }
    
    //
    
    @objc func dismissVC(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil);
    }
    
    //
    
    internal func setupTopBar(){
        
        let titleLabel = UILabel();
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        dismissButton.addSubview(titleLabel);
        
        titleLabel.centerXAnchor.constraint(equalTo: dismissButton.centerXAnchor).isActive = true;
        titleLabel.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor).isActive = true;
        
        titleLabel.text = "Instrument Cluster";
        titleLabel.textAlignment = .center;
        titleLabel.textColor = InverseBackgroundColor;
        titleLabel.font = UIFont(name: Inter_Bold, size: AppUtility.originalWidth * 0.05);

        //
        
        let dismissImageView = UIImageView();
        dismissImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        dismissButton.addSubview(dismissImageView);
        
        dismissImageView.leadingAnchor.constraint(equalTo: dismissButton.leadingAnchor, constant: 20).isActive = true;
        dismissImageView.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor).isActive = true;
        
        dismissImageView.image = UIImage(systemName: "chevron.left");
        dismissImageView.tintColor = InverseBackgroundColor;
    }
    
    internal func renderContent(){
        
        let contentViewWidth = AppUtility.getCurrentScreenSize().width;
        let contentViewHeight = AppUtility.getCurrentScreenSize().height - dismissButtonHeightAnchor!.constant;
        
        let contentViewHorizontalPadding : CGFloat = contentViewWidth * 0.01;
        let contentViewVerticalPadding : CGFloat = contentViewHeight * 0.01;
        
        //
        
        let contentView = UIView();
        
        self.view.addSubview(contentView);
        
        contentView.translatesAutoresizingMaskIntoConstraints = false;
        
        contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        contentView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor).isActive = true;
        contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
        contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        contentView.backgroundColor = .systemRed;
        
        ///
        
        /*contentView.addSubview(speedLabel);
        
        speedLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        speedLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true;
        speedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentViewVerticalPadding).isActive = true;
        
        speedLabel.text = "0";
        speedLabel.textColor = InverseBackgroundColor;
        speedLabel.font = UIFont(name: Inter_Bold, size: contentViewWidth * 0.06);
        //speedLabel.backgroundColor = .systemRed;
        
        //
        
        let mphLabel = UILabel();
        
        contentView.addSubview(mphLabel);
        
        mphLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        mphLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true;
        mphLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor).isActive = true;
        
        mphLabel.text = "mph";
        mphLabel.textColor = InverseBackgroundColor;
        mphLabel.font = UIFont(name: Inter_Regular, size: contentViewWidth * 0.02);*/
        
    }
}
