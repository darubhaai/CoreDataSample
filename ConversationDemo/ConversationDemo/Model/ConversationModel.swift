//
//  ConversationModel.swift
//  ChatAppDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import Foundation
import CoreData

public protocol MessageProtocol {
    var fromPerson: PersonProtocol { get }
    var toPerson: PersonProtocol { get }
    var textMessage: String { get }
    var timeStampString: String { get }
    var dateCreated: Date { get }
}

class ConversationMessage: MessageProtocol {

    private var messageSender: PersonProtocol
    private var messageReceiver: PersonProtocol
    private var messageContent: String
    private var messageCreationDate: Date

    var fromPerson: PersonProtocol {
        return messageSender
    }

    var toPerson: PersonProtocol {
        return messageReceiver
    }

    var textMessage: String {
        return messageContent
    }

    var dateCreated: Date {
        return messageCreationDate
    }

    var timeStampString: String {
        let dateFormat = "MMM d, yyyy, h:mm a"
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let timeStamp = formatter.string(from: Date())
        return timeStamp
    }

    init(sender: PersonProtocol,
         receiver: PersonProtocol,
         content: String) {
        self.messageSender = sender
        self.messageReceiver = receiver
        self.messageContent = content
        self.messageCreationDate = Date()
    }

}

class MessageModel {
    let conversationObject: ConversationObject

    var messages: [MessageProtocol]!

    init(conversation: ConversationObject) {
        self.conversationObject = conversation
        messages = [CDMessage]()
        loadMessages()
    }

    private func loadMessages() {
        if let messageList = PersistantStorageManager.shared.fetchMessagesForConversation(conversationObject) {
            messages = messageList
        }
    }

    var numberOfMessages: Int {
        return messages.count
    }

    func messageAtIndex(_ index: Int) -> MessageProtocol {
        return messages[index]
    }

    func sendMessage(_ message: MessageProtocol) {
        
    }

    func addMessage(_ message: MessageProtocol) {
        PersistantStorageManager.shared.addMessage(message)
        messages.insert(message, at: 0)
    }

    func deleteMessage(atIndexPath indexPath: IndexPath) {
        PersistantStorageManager.shared.deleteMessage(messages[indexPath.row])
        messages.remove(at: indexPath.row)
    }

    func deleteMessages(atIndexPaths indexPaths: [IndexPath]) {
        
    }

    var lastItemIndex: Int {
        return messages.count > 0 ? messages.count-1 : 0
    }

    func reload() {
        loadMessages()
    }

}
