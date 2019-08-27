//
//  ImageViewController.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 20.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ImageViewController: UIViewController {
    
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    var img: UIImage?
    var postId: String?
    var userId: String?
    var profileId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userId != Auth.auth().currentUser?.uid {
                delete.isHidden = true
        }
        imgView.image = img
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func deleteButton(_ sender: Any) {
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("post").child(postId!).setValue(nil)
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
