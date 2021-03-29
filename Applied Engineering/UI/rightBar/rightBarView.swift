//
//  rightBarView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/7/21.
//

import Foundation
import UIKit

// The right bar is also the settings page

class rightBarViewController : UIViewController, UITextFieldDelegate{
    internal var topView : UIView = UIView();
    internal var settingsScrollView : UIScrollView = UIScrollView();
    
    internal var settingsInputViews : [UITextField] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.hideKeyboardWhenTappedAround();
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissKeyboard), name: NSNotification.Name(rawValue: dismissRightBarKeyboardNotification), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: dismissRightBarKeyboardNotification), object: nil);
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil);
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
        
        let verticalPadding = CGFloat(10);
        var nextY : CGFloat = verticalPadding;
        
        let testColors : [UIColor] = [.systemRed, .systemBlue, .systemPink, .systemTeal, .systemGray, .systemGreen, .systemGray2, .systemOrange];
        
        for i in 0..<preferencesManager.obj.numberOfSettings{
            
            let settingViewHorizontalPadding = CGFloat(12);
            let settingViewFrame = CGRect(x: settingViewHorizontalPadding, y: nextY, width: settingsScrollView.frame.width - 2*settingViewHorizontalPadding, height: self.view.frame.height / 12);
            let settingView = UIView(frame: settingViewFrame);
            
            //settingView.backgroundColor = testColors[i];
            
            settingsScrollView.addSubview(settingView);
            nextY += settingView.frame.height + verticalPadding;

            //
            
            let titleLabelFrame = CGRect(x: 0, y: 0, width: settingView.frame.width, height: settingView.frame.height / 2);
            let titleLabel = UILabel(frame: titleLabelFrame);
            
            titleLabel.text = preferencesManager.obj.settingsNameArray[i];
            titleLabel.font = UIFont(name: Inter_Medium, size:  titleLabel.frame.height * 0.6);
            titleLabel.textAlignment = .left;
            titleLabel.textColor = InverseBackgroundColor;
            
            settingView.addSubview(titleLabel);
            
            //
            
            let textFieldFrame = CGRect(x: 0, y: settingView.frame.height / 2, width: settingView.frame.width, height: settingView.frame.height / 2);
            let textField = UITextField(frame: textFieldFrame);
            
            //textView.backgroundColor = testColors[i];
            textField.font = UIFont(name: Inter_Regular, size: textField.frame.height * 0.6);
            textField.textColor = InverseBackgroundColor;
            textField.allowsEditingTextAttributes = false;
            textField.autocorrectionType = .no;
            textField.spellCheckingType = .no;
            textField.tintColor = AccentColor;
            textField.delegate = self;
            
            textField.tag = i;
            
            settingView.addSubview(textField);
            
            //
            
            let textViewUnderlineHeight = CGFloat(1);
            let textViewUnderlineFrame = CGRect(x: 0, y: settingView.frame.height - textViewUnderlineHeight, width: settingView.frame.width, height: textViewUnderlineHeight);
            let textViewUnderline = UIView(frame: textViewUnderlineFrame);
            
            textViewUnderline.backgroundColor = InverseBackgroundColor;
            
            settingView.addSubview(textViewUnderline);

            
        }
        
        settingsScrollView.contentSize = CGSize(width: settingsScrollView.frame.width, height: nextY);
    
    }
    
}
