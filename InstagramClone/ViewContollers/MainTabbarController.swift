//
//  MainTabbarController.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 24.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import UIKit

class MainTabbarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is UINavigationController {
            let navigationViewController = viewController as! UINavigationController
            if let first = navigationViewController.viewControllers.first as? FeedViewController {
                let indexPath = IndexPath(item: 0, section: 0)
                first.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
}
