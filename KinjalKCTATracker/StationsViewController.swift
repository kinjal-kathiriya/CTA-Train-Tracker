//
//  StationsViewController.swift
//  KinjalKCTATracker
//
//  Created by kinjal kathiriya  on 4/27/25.
//

import UIKit

class StationsViewController: UITableViewController {
    var stations: [Station] = []
    var lineColor: String = "Black"
    private var refreshTimer: Timer?
    private let refreshInterval: TimeInterval = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Configure title if not already set
        if title == nil {
            title = "Stations"
        }
        
        // Register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Set background colors
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        
        // Set tint color based on line color
        setNavigationTintColor()
    }
    
    
    private func setNavigationTintColor() {
        var tintColor: UIColor = .systemBlue
        
        switch lineColor {
        case "Red":
            tintColor = .systemRed
        case "Blue":
            tintColor = .systemBlue
        case "Brown":
            tintColor = .brown
        case "Green":
            tintColor = .systemGreen
        case "Orange":
            tintColor = .orange
        case "Purple":
            tintColor = .purple
        case "Pink":
            tintColor = .systemPink
        case "Yellow":
            tintColor = .systemYellow
        default:
            tintColor = .darkGray
        }
        
        navigationController?.navigationBar.tintColor = tintColor
    }
    
    // MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.isEmpty ? 1 : stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if stations.isEmpty {
            var content = cell.defaultContentConfiguration()
            content.text = "No stations available"
            cell.contentConfiguration = content
            cell.accessoryType = .none
            return cell
        }
        
        let station = stations[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = station.name
        content.image = UIImage(systemName: "mappin.circle.fill")
        
        // Set color directly
        switch lineColor {
        case "Red":
            content.imageProperties.tintColor = .systemRed
        case "Blue":
            content.imageProperties.tintColor = .systemBlue
        case "Brown":
            content.imageProperties.tintColor = .brown
        case "Green":
            content.imageProperties.tintColor = .systemGreen
        case "Orange":
            content.imageProperties.tintColor = .orange
        case "Purple":
            content.imageProperties.tintColor = .purple
        case "Pink":
            content.imageProperties.tintColor = .systemPink
        case "Yellow":
            content.imageProperties.tintColor = .systemYellow
        default:
            content.imageProperties.tintColor = .darkGray
        }
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if stations.isEmpty {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let station = stations[indexPath.row]
        let arrivalsVC = ArrivalsViewController()
        arrivalsVC.station = station
        arrivalsVC.lineColor = lineColor
        navigationController?.pushViewController(arrivalsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
