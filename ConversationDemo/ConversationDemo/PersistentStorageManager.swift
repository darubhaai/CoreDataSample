//
//  PersistantStorageManager.swift
//  ChatAppDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PersistentStorageManager {
    private struct Keys {
        static let name = "name"
        static let mobileNumber = "mobileNumber"
        static let sender = "sender"
        static let receiver = "receiver"
        static let creationDate = "creationDate"
        static let timeStamp = "timeStamp"
        static let content = "content"
        static let messageEntity = "CDMessage"
        static let personEntity = "CDPerson"
    }

    static let shared = PersistentStorageManager()

    private init() {
        addObservers()
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(forName:  UIApplication.willResignActiveNotification, object: nil, queue: .main) { (notification) in
            PersistentStorageManager.shared.saveChanges()
        }
    }

    // MARK: - Core Data stack

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ConversationDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Verify if name of your Data Model is mentioned correctly \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data Saving support

    func saveChanges () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchMessagesForConversation(_ conversation: ConversationObject) -> [CDMessage]? {
        let messagesFetchRequest = NSFetchRequest<CDMessage>(entityName: Keys.messageEntity)
        var messages: [CDMessage]?
        let sortDescriptor = NSSortDescriptor(key: Keys.creationDate, ascending: false)
        messagesFetchRequest.sortDescriptors = [sortDescriptor]
        messagesFetchRequest.predicate = NSCompoundPredicate(forConversation: conversation)
        do {
            let results = try managedObjectContext.fetch(messagesFetchRequest)
            messages = results
        }
        catch {
            print("***** Failed to load Messages *****")
        }
        return messages
    }

    func fetchPersonList(byFiltering excludedPerson: PersonProtocol? = nil) -> [CDPerson]? {
        let personFetchRequest = NSFetchRequest<CDPerson>(entityName: Keys.personEntity)
        var persons: [CDPerson]?

        //Filter if any exclusions are requested
        if let excludedPerson = excludedPerson {
            personFetchRequest.predicate = NSPredicate(notMatching: excludedPerson)
        }

        do {
            let results = try managedObjectContext.fetch(personFetchRequest)
            persons = results
        }
        catch {
            print("Failed to load person from Persistance Storage")
        }

        return persons
    }

    private func person(forObject personObject: PersonProtocol) -> CDPerson {
        var person: CDPerson!
        let personFetchRequest: NSFetchRequest<CDPerson> = CDPerson.fetchRequest()
        personFetchRequest.predicate = NSPredicate(personWithNumber: personObject.mobile)
        do {
            let personResult = try managedObjectContext.fetch(personFetchRequest).first
            person = personResult
        }
        catch {
            debugPrint("Failed to fetch Person: \(personObject)")
        }

        if person == nil {
            let personEntity = NSEntityDescription.entity(forEntityName: Keys.personEntity, in: managedObjectContext)!
            let personManagedObject = NSManagedObject(entity: personEntity, insertInto: managedObjectContext) as! CDPerson
            personManagedObject.setValue(personObject.firstName, forKey: Keys.name)
            personManagedObject.setValue(personObject.mobile, forKey: Keys.mobileNumber)
            person = personManagedObject
        }

        return person
    }

    func addMessage(_ messageObject: MessageProtocol) {
        let sender = person(forObject: messageObject.fromPerson)
        let receiver = person(forObject: messageObject.toPerson)
        guard let messageEntity = NSEntityDescription.entity(forEntityName: Keys.messageEntity, in: managedObjectContext) else { return }
        let message = NSManagedObject(entity: messageEntity, insertInto: managedObjectContext)
        message.setValue(sender, forKey: Keys.sender)
        message.setValue(receiver, forKey: Keys.receiver)
        message.setValue(messageObject.textMessage, forKey: Keys.content)
        message.setValue(Date(), forKey: Keys.creationDate)
        message.setValue(messageObject.timeStampString, forKey: Keys.timeStamp)
        saveChanges()
    }

    func deleteMessage(_ messageObject: MessageProtocol) {
        let fetchRequest = NSFetchRequest<CDMessage>(entityName: Keys.messageEntity)
        fetchRequest.predicate = NSPredicate(matching: messageObject)
        do {
            let messages = try managedObjectContext.fetch(fetchRequest)
            if let deletionObject = messages.first {
                managedObjectContext.delete(deletionObject)
            }
        }
        catch {
            print("Failed to get message")
        }
    }

    func hasPerson(withNumber mobileNumber: Int) -> Bool {
        var hasPerson = false
        let personFetchRequest: NSFetchRequest<CDPerson> = CDPerson.fetchRequest()
        personFetchRequest.predicate = NSPredicate(personWithNumber: mobileNumber)
        do {
            let personResult = try managedObjectContext.fetch(personFetchRequest)
            hasPerson = !personResult.isEmpty
        }
        catch {
            debugPrint("Failed to fetch Person with Mobile number: \(mobileNumber)")
        }
        return hasPerson
    }

    func addPerson(_ person: PersonProtocol)  {
        guard let personEntity = NSEntityDescription.entity(forEntityName: Keys.personEntity, in: managedObjectContext) else { return }
        let personObject = NSManagedObject(entity: personEntity, insertInto: managedObjectContext)

        personObject.setValue(person.firstName, forKey: Keys.name)
        personObject.setValue(person.mobile, forKey: Keys.mobileNumber)
        saveChanges()
    }

    func deletePerson(_ person: PersonProtocol) {
        let fetchRequest = NSFetchRequest<CDPerson>(entityName: Keys.personEntity)
        fetchRequest.predicate = NSPredicate(personWithNumber: person.mobile)
        do {
            let persons = try managedObjectContext.fetch(fetchRequest)
            if let deletionObject = persons.first {
                managedObjectContext.delete(deletionObject)
            }
        }
        catch {
            print("Failed to get message")
        }
    }
}
