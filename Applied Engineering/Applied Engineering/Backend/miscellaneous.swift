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
let graphNameArray : [String] = [
    "RPM",
    "Torque (N⋅m)",
    "Throttle (%)",
    "Duty (%)",
    "PWM Frequency",
    "Temperature (C)",
    "Source Voltage (V)",
    "PWM Current (I)",
    "Power Change (Δ)",
    "Voltage Change (Δ)"
];
let graphColorArray : [UIColor] = [
    UIColor.rgb(63, 81, 181),
    UIColor.rgb(0, 150,136),
    UIColor.rgb(76, 175, 80),
    UIColor.rgb(139, 195, 74),
    UIColor.rgb(255, 235, 59),
    UIColor.rgb(255, 152, 0),
    UIColor.rgb(255, 87, 34),
    UIColor.rgb(244, 67, 54),
    UIColor.rgb(233, 30, 99),
    UIColor.rgb(156, 39, 176)
];

let statusNameArray : [String] = [
    "Minimum Duty Detection",
    "Over Current Protection",
    "Over Voltage Prevention",
    "Power Supply Mode"
];

let numberOfGraphableVars = 10;
let numberOfStatusVars = 4;
//

// Notification Macros
let layoutSettingsViewNotification = "layoutSettingsViewNotification";
let layoutMainViewNotification = "layoutMainViewNotification";
let layoutContentInstrumentClusterPage = "layoutContentInstrumentClusterPage";
let mainViewSetContentViewNotification = "mainViewSetContentViewNotification";
let dismissRightBarKeyboardNotification = "dismissRightBarKeyboardNotification";
let dataUpdatedNotification = "dataUpdatedNotification";
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
class GraphUIButton : UIButton{
    public var graphIndex : Int = -1;
    public var hasData : Bool = false {
        didSet{
            DispatchQueue.main.sync {
                self.noDataLabel.isHidden = self.hasData;
            }
        }
    };
    public let chartView : LineChartView = LineChartView();
    
    //
    
    private let noDataLabel = UILabel();
    
    init(frame: CGRect, index: Int){
        super.init(frame: frame);
        graphIndex = index;
        
        renderNoDataLabel();
        renderTitleLabel();
        setupGraph();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func renderNoDataLabel(){
        let noDataLabelFont = UIFont(name: Inter_Regular, size: frame.height / 12)!;
        let noDataLabelText = "No Data.";
        let noDataLabelWidth = frame.size.width;
        let noDataLabelHeight = noDataLabelText.getHeight(withConstrainedWidth: noDataLabelWidth, font: noDataLabelFont);
        
        noDataLabel.frame = CGRect(x: 0, y: (frame.size.height / 2) - (noDataLabelHeight / 2), width: noDataLabelWidth, height: noDataLabelHeight);
        
        noDataLabel.text = noDataLabelText;
        noDataLabel.font = noDataLabelFont;
        noDataLabel.textColor = InverseBackgroundColor;
        noDataLabel.textAlignment = .center;
        
        self.addSubview(noDataLabel);
    }
    
    private func renderTitleLabel(){
        
        let titleLabelFont = UIFont(name: Inter_SemiBold, size: frame.height / 10)!;
        let titleLabelText = graphNameArray[graphIndex];
        let titleLabelWidth = frame.size.width;
        let titleLabelHeight = titleLabelText.getHeight(withConstrainedWidth: titleLabelWidth, font: titleLabelFont);
        
        let titleLabelFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: titleLabelHeight);
        let titleLabel = UILabel(frame: titleLabelFrame);
        
        titleLabel.textAlignment = .right;
        titleLabel.text = titleLabelText;
        titleLabel.font = titleLabelFont;
        titleLabel.textColor = InverseBackgroundColor;
        
        self.addSubview(titleLabel);
    }
    
    private func setupGraph(){
        chartView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height);
        self.addSubview(chartView);
    }
    
}
//
