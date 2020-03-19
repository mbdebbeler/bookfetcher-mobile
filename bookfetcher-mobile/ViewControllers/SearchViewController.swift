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
    
    var isSearching = false
    let bookStore: BookStore
    let searchResultsViewController: SearchResultsViewController
    let searchController: UISearchController
    var lastQuery: String?
    
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
        self.searchResultsViewController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Books"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        view.backgroundColor = .white
    }
    
    func returnTrue() -> Bool {
        return true
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        lastQuery = query
        self.searchResultsViewController.prepareForSearch()
        self.search(query: query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.lastQuery = nil
        self.searchResultsViewController.prepareForSearch()
        self.searchResultsViewController.books = []
        self.searchResultsViewController.tableView .reloadData()
    }
    
    func search(query: String, offset: Int = 0) {
        if isSearching { return }
        isSearching = true
        bookStore.searchGoogleBooks(query: query) { [weak self] (result: Result<[Book], Error>) in
            self?.isSearching = false
            DispatchQueue.main.async { [weak self] in
                self?.searchResultsViewController.handle(result: result)
            }
        }
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func didScrollToBottom() {
        guard let query = lastQuery else { return }
        let offset = searchResultsViewController.books.count
        search(query: query, offset: offset)
    }
}


