//
//  miscellaneous.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/20/21.
//

import Foundation
import UIKit
import Charts

// General Global Macros

/*let statusNameArray : [String] = [
 "Minimum Duty Detection",
 "Over Current Protection",
 "Over Voltage Prevention",
 "Power Supply Mode"
 ];*/

let nonGraphableDataPoints : [String] = [
    "EM",
    "OV",
    "SM",
    "UV",
    "posLat",
    "posLon"
];

let dataButtonOnImage : UIImage = UIImage(systemName: "wifi")!;
let dataButtonOffImage : UIImage = UIImage(systemName: "wifi.slash")!;

let dataButtonOnColor : UIColor = .systemGreen;
let dataButtonOffColor : UIColor = .systemRed;
//

// Notification Macros
let layoutSettingsViewNotification = "layoutSettingsViewNotification";
let layoutMainViewNotification = "layoutMainViewNotification";
let layoutContentInstrumentClusterPage = "layoutContentInstrumentClusterPage";
let layoutContentGraphPage = "layoutContentGraphPage";
let layoutContentLogPage = "layoutContentLogPage";

let mainViewSetContentViewNotification = "mainViewSetContentViewNotification";
let dismissRightBarKeyboardNotification = "dismissRightBarKeyboardNotification";
let dataUpdatedNotification = "dataUpdatedNotification";
let connectionStatusUpdatedNotification = "connectionStatusUpdatedNotification";

let notificationDictionaryUpdateKeys = "notificationDictionaryUpdateKeys";
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

// Singleton Macros
let dataMgr = dataManager.obj;
let communication = communicationClass.obj;
let preferences = preferencesManager.obj;
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

// https://stackoverflow.com/a/35946921
extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

extension UIColor{
    static func rgb(_ r: Double, _ g: Double, _ b: Double) -> UIColor{
        return UIColor.init(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(1.0));
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

// Classes
class contentViewController : UIViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        UINotificationFeedbackGenerator().notificationOccurred(.success);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        UINotificationFeedbackGenerator().notificationOccurred(.success);
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait);
    }
}

class debugContentViewController : UIViewController{
    internal let horizontalPadding = AppUtility.getCurrentScreenSize().width / 28;
    internal let verticalPadding : CGFloat = 10;
    
    //
    
    internal var debugTitle : String = "N/A";
    internal var widthToHeightRatio : CGFloat = 0;
    
    public func getDebugTitle() -> String{
        return debugTitle;
    }
    
    public func getWidthToHeightRatio() -> CGFloat{
        return widthToHeightRatio;
    }
}
//
