//
//  rightBarViewActions.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/28/21.
//

import Foundation
import UIKit

extension rightBarViewController{
    
    @objc override func dismissKeyboard() {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // textfield delegate function
        textField.resignFirstResponder()
        return true
    }
    
}
