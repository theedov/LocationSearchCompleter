//
//  MapSearchCompleter.swift
//  LocationSearchCompleter
//
//  Created by Theo on 3/12/21.
//

import UIKit
import Combine
import MapKit

class MapSearchCompleter: NSObject {
    let locationResults = CurrentValueSubject<[MKLocalSearchCompletion], Never>([])
    let searchTerm = CurrentValueSubject<String, Never>("")
    
    private var cancellables = Set<AnyCancellable>()
    private var searchCompleter = MKLocalSearchCompleter()
    private var currentPromise: ((Result<[MKLocalSearchCompletion], Error>) -> Void)?
    
    override init() {
        super.init()
        searchCompleter.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -25.2744, longitude: 133.7751), latitudinalMeters: 20000, longitudinalMeters: 20000)
        searchCompleter.resultTypes = [.address]
        searchCompleter.delegate = self
        
        searchTerm
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap({ self.searchTermToResults(searchTerm: $0) })
            .sink { completion in
                print(completion)
            } receiveValue: { results in
                print("HMMM")
                self.locationResults.send(results)
            }
            .store(in: &cancellables)

    }
    
    private func searchTermToResults(searchTerm: String) -> Future<[MKLocalSearchCompletion], Error> {
        Future { promise in
            self.searchCompleter.queryFragment = searchTerm
            self.currentPromise = promise
        }
    }
}

extension MapSearchCompleter: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results.filter({$0.title.lowercased().contains("australia") || $0.subtitle.lowercased().contains("australia")})
        
        currentPromise?(.success(results))
    }
}
