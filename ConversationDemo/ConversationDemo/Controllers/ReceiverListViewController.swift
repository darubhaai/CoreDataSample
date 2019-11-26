//
//  ReceiverListViewController.swift
//  ConversationDemo
//
//  Created by Darshan D T on 23/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import UIKit

class ReceiverListViewController: PersonListBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    private var sender: PersonProtocol!

    class func instantiate(sender: PersonProtocol)-> ReceiverListViewController {
        let receiverListController: ReceiverListViewController = Storyboards.Home.instantiate(identifier: "ReceiverListViewController")
        receiverListController.sender = sender
        return receiverListController
    }

    // MARK: -
    // MARK: View Life Cycle
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStrings()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func loadPersons() {
        super.loadPersons()
    }

    override func didSelectPerson(_ person: PersonProtocol) {
        let conversationObject = (fromPerson: sender!, toPerson: person)
        let conversationVC = ConversationViewController.instantiate(with: conversationObject)
        navigationController?.pushViewController(conversationVC, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonListTableVCEmbedSegue" {
            if let controller = segue.destination as? PersonListTableViewController {
                controller.personListModel = PersonListModel(filteredBy: self.sender)
                controller.personSelectionDelegate = self
            }
        }
    }

    // MARK: -
    // MARK: Private methods
    // MARK: -
    private func setupStrings() {
        titleLabel.text = "Choose a person\nto receive messages from\n\(sender.title)"
    }
}
