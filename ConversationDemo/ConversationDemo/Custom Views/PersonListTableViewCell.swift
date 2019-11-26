//
//  PersonListTableViewCell.swift
//  ConversationDemo
//
//  Created by Darshan D T on 22/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import UIKit

class PersonListTableViewCell: UITableViewCell {

    @IBOutlet weak var personNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureForPerson(_ person: PersonProtocol) {
        personNameLabel.text = person.title
    }
    
}
