//
//  NSPredicate+Convenience.swift
//  ConversationDemo
//
//  Created by Darshan D T on 22/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import Foundation

public extension NSCompoundPredicate {
    convenience init(forConversation conversation: ConversationObject) {
        let predicateSentBy = NSPredicate(format: "sender.mobileNumber == %@ AND receiver.mobileNumber == %@",
                                          NSNumber(integerLiteral: conversation.fromPerson.number),
                                          NSNumber(integerLiteral: conversation.toPerson.number))
        let predicateReceivedBy = NSPredicate(format: "sender.mobileNumber == %@ AND receiver.mobileNumber == %@",
                                              NSNumber(integerLiteral: conversation.toPerson.number),
                                              NSNumber(integerLiteral: conversation.fromPerson.number))
        self.init(orPredicateWithSubpredicates: [predicateSentBy, predicateReceivedBy])
    }
}

public extension NSPredicate {
    convenience init(matching person: PersonProtocol) {
        self.init(format: "mobileNumber == %@ AND name == %@", NSNumber(value: person.number), person.title)
    }

    convenience init(notMatching person: PersonProtocol) {
        self.init(format: "mobileNumber != %@ AND name != %@", NSNumber(value: person.number), person.title)
    }

    convenience init(matching message: MessageProtocol) {
        self.init(format: "creationDate == %@", message.dateCreated as NSDate)
    }
}
