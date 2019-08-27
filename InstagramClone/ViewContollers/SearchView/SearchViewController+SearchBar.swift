//
//  SearchViewController+SearchBar.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 20.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import Foundation
import UIKit

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            emails = usersEmail
            searchTable.reloadData()
        } else {
            emails = usersEmail.filter({ $0.lowercased().range(of: searchText.lowercased()) != nil})
            searchTable.reloadData()
        }
    }
}
