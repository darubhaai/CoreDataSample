//
//  Person+PersonProtocol.swift
//  ConversationDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import Foundation

extension CDPerson: PersonProtocol {
    public var number: Int {
        return Int(mobileNumber)
    }

    public var title: String {
        return name ?? ""
    }
}
