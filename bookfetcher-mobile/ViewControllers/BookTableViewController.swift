//
//  BookTableViewController.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/24/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import UIKit

class BookTableViewController: UIViewController {
    let tableView = UITableView()
    weak var delegate: SearchResultsViewControllerDelegate?

    var books: [Book] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
           super.viewDidLoad()
           tableView.backgroundColor = .white
           tableView.register(BookCell.self, forCellReuseIdentifier: String(describing: BookCell.self))
           tableView.dataSource = self
           tableView.delegate = self
           view.addSubview(tableView)
           
           tableView.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate(
               tableView.pin(to: view)
           )
       }
}

extension BookTableViewController: UITableViewDataSource {
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
            cell.thumbnailImageView.image = UIImage(systemName: "book.circle.fill")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension BookTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(books[indexPath.row].title)
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom <= height {
            delegate?.didScrollToBottom()
        }
    }
    
}
