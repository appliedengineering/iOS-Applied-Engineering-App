//
//  miscellaneous.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/20/21.
//

import Foundation
import UIKit

// Notification Macros
let layoutSettingsViewNotification = "layoutSettingsViewNotification";
let layoutMainViewNotification = "layoutMainViewNotification";
let mainViewSetContentViewNotification = "mainViewSetContentViewNotification";
let dismissRightBarKeyboardNotification = "dismissRightBarKeyboardNotification";
//

// Colors
let AccentColor = UIColor(named: "AccentColor")!;
let BackgroundColor = UIColor(named: "BackgroundColor")!;
let BackgroundGray = UIColor(named: "BackgroundGray")!;
let InverseBackgroundColor = UIColor(named: "InverseBackgroundColor")!;
//

// Fonts
let Inter_Black = "Inter-Black";
let Inter_BlackItalic = "Inter-BlackItalic";
let Inter_Bold = "Inter-Bold";
let Inter_BoldItalic = "Inter-BoldItalic";
let Inter_ExtraBold = "Inter-ExtraBold";
let Inter_ExtraBoldItalic = "Inter-ExtraBoldItalic";
let Inter_ExtraLight = "Inter-ExtraLight";
let Inter_ExtraLightItalic = "Inter-ExtraLightItalic";
let Inter_Italic = "Inter-Italic";
let Inter_Light = "Inter-Light";
let Inter_LightItalic = "Inter-LightItalic";
let Inter_Medium = "Inter-Medium";
let Inter_MediumItalic = "Inter-MediumItalic";
let Inter_Regular = "Inter-Regular";
let Inter_SemiBold = "Inter-SemiBold";
let Inter_SemiBoldItalic = "Inter-SemiBoldItalic";
let Inter_Thin = "Inter-Thin";
let Inter_ThinItalic = "Inter-ThinItalic";
let Inter_V = "Inter-V";
//

// Extensions
extension String {
    func getHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func getWidth(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

// https://stackoverflow.com/a/27079103
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: dismissRightBarKeyboardNotification), object: nil, userInfo: nil);
    }
}

//

// Functions
internal func linkViewControllerToView(view: UIView, controller: UIViewController, parentController: UIViewController){
    controller.willMove(toParent: parentController);
    controller.view.frame = view.bounds;
    view.addSubview(controller.view);
    parentController.addChild(controller);
    controller.didMove(toParent: parentController);
}
//
