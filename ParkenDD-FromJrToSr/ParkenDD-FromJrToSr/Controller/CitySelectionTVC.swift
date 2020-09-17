//
//  CitySelectionTVC.swift
//  ParkenDD
//
//  Created by Kilian Költzsch on 30/06/15.
//  Copyright (c) 2015 Kilian Koeltzsch. All rights reserved.
//

import UIKit

protocol CitySelectionTVCActions {
	var showExperimental: Bool { get }
	func fetchCities(completion: @escaping (Swift.Result<[CitySelectionTVC.CityViewModel], Error>) -> Void)
	var selectedCity: CitySelectionTVC.CityViewModel { get }
	func didSelect(city: CitySelectionTVC.CityViewModel)
}

class CitySelectionTVC: UITableViewController {
	
	struct CityViewModel {
		let name: String
		let hasActiveSupport: Bool
	}

	var delegate: CitySelectionTVCActions!
    var availableCities = [CityViewModel]()
	var selectedFilters = [Int: Int]()

	override func viewDidLoad() {
		super.viewDidLoad()

        delegate.fetchCities { result in
			switch result {
			case .failure(let error):
				print(error)
			case .success(let cities):
				self.availableCities = self.delegate.showExperimental ? cities : cities.filter { $0.hasActiveSupport }
			}
			DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
	}
	
	class func new(delegate: CitySelectionTVCActions) -> CitySelectionTVC {
		let settingsStoryboard = UIStoryboard(name: "Settings", bundle: Bundle.main)
		let citySelectionTVC = settingsStoryboard.instantiateViewController(identifier: "City SelectionTVC") as! CitySelectionTVC
		citySelectionTVC.delegate = delegate
		return citySelectionTVC
	}
}

extension CitySelectionTVC {
	// MARK: - Table view data source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return availableCities.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "citySelectionCell", for: indexPath)
		let selectedCity = delegate.selectedCity

		let city = availableCities[indexPath.row]

		cell.textLabel?.text = city.name
		cell.textLabel?.textColor = city.hasActiveSupport ? .black : .lightGray
		cell.accessoryType = city.name == selectedCity.name ? .checkmark : .none

		return cell
	}
}

extension CitySelectionTVC {
	// MARK: - Table view delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Deselect the row
		tableView.deselectRow(at: indexPath, animated: false)
		
		// Did the user tap on a selected filter item? If so, do nothing
		guard let selectedFilterRow = selectedFilters[indexPath.section] else { return }
		if selectedFilterRow == indexPath.row {
			return
		}
		
		// Remove the checkmark from the previously selected filter item
		if let previousCell = tableView.cellForRow(at: IndexPath(row: selectedFilterRow, section: indexPath.section)) {
			previousCell.accessoryType = .none
		}
		
		// Mark the newly selected filter item with a checkmark
		if let cell = tableView.cellForRow(at: indexPath) {
			cell.accessoryType = .checkmark
		}
		
		// Remember this filter item
		selectedFilters[indexPath.section] = indexPath.row
		
		// Notify of selection
		let selectedCity = availableCities[indexPath.row]
		delegate.didSelect(city: selectedCity)
	}
}
