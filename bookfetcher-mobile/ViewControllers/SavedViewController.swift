//
//  SavedViewController.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/10/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//
import Foundation
import UIKit

class SavedViewController: UIViewController {
    
    let bookCollectionViewController: BookCollectionViewController
    let booksClient: BooksClient
    var savedBooks: [Book] {
        get { bookCollectionViewController.books }
        set { bookCollectionViewController.books = newValue }
    }
    
    init(booksClient: LocalBooksClient) {
        self.booksClient = booksClient
        self.bookCollectionViewController = BookCollectionViewController()
        super.init(nibName: nil, bundle: nil)
        getLocalBooks()
        tabBarItem.image = UIImage(systemName: "bookmark.fill")
        tabBarItem.title = "Saved"
        navigationItem.title = "BookFetcher"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(bookCollectionViewController)
        bookCollectionViewController.didMove(toParent: self)
        bookCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bookCollectionViewController.view)
        self.bookCollectionViewController.delegate = self
        NSLayoutConstraint.activate(bookCollectionViewController.view.pin(to: view))
        view.backgroundColor = .white
    }
    
    private func getLocalBooks() {
        self.booksClient.search(query: "stub", offset: 0) { [weak self] (result: Result<[Book], Error>) in
            if let books = try? result.get(), books.isEmpty {
                print("No local books")
            } else {
                self?.handle(result: result)
            }
        }
    }
    
    private func handle(result: Result<[Book], Error>) {
        switch result {
        case let .success(books):
            self.savedBooks = books
        case let .failure(error):
            print(error)
        }
    }
}

extension SavedViewController: BookCollectionViewControllerDelegate {
    func isDelegate() {
        print("I am the delegate.")
    }
}
