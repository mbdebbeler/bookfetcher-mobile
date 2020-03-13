//
//  SecondViewController.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/10/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.image = UIImage(named: "saved")
        tabBarItem.title = "Saved"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }


}

