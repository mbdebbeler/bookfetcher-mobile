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
    weak var delegate: SearchResultsViewControllerDelegate?
    let tableView = UITableView()
    let loadingView = LoadingView()
    let noResultsView = NoResultsView()
    let errorView = ErrorView()
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
        view.addSubview(tableView)
        view.addSubview(noResultsView)
        view.addSubview(loadingView)
        view.addSubview(errorView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        noResultsView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            tableView.pin(to: view) +
                loadingView.pin(to: view) +
                noResultsView.pin(to: view) +
                errorView.pin(to: view)
        )
        loadingView.isHidden = true
        noResultsView.isHidden = true
        errorView.isHidden = true
    }
    
    func prepareForSearch() {
        books = []
        loadingView.isHidden = false
        noResultsView.isHidden = true
        errorView.isHidden = true
    }
    
    func handle(result: Result<[Book], Error>) {
        switch result {
        case let .success(books):
            self.books += books
            tableView .reloadData()
            loadingView.isHidden = true
            if self.books.isEmpty {
                noResultsView.isHidden = false
            }
        case let .failure(error):
            let code = (error as NSError)._code
            if code == -1009 {
                errorView.label.text = error.localizedDescription
                errorView.isHidden = false
            } else {
                noResultsView.isHidden = false
            }
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
        let book = books[indexPath.row]
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.authors
        if let thumbnailImageURL = book.thumbnailImageURL {
            cell.thumbnailImageView.load(url: thumbnailImageURL)
        } else {
            cell.thumbnailImageView.image = UIImage(named: "sad")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(books[indexPath.row].title)
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            delegate?.didScrollToBottom()
        }
    }
    
}

protocol SearchResultsViewControllerDelegate: class {
    func didScrollToBottom()
}
