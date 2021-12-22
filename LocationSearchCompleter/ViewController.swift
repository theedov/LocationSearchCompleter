//
//  ViewController.swift
//  LocationSearchCompleter
//
//  Created by Theo on 3/12/21.
//

import UIKit
import Combine
import MapKit

class ViewController: UIViewController {
    private let searchController: UISearchController = {
        let resultsController = MapSearchCompleterResultsViewController()
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        
        return searchController
    }()
        
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -25.2744, longitude: 133.7751), span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)), animated: true)
        return mapView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemMint
        navigationItem.title = "Search Location"
        navigationItem.searchController = searchController
        
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }


}
