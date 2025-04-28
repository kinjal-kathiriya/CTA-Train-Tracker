
//
//  ArrivalsViewController.swift
//  KinjalKCTATracker
//
//  Created by kinjal kathiriya  on 4/27/25.
//

import UIKit

class ArrivalsViewController: UITableViewController {
    var station: Station!
    var lineColor: String = "Black"
    private var arrivals: [Arrival] = []
    private var timer: Timer?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActivityIndicator()
        loadData()
        startAutoRefresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    private func setupUI() {
        title = "\(station.name) Arrivals"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Set background colors
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        
        // Set tint color
        setNavigationTintColor()
        
        // Create and configure refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        refreshControl.tintColor = getColorForLine()
        self.refreshControl = refreshControl
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // Add autolayout constraints
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func startAutoRefresh() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.loadData()
        }
    }
    
    @objc func loadData() {
        activityIndicator.startAnimating()
        APIService.shared.fetchArrivals(for: station.stopId) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.refreshControl?.endRefreshing()
                
                switch result {
                case .success(let arrivals):
                    self?.arrivals = arrivals
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            self.loadData()
        })
        present(alert, animated: true)
    }
    
    private func setNavigationTintColor() {
        navigationController?.navigationBar.tintColor = getColorForLine()
    }
    
    private func getColorForLine() -> UIColor {
        switch lineColor {
        case "Red":
            return .systemRed
        case "Blue":
            return .systemBlue
        case "Brown":
            return .brown
        case "Green":
            return .systemGreen
        case "Orange":
            return .orange
        case "Purple":
            return .purple
        case "Pink":
            return .systemPink
        case "Yellow":
            return .systemYellow
        default:
            return .darkGray
        }
    }
    
    // MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrivals.isEmpty ? 1 : arrivals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
        if arrivals.isEmpty {
            var content = cell.defaultContentConfiguration()
            content.text = "No arrivals information available"
            content.textProperties.color = .secondaryLabel
            cell.contentConfiguration = content
            return cell
        }
        
        let arrival = arrivals[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = "To \(arrival.destination)"
        content.secondaryText = "Arrives at \(arrival.arrivalTime)"
        content.image = UIImage(systemName: "train.side.front.car")
        content.imageProperties.tintColor = getColorForLine()
        if arrival.isDelayed {
            content.secondaryTextProperties.color = .systemRed
            content.secondaryText = "⚠️ DELAYED: \(arrival.arrivalTime)"
        }
        
        cell.contentConfiguration = content
        return cell
    }
}
