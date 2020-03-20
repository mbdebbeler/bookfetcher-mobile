//
//  SearchResultsViewController.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/16/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import UIKit

class SearchResultsViewController: UIViewController {
    weak var delegate: SearchResultsViewControllerDelegate? {
        didSet {
            tableView.delegate = delegate
        }
    }
    let tableView = BookTableViewController()
    let loadingView = LoadingView()
    let noResultsView = NoResultsView()
    let errorView = ErrorView()
    let notConnectedErrorCode = -1009
    var books: [Book] {
        get { tableView.books }
        set { tableView.books = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(tableView)
        tableView.didMove(toParent: self)
        addSubviews()
        removeAutoresizingMaskFromSubviews()
        layOutSubviewConstraints()
        hideSubviews()
    }

    private func addSubviews() {
        view.addSubview(tableView.view)
        view.addSubview(noResultsView)
        view.addSubview(loadingView)
        view.addSubview(errorView)
    }
    
    private func removeAutoresizingMaskFromSubviews() {
        tableView.view.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        noResultsView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layOutSubviewConstraints() {
        NSLayoutConstraint.activate(
            tableView.view.pin(to: view) +
                loadingView.pin(to: view) +
                noResultsView.pin(to: view) +
                errorView.pin(to: view)
        )
    }
    
    private func hideSubviews() {
        loadingView.isHidden = true
        noResultsView.isHidden = true
        errorView.isHidden = true
    }
    
    func clearSearch() {
        tableView.books = []
        noResultsView.isHidden = true
        errorView.isHidden = true
    }
    
    func prepareForSearch() {
        loadingView.isHidden = false
        clearSearch()
    }
    
    func handle(result: Result<[Book], Error>) {
        switch result {
        case let .success(books):
            self.books += books
            loadingView.isHidden = true
            if self.books.isEmpty {
                noResultsView.isHidden = false
            }
        case let .failure(error):
            let code = (error as NSError)._code
            if code == notConnectedErrorCode {
                errorView.label.text = error.localizedDescription
                errorView.isHidden = false
            } else {
                noResultsView.isHidden = false
            }
            print(error)
        }
    }
}

protocol SearchResultsViewControllerDelegate: class {
    func didScrollToBottom()
}
