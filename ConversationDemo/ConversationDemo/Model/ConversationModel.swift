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
    private var selectionState: Bool

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
        selectionState = false
    }

}

class ConversationModel {
    let conversationObject: ConversationObject
    var messages: [MessageProtocol]!
    private lazy var selectedMessages = [IndexPath: MessageProtocol]()

    init(conversation: ConversationObject) {
        self.conversationObject = conversation
        messages = [CDMessage]()
        loadMessages()
    }

    private func loadMessages() {
        if let messageList = PersistentStorageManager.shared.fetchMessagesForConversation(conversationObject) {
            messages = messageList
        }
    }

    var numberOfMessages: Int {
        return messages.count
    }

    func isMessageSelected(atIndexPath indexPath: IndexPath) -> Bool{
        return selectedMessages.keys.contains(indexPath)
    }

    func toggleMessageSelection(atIndexPath indexPath: IndexPath) {
        let isSelected = selectedMessages.keys.contains(indexPath)
        if isSelected {
            deselectMessage(atIndexPath: indexPath)
        } else {
            selectMessage(atIndexPath: indexPath)
        }
    }

    func messageAtIndex(_ index: Int) -> MessageProtocol {
        return messages[index]
    }

    func sendMessage(_ message: MessageProtocol) {
        
    }

    private func selectMessage(atIndexPath indexPath: IndexPath) {
        selectedMessages[indexPath] = messageAtIndex(indexPath.row)
    }

    private func deselectMessage(atIndexPath indexPath: IndexPath) {
        selectedMessages.removeValue(forKey: indexPath)
    }

    func addMessage(_ message: MessageProtocol) {
        PersistentStorageManager.shared.addMessage(message)
        messages.insert(message, at: 0)
    }

    func deleteMessage(atIndexPath indexPath: IndexPath) {
        PersistentStorageManager.shared.deleteMessage(messages[indexPath.row])
        messages.remove(at: indexPath.row)
    }

    func deleteSelectedMessages() {
        let selectedIndices = selectedMessages.compactMap { $0.key.row }
        let messages = selectedMessages.compactMap { $1 }
        messages.forEach {
            PersistentStorageManager.shared.deleteMessage($0)
        }
        selectedIndices.forEach {
            self.messages.remove(at: $0)
        }
        selectedMessages.removeAll()
    }

    var lastItemIndex: Int {
        return messages.count > 0 ? messages.count-1 : 0
    }

    func reload() {
        loadMessages()
    }

    var hasSelections: Bool {
        return !selectedMessages.isEmpty
    }

    var indexPathsForSelectedMessages: [IndexPath] {
        return selectedMessages.compactMap { $0.key }
    }

}
