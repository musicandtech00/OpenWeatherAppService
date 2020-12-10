//
//  AddLocationViewController.swift
//  OpenWeatherAppService
//
//  Created by Curtis Wiseman on 12/9/20.
//

import UIKit

class AddLocationViewController: UIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        return searchBar
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .white
        
        return label
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32)
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "skyImage")
        
        return imageView
    }()
    
    private let activityIndicatorView = UIActivityIndicatorView()
    
    private var viewModel: AddLocationViewModel!
    private var loadTemperature = UserDefaults.temperatureNotation()
    private var loadCity = UserDefaults.cityNotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constructSubviewHierarchy()
        constructSubviewConstraints()
        
        viewModel = AddLocationViewModel()
        
        if let savedTemperature = loadTemperature {
            temperatureLabel.text = "\(savedTemperature)"
        }
        
        if let cityName = loadCity {
            cityLabel.text = "\(cityName)"
        }
        
        setupViewModelObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    private func constructSubviewHierarchy() {
        view.addSubview(imageView)
        view.addSubview(searchBar)
        view.addSubview(temperatureLabel)
        view.addSubview(cityLabel)
        view.addSubview(activityIndicatorView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func constructSubviewConstraints() {
        imageView.activateConstraints([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        cityLabel.activateConstraints([
            cityLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        temperatureLabel.activateConstraints([
            temperatureLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10)
        ])
        
        activityIndicatorView.activateConstraints([
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 25),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        searchBar.activateConstraints([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
    }
    
    private func setupViewModelObserver() {
        viewModel.receiveWeatherData = { [weak self] weatherData in
            if
                let weather = weatherData,
                let city = weather.city,
                let temp = weather.temperature {
                    UserDefaults.setTemperatureNotation(temperature: temp)
                    UserDefaults.setCityNotation(city: city)
                    self?.temperatureLabel.text = "\(temp)℉"
                    self?.cityLabel.text = "\(city)"
            } else {
                self?.temperatureLabel.text = ""
                self?.cityLabel.text = ""
            }
        }
        
        viewModel.querying = { [weak self] isQuerying in
            isQuerying ? self?.activityIndicatorView.startAnimating() : self?.activityIndicatorView.stopAnimating()
        }
    }
}

extension AddLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.searchQuery = searchBar.text
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        viewModel.searchQuery = ""
        
        temperatureLabel.text = ""
    }
}
