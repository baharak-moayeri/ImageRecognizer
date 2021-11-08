//
//  ViewController.swift
//  ImageRecognizer
//
//  Created by Baharak on 10/18/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var resnetModel: Resnet50?
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    func classifyPicture (Image: UIImage){
        guard let model = resnetModel?.model else {
            return
        }
        if let model = try? VNCoreMLModel (for: model) {
            let request = VNCoreMLRequest (model: model){(request,error) in
                if let results = request.results as? [VNClassificationObservation] {
                    let result = results[0]
                    self.navBar.topItem?.title = result.identifier
                    //print(results)
                }
            }
            if let imageData = Image.jpegData(compressionQuality: 1.0){
                let handler = VNImageRequestHandler (data: imageData, options: [:])
                try? handler.perform ([request])
            }
        }
    }
        
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        resnetModel = try? Resnet50(configuration: MLModelConfiguration())
        imagePicker.delegate = self
        if let image = imageView.image {
            classifyPicture(Image: image)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func albumTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func photoTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            classifyPicture(Image: image)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    

}


