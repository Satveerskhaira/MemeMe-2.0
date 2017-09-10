//
//  CreateMemeViewController.swift
//  MemeMe 2.0
//
//  Created by Satveer Singh on 9/9/17.
//  Copyright © 2017 Satveer Singh. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var actualImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    var memedObject = [Meme] ()
    var memedImage = UIImage()
    // MARK : Dictionary for text fiel  default attributes
    let memeAttributes: [String: Any] = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
                                         NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
                                         NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
                                         NSAttributedStringKey.strokeWidth.rawValue: -4.0 ]
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFeild(textField: topText, text: "TOP")
        configureTextFeild(textField: bottomText, text: "BOTTOM")
        actualImage.image = #imageLiteral(resourceName: "image")
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // MARK : Configure text field
    func configureTextFeild(textField : UITextField, text : String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeAttributes
        textField.text = text
        textField.borderStyle = .none
        textField.textAlignment = .center
        
    }
    //MARK : Image Picker by Camera
    @IBAction func TakeImgeByCamera(_ sender: Any) {
        imagePickerView(true)
    }
    
    //MARK : Image Picker from Album
    
    @IBAction func PickImageFromAlbum(_ sender: Any) {
        imagePickerView(false)
    }
    
    // MARK : Image picker
    
    func imagePickerView(_ camera : Bool) {
        let pickerImage = UIImagePickerController()
        if camera {
            pickerImage.sourceType = .camera
        }
        pickerImage.delegate = self
        present(pickerImage, animated: true, completion: nil)
    }
    
    // MARK : Activity bar
    @IBAction func ShareMeme(_ sender: Any) {
        memedImage = generateMemedImage()
        let shareMemeImage = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        //Save to MemeObject
        shareMemeImage.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed{
                self.save()
                self.reset()
            }
        }
        present(shareMemeImage, animated: true, completion: nil)
    }
    
    // MARK : Set to default values
    @IBAction func ResetMemeView(_ sender: Any) {
        reset()
    }
    
    func reset( ){
        self.topText.text = "TOP"
        self.bottomText.text = "BOTTOM"
        self.actualImage.image = #imageLiteral(resourceName: "image")
    }
    //MARK : Image picker delegate menthods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.actualImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK : Dismiss image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK : Update frame
    func updateViewframe( frameOrigin : CGFloat) {
        view.frame.origin.y = frameOrigin
    }
    
    // MARK : Text Delegate functions
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK : This function will hide the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK : shift View to enter text in bottom field
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.restorationIdentifier == "Bottom" {
            // enable keyboard notification
            subscribeToKeyboardNotifications()
            if textField.text == "BOTTOM" {
                textField.text = " "
            }
        } else {
            if textField.text == "TOP" {
                textField.text = " "
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        if textField.restorationIdentifier == "Bottom" {
            // enable keyboard notification
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    // MARK : subscribe and unsubscribe from keyboard notification
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification :Notification) {
        updateViewframe(frameOrigin: -getKeyboardHeight(notification))
    }
    
    @objc func keyboardWillHide(_ notification : Notification) {
        updateViewframe(frameOrigin: CGFloat(0))
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK : Generate Memed Image
    
    func generateMemedImage () -> UIImage {
        // Render View to image
        self.navigationBar.isHidden = true
        self.toolBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        self.navigationBar.isHidden = false
        self.toolBar.isHidden = false
        return memedImage
    }
    
    // MARK : Save meme Object
    
    func save () {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, oldImage: actualImage.image!, memeImage: memedImage)
        memedObject.append(meme)
    }
}
