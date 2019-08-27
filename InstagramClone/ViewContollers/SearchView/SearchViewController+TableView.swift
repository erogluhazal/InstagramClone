//
//  SearchViewController+TableView.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 20.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import Foundation
import UIKit

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        cell.userEmail.text = emails[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SearchTableViewCell
        let tempEmail = emails[indexPath.row]
        var id = ""
        for (index, email) in emails.enumerated() {
            if email == tempEmail {
                id = userId[index]
            }
        }
        
        let variable = Variables(imageUserId: id, userEmail: tempEmail)
        performSegue(withIdentifier: "toProfile", sender: variable)
    }
}
