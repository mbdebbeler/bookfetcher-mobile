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
    
    init() {
        self.bookCollectionViewController = BookCollectionViewController()
        super.init(nibName: nil, bundle: nil)
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
}

extension SavedViewController: BookCollectionViewControllerDelegate {
    func isDelegate() {
        print("I am the delegate.")
    }
}
