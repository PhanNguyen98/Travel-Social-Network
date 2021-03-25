//
//  LocationSearchViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/03/2021.
//

import UIKit
import MapKit

protocol LocationSearchDelegate: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class LocationSearchViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var matchingItems = [MKMapItem]()
    var mapView: MKMapView?
    weak var locationDelegate: LocationSearchDelegate?

//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }

//MARK: SetData
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LocationSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationSearchTableViewCell")
    }

}

//MARK: UITableViewDelegate
extension LocationSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        locationDelegate?.dropPinZoomIn(placemark: matchingItems[indexPath.row].placemark)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: UITableViewDataSource
extension LocationSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchTableViewCell", for: indexPath) as? LocationSearchTableViewCell else {
            return LocationSearchTableViewCell()
        }
        cell.setData(data: matchingItems[indexPath.row])
        return cell
    }

}

//MARK: UISearchResultsUpdating
extension LocationSearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}
