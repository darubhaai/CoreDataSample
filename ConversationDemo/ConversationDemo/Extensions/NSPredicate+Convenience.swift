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
                                          NSNumber(integerLiteral: conversation.fromPerson.mobile),
                                          NSNumber(integerLiteral: conversation.toPerson.mobile))
        let predicateReceivedBy = NSPredicate(format: "sender.mobileNumber == %@ AND receiver.mobileNumber == %@",
                                              NSNumber(integerLiteral: conversation.toPerson.mobile),
                                              NSNumber(integerLiteral: conversation.fromPerson.mobile))
        self.init(orPredicateWithSubpredicates: [predicateSentBy, predicateReceivedBy])
    }
}

public extension NSPredicate {
    convenience init(personWithNumber mobileNumber: Int) {
        self.init(format: "mobileNumber == %@", NSNumber(value: mobileNumber))
    }

    convenience init(notMatching person: PersonProtocol) {
        self.init(format: "mobileNumber != %@", NSNumber(value: person.mobile), person.firstName)
    }

    convenience init(matching message: MessageProtocol) {
        self.init(format: "creationDate == %@", message.dateCreated as NSDate)
    }
}
