//
//  ViewController.swift
//  LocationSearchCompleter
//
//  Created by Theo on 3/12/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private let searchController: UISearchController = {
        let resultsController = MapSearchCompleterResultsViewController()
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemMint
        navigationItem.title = "Search Location"
        navigationItem.searchController = searchController
    }


}

//extension ViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let text = searchController.searchBar.text.publisher
//
//        text
//            .assign(to: \.searchTerm, on: mapSearchCompleter)
//            .store(in: &cancellables)
//
//    }
//}
//
