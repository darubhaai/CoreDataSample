//
//  ConversationListViewController.swift
//  ChatAppDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import UIKit
import CoreData

class ConversationListViewController: UIViewController {

    // MARK: -
    // MARK: Outlets
    // MARK: -
    @IBOutlet weak var conversationListTableView: UITableView!

    // MARK: -
    // MARK: Properties
    // MARK: -
    private var conversationListModel: ConversationListModel!

    // MARK: -
    // MARK: View Life Cycle
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureConversations()
    }

    // MARK: -
    // MARK: Private Methods
    // MARK: -
    private func configureConversations() {
        conversationListModel = ConversationListModel()
    }

    private func loadConversation(atIndex index: Int) {
        let conversation = Conversation(rawValue: index)!
        let conversationVC = ConversationViewController.instantiate(with: conversation.object)
        navigationController?.pushViewController(conversationVC, animated: true)
    }

}

// MARK: -
// MARK: Tableview DataSource and Delegate
// MARK: -
extension ConversationListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationListModel.numberOfChats
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        guard let conversationListCell = tableView.dequeueReusableCell(withIdentifier: "ConversationListTableViewCell", for: indexPath) as? ConversationListTableViewCell else {
            return defaultCell
        }
        let conversation = conversationListModel.conversationAtIndex(indexPath.row)
        conversationListCell.configure(with: conversation)
        return conversationListCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadConversation(atIndex: indexPath.row)
    }
}
