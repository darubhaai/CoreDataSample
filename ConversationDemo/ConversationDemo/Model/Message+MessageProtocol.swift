//
//  Message+MessageProtocol.swift
//  ConversationDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import Foundation

extension CDMessage: MessageProtocol {
    public var fromPerson: PersonProtocol {
        return sender!
    }

    public var toPerson: PersonProtocol {
        return receiver!
    }

    public var textMessage: String {
        return content ?? ""
    }

    public var timeStampString: String {
        return timeStamp ?? ""
    }

    public var dateCreated: Date {
        return creationDate ?? Date()
    }
}
