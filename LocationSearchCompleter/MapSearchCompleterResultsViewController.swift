//
//  MapSearchCompleterResultsViewController.swift
//  LocationSearchCompleter
//
//  Created by Theo on 3/12/21.
//

import UIKit
import Combine
import MapKit

class MapSearchCompleterResultsViewController: UIViewController {
    // MARK: - UI Components
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Properties
    private let mapSearchCompleter = MapSearchCompleter()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        mapSearchCompleter
            .locationResults
            .map({ $0 })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { results in
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
    }

}

extension MapSearchCompleterResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mapSearchCompleter.locationResults.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())
        var content = cell!.defaultContentConfiguration()
        let result = mapSearchCompleter.locationResults.value[indexPath.row]
        content.text = [result.title, result.subtitle].compactMap({$0}).joined(separator: ", ")
        cell?.contentConfiguration = content
        return cell!
    }
}

extension MapSearchCompleterResultsViewController: UITableViewDelegate {
    
}

extension MapSearchCompleterResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.text.publisher
            .sink(receiveCompletion: {_ in}, receiveValue: { text in
                self.mapSearchCompleter.searchTerm.send(text)
            })
            .store(in: &cancellables)
    }
}
