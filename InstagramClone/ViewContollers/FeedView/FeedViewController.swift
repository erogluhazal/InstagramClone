//
//  FirstViewController.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 28.11.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import UserNotifications

class FeedViewController: UIViewController, FeedCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userVariables: [UserVariables] = []
    var feedCellVariables: FeedCellVaribles?
    var feedCell: FeedCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocalPushManager.shared.requestAuthorization()
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirebase(){ }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfile" {
            let vc = segue.destination as? UsersProfileViewController
            if let variable = sender as? Variables {
                vc?.variables = variable
            }
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(FeedViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getDataFromFirebase() {
            refreshControl.endRefreshing()
        }
    }
}
