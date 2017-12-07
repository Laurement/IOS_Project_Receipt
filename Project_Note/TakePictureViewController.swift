//
//  TakePictureViewController.swift
//  Project_Note
//
//  Created by admin on 04/12/2017.
//  Copyright © 2017 Quattro. All rights reserved.
//

import UIKit
import AVFoundation

class TakePictureViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var img: UIImageView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TakePictureViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //get image
        if( self.defaults.object(forKey: "tt") != nil ) {
            for data in (self.defaults.object(forKey: "tt") as? NSArray)! {
                print("ttt")
            }
        }
    }

    @IBAction func returnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openCamera(_ sender: UIButton) {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            let actionSheet = UIAlertController(title: "Add your receipt", message: "Sorry, device has no camera.", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Librairie", style: .default, handler: {(action:UIAlertAction) in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction.init(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            }))
           self.present(actionSheet, animated: true, completion: nil)
        #else
            if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                let actionSheet = UIAlertController(title: "Add your receipt", message: "You have the choice between your camera and your librairy. Add", preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Librairie", style: .default, handler: {(action:UIAlertAction) in
                    imagePickerController.sourceType = .photoLibrary
                    self.present(imagePickerController, animated: true, completion: nil)
                }))
                actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
                    if UIImagePickerController.isSourceTypeAvailable(.camera){
                        imagePickerController.sourceType = .camera
                        self.present(imagePickerController, animated: true, completion: nil)
                    }
                }))
                self.present(actionSheet, animated: true, completion: nil)
            } else {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
                    if granted == true {
                        if !UIImagePickerController.isSourceTypeAvailable(.camera){
                            let alertController = UIAlertController.init(title: nil, message: "Device has no camera. Sorry", preferredStyle: .alert)
                            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
                            })
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }else{
                            var imagePicker =  UIImagePickerController()
                            imagePicker.delegate = self
                            imagePicker.sourceType = .camera
                            self.present(imagePicker, animated: true, completion: nil)
                        }
                    } else {
                        print("Please authorized your camera")
                    }
                })
            }
        #endif
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBOutlet weak var annotation: UITextField!
    //Save the picture taken in the UIImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.img.image = image
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAnnotation(_ sender: UITextField) {
        let annotation = self.annotation.text
        
        print("ooo")
    }
    
    func createFinalImageText (drawText textNote: NSString, noteImg imageNote: UIImage) -> UIImage? {
        let image = imageNote
        let viewToRender = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)) // here you can set the actual image width : image.size.with ?? 0 / height : image.size.height ?? 0
        let imgView = UIImageView(frame: viewToRender.frame)
        imgView.image = image
        viewToRender.addSubview(imgView)
        let textImgView = UIImageView(frame: viewToRender.frame)
        textImgView.image = imageFrom(text: textNote as String, size: viewToRender.frame.size)
        viewToRender.addSubview(textImgView)
        UIGraphicsBeginImageContextWithOptions(viewToRender.frame.size, false, 0)
        viewToRender.layer.render(in: UIGraphicsGetCurrentContext()!)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    
    func imageFrom(text: String , size:CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!, NSForegroundColorAttributeName: UIColor.cyan, NSParagraphStyleAttributeName: paragraphStyle]
            
            text.draw(with: CGRect(x: 0, y: size.height / 1.1, width: size.width, height: size.height), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
        return img
    }
    
     var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func saveNote(_ sender: UIButton) {
        if(self.annotation.text == nil || self.img.image == nil){
            let alertController = UIAlertController.init(title: nil, message: "You have to take your receipt in picture and add an annotation.", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //Starting the loader
            self.activityIndicator.center = self.view.center
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.color = UIColor.white
            //UIColor.init(red: 0.02, green: 0.019, blue: 0.19, alpha: 1)
            self.view.addSubview(activityIndicator)
            self.activityIndicator.startAnimating()
            
            //Save the image before annoted it
            let imgNotAnnoted = UIImagePNGRepresentation(self.img.image!)
            var arrayImgNotAnnoted = [Any]()
            arrayImgNotAnnoted.append(imgNotAnnoted)
            var arrayImgA = [[Any]]()
            if(self.defaults.array(forKey: "imgsNotAnnoted") != nil){
                arrayImgA = (self.defaults.array(forKey: "imgsNotAnnoted") as NSArray?) as! [[Any]]
            }
            arrayImgA.append(arrayImgNotAnnoted)
            self.defaults.set(arrayImgA, forKey: "imgsNotAnnoted")
     
            if let image = createFinalImageText(drawText: self.annotation.text as! NSString, noteImg: self.img.image!) {
                self.img.image = image
          
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                let currentDate = formatter.string(from: date)
 
                let imageData = UIImagePNGRepresentation(self.img.image!)
                
                var array = [Any]()
                
                array.append(imageData)
                array.append(self.annotation.text)
                array.append(currentDate)
            
                var arrayImg = [[Any]]()
                
                if(self.defaults.array(forKey: "tt") != nil){
                     arrayImg = (self.defaults.array(forKey: "tt") as NSArray?) as! [[Any]]
                }
                arrayImg.append(array)
                self.defaults.set(arrayImg, forKey: "tt")
               
                self.activityIndicator.stopAnimating()
            }
        }
        
        
    }
  
    
}
