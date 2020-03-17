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
    let tableView = UITableView()
    let loadingView = LoadingView()
    let noResultsView = NoResultsView()
    var books: [Book] = []
    
    init(bookStore: BookStore) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.register(BookCell.self, forCellReuseIdentifier: String(describing: BookCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(noResultsView)
        view.addSubview(tableView)
        view.addSubview(loadingView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        noResultsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            tableView.pin(to: view) + loadingView.pin(to: view) + noResultsView.pin(to: view)
            )
        loadingView.isHidden = true
        noResultsView.isHidden = true
    }
    
    func prepareForSearch() {
        loadingView.isHidden = false
        noResultsView.isHidden = true
    }
    
    func handle(result: Result<[Book], Error>) {
        switch result {
        case let .success(books):
            DispatchQueue.main.async { [weak self] in
                self?.books = books
                self?.tableView .reloadData()
                self?.loadingView.isHidden = true
                if books.isEmpty {
                    self?.noResultsView.isHidden = false
                }
            }
        case let .failure(error):
            print(error)
        }
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookCell.self), for: indexPath) as? BookCell else {
            fatalError("Cell not registered properly")
        }
        let cellNumber = books[indexPath.row].title
        cell.label.text = cellNumber
        return cell
    }
    
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(books[indexPath.row].title)
    }
    
}
