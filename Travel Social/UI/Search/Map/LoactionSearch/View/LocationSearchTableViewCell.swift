//
//  LocationSearchTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/03/2021.
//

import UIKit
import MapKit

class LocationSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var detailPlaceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data: MKMapItem) {
        self.placeLabel.text = data.placemark.name
        self.detailPlaceLabel.text = Utilities.parseAddress(selectedItem: data.placemark)
    }
    
}
