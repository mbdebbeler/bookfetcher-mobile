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
    var fetchedAllResults = false
    let booksClient: BooksClient
    let searchResultsViewController: SearchResultsViewController
    let searchController: UISearchController
    var lastQuery: String?
    
    init(booksClient: BooksClient) {
        self.booksClient = booksClient
        self.searchResultsViewController = SearchResultsViewController()
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
    
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        lastQuery = query
        fetchedAllResults = false
        self.searchResultsViewController.prepareForSearch()
        self.search(query: query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.lastQuery = nil
        self.fetchedAllResults = false
        self.searchResultsViewController.clearSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.searchResultsViewController.clearSearch()
        }
    }
    
    func search(query: String, offset: Int = 0) {
        if isSearching || fetchedAllResults { return }
        isSearching = true
        booksClient.search(query: query, offset: offset) { [weak self] (result: Result<[Book], Error>) in
            self?.isSearching = false
            if let books = try? result.get(), books.isEmpty {
                self?.fetchedAllResults = true
            }
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


