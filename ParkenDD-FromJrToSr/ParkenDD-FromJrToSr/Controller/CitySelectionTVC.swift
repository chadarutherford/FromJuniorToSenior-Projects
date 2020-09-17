//
//  CitySelectionTVC.swift
//  ParkenDD
//
//  Created by Kilian Költzsch on 30/06/15.
//  Copyright (c) 2015 Kilian Koeltzsch. All rights reserved.
//

import UIKit
import ParkKit

class CitySelectionTVC: UITableViewController {

    var availableCities = [City]()

	override func viewDidLoad() {
		super.viewDidLoad()

        park.fetchCities { [weak self] result in
			switch result {
			case .failure(let error):
				print(error)
			case .success(let apiResponse):
				let showExperimental = UserDefaults.standard.bool(forKey: Defaults.showExperimentalCities)
				self?.availableCities = showExperimental ? apiResponse.cities : apiResponse.cities.filter { $0.hasActiveSupport }
			}
			DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableCities.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "citySelectionCell", for: indexPath)
        let selectedCity = UserDefaults.standard.string(forKey: Defaults.selectedCity) ?? ""

        let city = availableCities[indexPath.row]

        cell.textLabel?.text = city.name
        cell.textLabel?.textColor = city.hasActiveSupport ? .black : .lightGray
		cell.accessoryType = city.name == selectedCity ? .checkmark : .none

		return cell
	}

	// MARK: - Table view delegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		for row in 0..<tableView.numberOfRows(inSection: 0) {
			tableView.cellForRow(at: IndexPath(row: row, section: 0))?.accessoryType = .none
		}
		tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		tableView.deselectRow(at: indexPath, animated: true)

        let selectedCity = availableCities[indexPath.row]

        UserDefaults.standard.set(selectedCity.name, forKey: Defaults.selectedCity)
        UserDefaults.standard.set(selectedCity.name, forKey: Defaults.selectedCityName)
		UserDefaults.standard.synchronize()

		if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let lotlistVC = sceneDelegate.window?.rootViewController?.children[0] as? LotlistViewController {
			lotlistVC.updateData()
		}

		let _ = navigationController?.popToRootViewController(animated: true)
	}

}
