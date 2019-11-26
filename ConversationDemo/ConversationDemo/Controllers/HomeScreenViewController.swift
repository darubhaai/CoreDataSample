//
//  ViewController.swift
//  ChatAppDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func startConversation(_ sender: Any) {
        showPersonSelectionScreen()
    }

    private func showPersonSelectionScreen() {
        let senderListVC = SenderListViewController.instantiate()
        navigationController?.pushViewController(senderListVC, animated: true)
    }
    
}

