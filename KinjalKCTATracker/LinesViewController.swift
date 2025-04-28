//
//  LinesViewController.swift
//  KinjalKCTATracker
//
//  Created by kinjal kathiriya  on 4/27/25.
//

import UIKit

class LinesViewController: UITableViewController {
    private var trainLines: [TrainLine] = []
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupActivityIndicator()
            loadData() // Load data immediately when view loads
        }
    
    func loadInitialData() {
        activityIndicator.startAnimating()
        loadData()
    }
    
    private func setupUI() {
            title = "CTA Train Lines"
            navigationController?.navigationBar.prefersLargeTitles = true
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
            self.refreshControl = refreshControl
        }
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func loadData() {
            activityIndicator.startAnimating()
            APIService.shared.fetchTrainLines { [weak self] result in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.refreshControl?.endRefreshing()
                    
                    switch result {
                    case .success(let lines):
                        self?.trainLines = lines
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
    
    // MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainLines.isEmpty ? 1 : trainLines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if trainLines.isEmpty {
            var content = cell.defaultContentConfiguration()
            content.text = "Loading train lines..."
            cell.contentConfiguration = content
            cell.accessoryType = .none
            return cell
        }
        
        let line = trainLines[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = line.name
        content.secondaryText = "\(line.stations.count) stations"
        content.image = UIImage(systemName: "tram.fill")
        
        switch line.color {
        case "Red": content.imageProperties.tintColor = .systemRed
        case "Blue": content.imageProperties.tintColor = .systemBlue
        case "Brown": content.imageProperties.tintColor = .brown
        case "Green": content.imageProperties.tintColor = .systemGreen
        case "Orange": content.imageProperties.tintColor = .orange
        case "Purple": content.imageProperties.tintColor = .purple
        case "Pink": content.imageProperties.tintColor = .systemPink
        case "Yellow": content.imageProperties.tintColor = .systemYellow
        default: content.imageProperties.tintColor = .darkGray
        }
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !trainLines.isEmpty else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let line = trainLines[indexPath.row]
        let stationsVC = StationsViewController()
        stationsVC.stations = line.stations
        stationsVC.lineColor = line.color
        stationsVC.title = line.name + " Stations"
        navigationController?.pushViewController(stationsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
