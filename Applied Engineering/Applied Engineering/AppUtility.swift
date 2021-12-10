//
//  AppUtility.swift
//
//  Created by Richard Wei.
//
import Foundation
import UIKit

struct AppUtility {

    static public let originalWidth = UIScreen.main.bounds.width;
    static public let originalHeight = UIScreen.main.bounds.height;
    static public let safeAreaInset = UIApplication.shared.windows[0].safeAreaInsets;
    
    static private var isOrientationLocked = false;
    static private var isLockedOrientationLandscape = false;
    
    static public var currentUserInterfaceStyle : UIUserInterfaceStyle = .unspecified; // used for overriding system user interface style, use system style when .unspecified
    
    static public func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation;
        }
        
        isOrientationLocked = orientation != .all;
        isLockedOrientationLandscape = UIDevice.current.orientation.isLandscape;
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static public func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation);
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation();
        
        isLockedOrientationLandscape = rotateOrientation.isLandscape;
    }

    static public func getCurrentScreenSize() -> CGSize{
        let isLandscape = isOrientationLocked ? isLockedOrientationLandscape : UIDevice.current.orientation.isLandscape;
        return CGSize(width: (isLandscape ? AppUtility.originalHeight : AppUtility.originalWidth), height: (isLandscape ? AppUtility.originalWidth : AppUtility.originalHeight));
    }
    
    //
    
    static public func setAppNotificationNumber(_ n: Int){
        UIApplication.shared.applicationIconBadgeNumber = n;
    }
    
    static public func getAppNotificationNumber() -> Int{
        return UIApplication.shared.applicationIconBadgeNumber;
    }
    
    //
    
    static public func getAppVersionString() -> String{
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0";
    }
    
    //
    
    static public func getCurrentScreenOrientation() -> UIInterfaceOrientation{
        return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .portrait;
    }
}
