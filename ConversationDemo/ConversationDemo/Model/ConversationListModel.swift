//
//  ConversationListModel.swift
//  ChatAppDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import Foundation

public typealias ConversationObject = (fromPerson: PersonProtocol, toPerson: PersonProtocol)

public protocol PersonProtocol {
    var firstName: String { get }
    var mobile: Int { get }
}

enum Conversation: Int {
    case fromJohnToMaria
    case fromMariaToJohn

    var object: ConversationObject {
        let john = John()
        let maria = Maria()
        switch self {
        case .fromJohnToMaria:
            return (john, maria)

        case .fromMariaToJohn:
            return (maria, john)
        }
    }
}

class ConversationListModel {
    var numberOfChats: Int {
        return 2
    }

    func conversationAtIndex(_ index: Int) -> ConversationObject {
        let conversation = Conversation(rawValue: index)!
        return conversation.object
    }
}

// MARK: Stub Implementations
class John: PersonProtocol {
    var firstName: String {
        return "John"
    }

    var mobile: Int {
        return 123456789
    }
}

class Maria: PersonProtocol {
    var firstName: String {
        return "Maria"
    }

    var mobile: Int {
        return 9876543210
    }
}
