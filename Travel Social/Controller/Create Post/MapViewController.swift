//
//  MapViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/03/2021.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate: class {
    func getLocation(location: String)
}

class MapViewController: UIViewController {
    
//MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var searchController: UISearchController?
    var selectedPin: MKPlacemark?
    let newPin = MKPointAnnotation()
    var detailLocation: String?
    weak var mapDelegate: MapViewControllerDelegate?

//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()
        setSearchBar()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchController?.isActive = true
        DispatchQueue.main.async {
            self.searchController?.becomeFirstResponder()
        }
    }
    
//MARK: SetData
    func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(mapLongPress(_:)))
        longPress.minimumPressDuration = 0.1
        mapView.addGestureRecognizer(longPress)
    }
    
    func setUI() {
        contentViewHeightConstraint.constant = 0
        addLocationButton.imageView?.contentMode = .scaleAspectFill
    }
    
    func setSearchBar() {
        let locationSearchViewController = LocationSearchViewController()
        locationSearchViewController.mapView = mapView
        locationSearchViewController.locationDelegate = self
        searchController = UISearchController(searchResultsController: locationSearchViewController)
        searchController?.searchResultsUpdater = locationSearchViewController
        searchController?.searchBar.placeholder = "Search places"
        navigationItem.titleView = searchController?.searchBar
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        searchController?.searchBar.delegate = self
    }
    
    @objc func getLocation() {
        self.mapDelegate?.getLocation(location: detailLocation ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func mapLongPress(_ recognizer: UIGestureRecognizer) {
        let touchedAt = recognizer.location(in: self.mapView)
        let touchedAtCoordinate : CLLocationCoordinate2D = mapView.convert(touchedAt, toCoordinateFrom: self.mapView)
        let location: CLLocation = CLLocation(latitude: touchedAtCoordinate.latitude, longitude: touchedAtCoordinate.longitude)
        let geocodeLocation = CLGeocoder()
        geocodeLocation.reverseGeocodeLocation(location) { (placemarks, error) in
            if (error != nil) {
                self.present(Utilities.showAlert(message: error!.localizedDescription), animated: true, completion: nil)
            }
            if let listPlacemark = placemarks {
                if listPlacemark.count > 0 {
                    let firstPlacemark = placemarks![0]
                    var addressString: String = ""
                    if let local = firstPlacemark.locality, let country = firstPlacemark.country, let subLocal = firstPlacemark.subLocality {
                        addressString.append(subLocal + ", ")
                        addressString.append(local + ", ")
                        addressString.append(country)
                        self.contentViewHeightConstraint.constant = 70
                        self.titleLabel.text = local
                        self.subTitleLabel.text = addressString
                        self.newPin.subtitle = addressString
                        self.detailLocation = addressString
                    } else {
                        self.contentViewHeightConstraint.constant = 0
                    }
                }
            }
            
        }
        mapView.removeAnnotations(mapView.annotations)
        newPin.coordinate = touchedAtCoordinate
        mapView.addAnnotation(newPin)
    }
    
    @IBAction func addLocation(_ sender: Any) {
        self.mapDelegate?.getLocation(location: detailLocation ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: UISearchBarDelegate
extension MapViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            mapView.removeAnnotations(mapView.annotations)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
}

//MARK: LocationSearchDelegate
extension MapViewController: LocationSearchDelegate {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.subtitle = Utilities.parseAddress(selectedItem: placemark)
        self.titleLabel.text = placemark.name
        self.subTitleLabel.text = Utilities.parseAddress(selectedItem: placemark)
        contentViewHeightConstraint.constant = 70
        detailLocation = annotation.subtitle
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
