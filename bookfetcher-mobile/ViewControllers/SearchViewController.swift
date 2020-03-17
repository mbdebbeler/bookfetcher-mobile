//
//  SearchViewController.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/10/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    let bookStore: BookStore
    let searchResultsViewController: SearchResultsViewController
    let noResultsView = NoResultsView()
    let searchController: UISearchController
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    init(bookStore: BookStore) {
        self.bookStore = bookStore
        self.searchResultsViewController = SearchResultsViewController(bookStore: bookStore)
        self.searchController = UISearchController(searchResultsController: searchResultsViewController)
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
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        view.backgroundColor = .white
        view.addSubview(noResultsView)
        noResultsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            noResultsView.pin(to: view)
        )
        noResultsView.isHidden = true
    }
    
    func returnTrue() -> Bool {
        return true
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.searchResultsViewController.loadingView.isHidden = false
        bookStore.searchGoogleBooks(query: query) { [weak self] (result: Result<[Book], Error>) in
            switch result {
            case let .success(books):
                DispatchQueue.main.async {
                    self?.searchResultsViewController.books = books
                    self?.searchResultsViewController.tableView .reloadData()
                    self?.searchResultsViewController.loadingView.isHidden = true
                }
            case let .failure(error):
                print(error)
            }
        }
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

