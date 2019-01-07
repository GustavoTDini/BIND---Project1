//
//  Meme.swift
//  MemeMe 1.0
//
//  Created by Gustavo Dini on 06/01/19.
//  Copyright © 2019 Gustavo Dini. All rights reserved.
//

import Foundation
import UIKit


class MemeClass{
    
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    
    func save(_ topTextField: UITextField, _ bottomTextField: UITextField, _ memeImageView: UIImageView, _ memedImage: UIImage) {
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage(_ selfView: UIView,_ topTextField: UITextField,_ bottomTextField: UITextField,_ memeImageView: UIImageView) -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(selfView.frame.size)
        selfView.drawHierarchy(in: selfView.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        save(_: topTextField, _: bottomTextField, _: memeImageView, _: memedImage)
        return memedImage
    }
    
}
