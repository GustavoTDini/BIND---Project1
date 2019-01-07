//
//  MemeTextFieldDelegate.swift
//  MemeMe 1.0
//
//  Created by Gustavo Dini on 03/01/19.
//  Copyright © 2019 Gustavo Dini. All rights reserved.
//

import Foundation
import UIKit


class MemeTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        textField.text = ""
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

