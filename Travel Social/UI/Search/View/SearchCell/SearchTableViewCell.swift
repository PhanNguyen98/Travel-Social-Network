//
//  SearchTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 27/01/2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setSearchDelegate(delegate: UISearchBarDelegate) {
        self.searchBar.delegate = delegate
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

