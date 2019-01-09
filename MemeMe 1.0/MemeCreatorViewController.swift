//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Gustavo Dini on 29/12/18.
//  Copyright © 2018 Gustavo Dini. All rights reserved.
//

import UIKit

class MemeCreatorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: constants
    
    let TOP_TEXT_PLACEHOLDER = "TOP"
    let BOTTOM_TEXT_PLACEHOLDER = "BOTTOM"
    
    let memeTextAttributes:[NSAttributedString.Key:Any] = [
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue):UIColor.black,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue):UIColor.white,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "Impact", size: 40)!,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue):-4.0
    ]
    
    struct Meme{
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
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
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        setMemeTextStyle(toTextField: topTextField)
        setMemeTextStyle(toTextField: bottomTextField)
        
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
        openImagePicker(_: .camera)
    }
    
    @IBAction func openImages(_ sender: Any) {
        openImagePicker(_: .photoLibrary)
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
    
    // MARK: ImagePicker Functions
    
    func openImagePicker(_ type: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            memeImageView.image = image
            setMeme(reset: false, selectImage: true)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    // MARK: Generate & Share Functions
    
    func save(_ memeImage: UIImage) {
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memeImage)
    }
    
    func generateMemedImage() -> UIImage {
        hideShowBars(isHidden: true)
        // Render view to an image
        UIGraphicsBeginImageContext(getCropRect().size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cgMemeImage = memedImage.cgImage!.cropping(to: getCropRect())
        let memedImageCroped: UIImage = UIImage(cgImage: cgMemeImage!)
        hideShowBars(isHidden: false)
        return memedImageCroped
    }
    
    func shareMeme() {
        if (topTextField.text != TOP_TEXT_PLACEHOLDER && bottomTextField.text != TOP_TEXT_PLACEHOLDER){
            let memedImage = generateMemedImage()
            let shareView = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
            present(shareView, animated: true)
            shareView.completionWithItemsHandler = {(activity, completed, items, error) in
                if (completed){
                    self.save(memedImage)
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Modify Views Functions
    
    func setMeme(reset: Bool, selectImage: Bool){
        if (reset){
            memeImageView.image = nil
            topTextField.text = TOP_TEXT_PLACEHOLDER
            bottomTextField.text = BOTTOM_TEXT_PLACEHOLDER
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
    }
    
    // MARK: TextField Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Erase the default text when editing
        if textField == topTextField && textField.text == "TOP" {
            textField.text = ""
            
        } else if textField == bottomTextField && textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // MARK: Other Functions
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func setMemeTextStyle(toTextField textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.autocapitalizationType = .allCharacters
        textField.delegate = self
    }
    
    func getCropRect() -> CGRect {
        let height = self.view.frame.height
        let width = self.view.frame.width
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            navBar.frame.height
        let bottonBarHeight = toolBar.frame.height
        return CGRect(x: 0, y: topBarHeight, width: width, height: height - bottonBarHeight)
    }
    
}

