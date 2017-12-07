//
//  SingleNoteViewController.swift
//  Project_Note
//
//  Created by admin on 04/12/2017.
//  Copyright © 2017 Quattro. All rights reserved.
//

import UIKit
import MessageUI

class SingleNoteViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var annotation: UITextView!
    @IBOutlet weak var date: UITextView!
    let defaults = UserDefaults.standard
    
    var annot1 = ""
    var notes = [Any]()
    
    
    override func viewWillAppear(_ animated: Bool) {
            
        let notes = self.defaults.object(forKey: "tt") as? NSArray
        let currentNotes = notes?[self.defaults.integer(forKey: "idSingleNoteDetails")] as? NSArray
        let anno = currentNotes?[1]
        self.annotation.text = anno as! String
        let d = currentNotes?[2]
        self.date.text = d as! String
        self.img.image = UIImage(data: currentNotes?[0] as! Data)
        annot1 = anno as! String
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TakePictureViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func sendMail(_ sender: UIButton) {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            let alertController = UIAlertController.init(title: nil, message: "Device has no email service. Sorry", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        #else
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        #endif
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("toto")
        controller.dismiss(animated: true, completion: nil)
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["erwin@charles-dufant.fr"])
        mailComposerVC.setSubject("Receipt \(self.date.text!)")
        mailComposerVC.setMessageBody("Here's the receipt \(self.date.text!) '\(self.annotation.text!)'", isHTML: false)
        let imageData: NSData = UIImagePNGRepresentation(self.img.image!)! as NSData
        mailComposerVC.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "imageName")
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
   

    @IBAction func update(_ sender: UIButton) {
        if(annot1 == self.annotation.text){
            let alertController = UIAlertController.init(title: nil, message: "For updating your receipt, you must change the annotation..", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            var imgsNotAnnoted = [Any]()
            imgsNotAnnoted = self.defaults.object(forKey: "imgsNotAnnoted") as? NSArray as! [Any]
            print(self.defaults.integer(forKey: "idSingleNoteDetails"))
            let img = imgsNotAnnoted[self.defaults.integer(forKey: "idSingleNoteDetails")] as? NSArray

            self.img.image = UIImage(data: img?[0] as! Data)
            
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
                    arrayImg.remove(at: self.defaults.integer(forKey: "idSingleNoteDetails"))
                    
                }
               // arrayImg.append(array)
                arrayImg.insert(array, at: self.defaults.integer(forKey: "idSingleNoteDetails"))
                self.defaults.set(arrayImg, forKey: "tt")
                
            }

        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
            let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 12)!, NSForegroundColorAttributeName: UIColor.black, NSParagraphStyleAttributeName: paragraphStyle]
            text.draw(with: CGRect(x: 0, y: size.height / 1.1, width: size.width, height: size.height), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
        return img
    }
    
}
