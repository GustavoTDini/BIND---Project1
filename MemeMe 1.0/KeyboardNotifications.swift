//
//  KeyboardNotifications.swift
//  MemeMe 1.0
//
//  Created by Gustavo Dini on 07/01/19.
//  Copyright © 2019 Gustavo Dini. All rights reserved.
//

import Foundation
import UIKit

class nameKeyboardNotifications {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification , view:UIView) {
        if (bottomTextField.isEditing){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification, view:UIView) {
        view.frame.origin.y = 0
    }
    
}
