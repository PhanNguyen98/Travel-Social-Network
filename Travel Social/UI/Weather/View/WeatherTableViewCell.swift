//
//  WeatherTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 04/03/2021.
//

import UIKit
import Kingfisher

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var speedCloudLabel: UILabel!
    @IBOutlet weak var iconWeatherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data: Weather, index: Int){
        if let nameIcon = data.weather?[0].icon {
            let url = URL(string: "https://openweathermap.org/img/wn/" + nameIcon + "@2x.png")
            iconWeatherImageView.kf.indicatorType = .activity
            iconWeatherImageView.kf.setImage(with: url)
        }
        pressureLabel.text = String(data.temp?.pressure ?? 0) + " hPa"
        humidityLabel.text = String(data.temp?.humidity ?? 0) + " %"
        tempLabel.text = String(data.temp?.tempMin ?? 0) + " K - " + String(data.temp?.tempMax ?? 0) + " K"
        speedCloudLabel.text = String(data.wind?.speed ?? 0) + " m/s"
        titleLabel.text = "Day " + String(index + 1) + " - " + (data.weather?[0].description)!
    }
    
}
