//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Gustavo Dini on 29/12/18.
//  Copyright © 2018 Gustavo Dini. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    // MARK: constants
    
    let CAMERA = "camera"
    let GALLERY = "gallery"
    
    let START_TOP_TEXT = "TOP"
    let START_BOTTOM_TEXT = "BOTTOM"
    
    let memeTextAttributes:[NSAttributedString.Key:Any] = [
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue):UIColor.black,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue):UIColor.white,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "Impact", size: 40)!,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue):-4.0
    ]
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    let memeClass = MemeClass()

    // MARK: IBOutlets
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagesButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var topView: UIView!
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = memeTextFieldDelegate
        topTextField.textAlignment = .center
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.delegate = memeTextFieldDelegate
        bottomTextField.textAlignment = .center
        
        setMeme(reset: true, selectImage: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: IBActions

    @IBAction func openCamera(_ sender: Any) {
        openImagePicker(sourceType: CAMERA)
    }
    
    @IBAction func openImages(_ sender: Any) {
        openImagePicker(sourceType: GALLERY)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        shareMeme()
    }
    
    @IBAction func cancelEdit(_ sender: Any) {
        setMeme(reset: true, selectImage: false)
    }
    
    // MARK: Keyboard Notification Functions
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomTextField.isEditing){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    // MARK: Other Functions
    
    func openImagePicker(sourceType: String){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if (sourceType == CAMERA){
            imagePicker.sourceType = .camera
        } else if (sourceType == GALLERY){
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage]
        if ((image as? UIImage) != nil){
            memeImageView.image = image as! UIImage?
            setMeme(reset: false, selectImage: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func shareMeme() {
        if (topTextField.text != START_TOP_TEXT && bottomTextField.text != START_BOTTOM_TEXT){
            hideShowBars(isHidden: true)
            let memedImage = memeClass.generateMemedImage(_: self.view, _: topTextField, _: bottomTextField, _: memeImageView)
            let shareView = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
            hideShowBars(isHidden: false)
            present(shareView, animated: true)
        }
    }
    
    func setMeme(reset: Bool, selectImage: Bool){
        if (reset){
            memeImageView.image = nil
            topTextField.text = START_TOP_TEXT
            bottomTextField.text = START_BOTTOM_TEXT
        }
        cancelButton.isEnabled = selectImage
        shareButton.isEnabled = selectImage
        topTextField.isEnabled = selectImage
        bottomTextField.isEnabled = selectImage
        bottomTextField.textAlignment = .center
    }
    
    
    func hideShowBars(isHidden: Bool){
        navBar.isHidden = isHidden
        toolBar.isHidden = isHidden
        topView.isHidden = isHidden
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue// of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}

