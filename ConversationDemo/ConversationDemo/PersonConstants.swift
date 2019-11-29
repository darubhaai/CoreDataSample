//
//  PersonConstants.swift
//  ConversationDemo
//
//  Created by Darshan D T on 23/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import Foundation
import UIKit

enum PersonListMode {
    case senderList
    case receiverList

    var screenTitle: String {
        switch self {
        case .senderList: return "Choose a Person\nto\nSend Messages"
        case .receiverList:
            return "Choose a Person\nto\nReceive message from "
        }
    }
}

enum PersonEntryFieldType {
    case name
    case mobileNumber
}

enum PersonPropertyEntryValidationStatus {
    case empty(forFieldType: PersonEntryFieldType)
    case valid(forFieldType: PersonEntryFieldType)
    case invalid(forFieldType: PersonEntryFieldType)

    var validationText: String {
        switch self {
        case .empty(let fieldType):
            switch fieldType {
            case .name:
                return "Only alphabets and underscores are allowed"
            case .mobileNumber:
                return "10 digit number"
            }
        case .invalid(let fieldType):
            switch fieldType {
            case .name:
                return "Please enter a valid Name!"
            case .mobileNumber:
                return "Please enter a valid Mobile number!"
            }
        case .valid(let fieldType):
            switch fieldType {
            case .name:
                return "Valid name entered"
            case .mobileNumber:
                return "Valid mobile number entered"
            }
        }
    }

    var color: UIColor {
        switch self {
        case .empty:
            return UIColor.darkText
        case .valid:
            return UIColor(named: "Valid Person Property Color")!
        case .invalid:
            return UIColor(named: "Invalid Person Property Color")!
        }
    }
}
