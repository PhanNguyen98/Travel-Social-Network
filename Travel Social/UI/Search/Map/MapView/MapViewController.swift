//
//  MapViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/03/2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var searchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()
        setSearchBar()
    }
    
    func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func setSearchBar() {
        let locationSearchViewController = LocationSearchViewController()
        locationSearchViewController.mapView = mapView
        searchController = UISearchController(searchResultsController: locationSearchViewController)
        searchController?.searchResultsUpdater = locationSearchViewController
        searchController?.searchBar.placeholder = "Search for places"
        navigationItem.titleView = searchController?.searchBar
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        searchController?.searchBar.delegate = self
    }

}

//MARK:
extension MapViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 80)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
