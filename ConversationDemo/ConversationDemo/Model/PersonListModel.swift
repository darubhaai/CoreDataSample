//
//  PersonListModel.swift
//  ConversationDemo
//
//  Created by Darshan D T on 21/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import Foundation


class MessageParticipant: PersonProtocol {

    private let personNumber: Int
    private let personName: String

    init(name: String, number: Int) {
        self.personName = name
        self.personNumber = number
    }

    var firstName: String {
        return personName
    }

    var mobile: Int {
        return personNumber
    }

}

/**
 ViewModel for PersonListViewController
 */
class PersonListModel {

    private let exludedPerson: PersonProtocol?
    private lazy var persons = [PersonProtocol]()

    init(filteredBy exludedPerson: PersonProtocol? = nil) {
        self.exludedPerson = exludedPerson
        loadPersons()
    }

    private func loadPersons() {
        if let exludedPerson = exludedPerson {
            if let results = PersistentStorageManager.shared.fetchPersonList(byFiltering: exludedPerson) {
                persons = results
            }
        } else {
            if let results = PersistentStorageManager.shared.fetchPersonList() {
                persons = results
            }
        }
    }

    var numberOfPersons: Int {
        return persons.count
    }

    var lastItemIndex: Int {
        return persons.count - 1
    }

    func person(atIndex index: Int)-> PersonProtocol{
        return persons[index]
    }

    func addPerson(_ person: PersonProtocol) {
        PersistentStorageManager.shared.addPerson(person)
        persons.append(person)
    }

    func deletePerson(atIndexPath indexPath: IndexPath) {
        PersistentStorageManager.shared.deletePerson(persons[indexPath.row])
        persons.remove(at: indexPath.row)
    }
}
