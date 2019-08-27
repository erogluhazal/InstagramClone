//
//  SecondViewController.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 28.11.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    
    var feedView: FeedViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UploadViewController.selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func selectImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("Media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            // uniq id :
            let uuid = NSUUID().uuidString
            let mediaImageReference = mediaFolder.child("\(uuid).jpg")
            mediaImageReference.putData(data, metadata: nil) { (metaData, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    mediaImageReference.downloadURL(completion: { (url, error) in
                        if error == nil {
                            let imageURL = url?.absoluteString
                            let databaseReference = Database.database().reference()
                            let post = ["image": imageURL!, "postedBy": Auth.auth().currentUser?.email, "postText": self.commentText.text, "uuid": uuid] as [String: Any]
                            databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("post").childByAutoId().setValue(post)
                            self.imageView.image = UIImage(named: Shortcuts.Images.photoSelect)
                            self.commentText.text = ""
                            self.tabBarController?.selectedIndex = 0
                        }
                    })
                    // Veritabanına Yazmak
                }
            }
        }
    }
}
