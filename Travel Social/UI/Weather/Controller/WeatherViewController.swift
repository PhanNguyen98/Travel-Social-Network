//
//  WeatherViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 03/03/2021.
//

import UIKit
import SVProgressHUD

class WeatherViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSources = Forecast()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        searchweather(city: "Ho Chi Minh")
        searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
    }
    
    func searchweather(city: String) {
        SVProgressHUD.show()
        WeatherManager.shared.searchWeather(name: city ) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let forecast):
                if let data = forecast {
                    self.dataSources = data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            case .failure(let failure):
                let alert = UIAlertController(title: "Search Weather Error", message: failure.message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 100))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text =  dataSources.city?.name
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .black
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
}

extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell else {
            return WeatherTableViewCell()
        }
        if let data = dataSources.list?[indexPath.row] {
            cell.setData(data: data, index: indexPath.row)
        }
        return cell
    }
    
}

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keySearch = searchBar.text {
            searchweather(city: keySearch)
        }
    }    
}
