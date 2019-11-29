//
//  SenderListController.swift
//  ConversationDemo
//
//  Created by Darshan D T on 22/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import Foundation
import UIKit

class SenderListViewController: PersonListBaseViewController {

    override class func instantiate()-> SenderListViewController {
        let senderListController: SenderListViewController = Storyboards.Home.instantiate(identifier: "SenderListViewController")
        return senderListController
    }

    // MARK: -
    // MARK: View Life Cycle
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // MARK: -

    override func loadPersons() {
        super.loadPersons()
    }

    override func didSelectPerson(_ person: PersonProtocol) {
        let receiverController = ReceiverListViewController.instantiate(sender: person)
        navigationController?.pushViewController(receiverController, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonListTableVCEmbedSegue" {
            if let controller = segue.destination as? PersonListTableViewController {
                controller.personListModel = PersonListModel()
                controller.personSelectionDelegate = self
                personListTableViewController = controller
            }
        }
    }
}
