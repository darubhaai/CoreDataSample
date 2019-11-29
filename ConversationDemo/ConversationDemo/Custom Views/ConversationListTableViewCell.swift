//
//  ConversationListTableViewCell.swift
//  ChatAppDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import UIKit

class ConversationListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var conversationTitleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with conversation: ConversationObject) {
        conversationTitleLabel.text = "\(conversation.fromPerson.firstName) to \(conversation.toPerson.firstName)"
    }

}
