//
//  ViewController.swift
//  size.ai
//
//  Created by Sam Weller on 2020-03-02.
//

import UIKit

class SizeAIViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: UIImage!
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var sizeAI: UILabel!
    //label to duaply data from server
    @IBOutlet weak var estimateLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        estimateLabel.isHidden = true
        let img = UIImage(named: "crowdTest.jpeg")
        print("Calling function")
       // myImageUploadRequest(image: img!)
        // Do any additional setup after lo
        //      ading the view.
        imageView.dropShadow()
    }
    
    func displayPrediction(data: String){
           estimateLabel.isHidden = false
           dataLabel.text = data
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
        self.myImageUploadRequest(image: selectedImage!)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func myImageUploadRequest(image: UIImage)
    {
        
        let myUrl = NSURL(string: "http://127.0.0.1:5000/");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = [
            "firstName"  : "Sam",
            "lastName"    : "Weller",
            "userId"    : "9"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = image.jpegData(compressionQuality: 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            guard error == nil else {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            
            
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            self.displayPrediction(data: responseString! as String)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                print(json)
                
                
            }catch
            {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
               if parameters != nil {
                   for (key, value) in parameters! {
                       body.appendString(string: "--\(boundary)\r\n")
                       body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                       body.appendString(string: "\(value)\r\n")
                   }
               }
              
                       let filename = "user-profile.jpg"
                       let mimetype = "image/jpg"
                       
               body.appendString(string: "--\(boundary)\r\n")
               body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
               body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
               body.append(imageDataKey as Data)
               body.appendString(string: "\r\n")
               
           
               
               body.appendString(string: "--\(boundary)--\r\n")
               
               return body
           }
           
           
           
           func generateBoundaryString() -> String {
               return "Boundary-\(NSUUID().uuidString)"
           }
    

    
        
        
        
       }
       extension NSMutableData {
          
           func appendString(string: String) {
               let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
               append(data!)
           }


    
}


