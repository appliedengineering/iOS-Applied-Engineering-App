//
//  rightBarViewActions.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/28/21.
//

import Foundation
import UIKit

extension rightBarViewController{
    
    @objc func applySettings(_ sender: UIButton){
        
        UINotificationFeedbackGenerator().notificationOccurred(.success);
        
        for textField in settingsInputViews{
            preferencesManager.obj.saveStringValueForIndex(textField.tag, textField.text ?? "");
            textField.text = preferencesManager.obj.getStringValueForIndex(textField.tag);
        }
        
        communication.newConnection(communication.createTelemetryFullAddress());
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: layoutMainViewNotification), object: nil, userInfo: nil);
    }
    
     // Keyboard actions
    
    @objc override func dismissKeyboard() {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // textfield delegate function
        textField.resignFirstResponder();
        return true;
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        guard let keyboardFrame : CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return;
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            
            self.settingsScrollView.frame = CGRect(x: self.settingsScrollView.frame.minX, y: self.settingsScrollView.frame.minY, width: self.settingsScrollView.frame.width, height: self.view.frame.height - self.topView.frame.height - keyboardFrame.height);
            
        });
    }

    @objc func keyboardWillHide(_ notification: NSNotification){
        
        UIView.animate(withDuration: 0.1, animations: {
            
            self.settingsScrollView.frame = CGRect(x: self.settingsScrollView.frame.minX, y: self.settingsScrollView.frame.minY, width: self.settingsScrollView.frame.width, height: self.view.frame.height - self.topView.frame.height);
            
        });
        
    }
}
