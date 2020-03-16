//
//  SearchViewController.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/10/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let noResultsView = NoResultsView()
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.image = UIImage(systemName: "magnifyingglass")
        tabBarItem.title = "Search"
        navigationItem.title = "BookFetcher"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Books"
        navigationItem.searchController = searchController

        definesPresentationContext = true
        view.backgroundColor = .systemTeal
        view.addSubview(noResultsView)
        noResultsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noResultsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noResultsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noResultsView.topAnchor.constraint(equalTo: view.topAnchor),
            noResultsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        noResultsView.isHidden = true
    }
    
    func returnTrue() -> Bool {
        return true
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if !isSearchBarEmpty {
        noResultsView.isHidden = false
    } else {
        noResultsView.isHidden = true
    }
  }
}

class NoResultsView: UIView {
    
    let label = UILabel()

    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        label.text = "No results."
        label.textColor = .black
        label.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        label.font = UIFont.boldSystemFont(ofSize: 32)
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
}
