//
//  ViewController.swift
//  size.ai
//
//  Created by Sam Weller on 2020-03-02.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: UIImage!
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonHit(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
                     imagePicker.delegate = self
                     
                     let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source.", preferredStyle: .actionSheet)
                     
                     
                     actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
                         if UIImagePickerController.isSourceTypeAvailable(.camera){
                             imagePicker.sourceType = .camera
                             self.present(actionSheet, animated: true, completion: nil)}
                         else {
                             print("Camera not availible")
                         }
                     }))
                     actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
                         imagePicker.sourceType = .photoLibrary
                         self.present(actionSheet, animated: true, completion: nil)
                     }))
                     actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                     
                     self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
         self.selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
         self.uploadImage(Image: selectedImage!)
               
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func uploadImage(Image: UIImage){
        guard let image = Image.pngData() else{
            print("error setting image")
            return
        }
        
        //creating network
        let url = URL(string: "URL TO FLASK SERVER")
        var request = URLRequest(url: url!)
        
        //creating request
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("\(image.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = image
        
        //execute request
        let upload = URLSession.shared.uploadTask(with: request as URLRequest , from: image) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if (error != nil){
                print(error)
                return
            }
            
            
            //code to be completed
        }
        
        upload.resume();
        
        
        
    }
    
}

