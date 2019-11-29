//
//  PersonListTableViewController.swift
//  ConversationDemo
//
//  Created by Darshan D T on 23/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import UIKit

protocol PersonSelectionDelegate: class {
    func didSelectPerson(_ person: PersonProtocol)
}

class PersonListTableViewController: UITableViewController, PersonAdditionDelegate {

    
    // MARK: -
    // MARK: Properties
    // MARK: -
    var personListModel: PersonListModel!
    weak var personSelectionDelegate: PersonSelectionDelegate?

    // MARK: -
    // MARK: View Life Cycle
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    // MARK: -
    // MARK: Public Methods
    // MARK: -
    func reloadData() {
        tableView.reloadData()
    }

    // MARK: -
    // MARK: Private Methods
    // MARK: -

    private func configureTableView() {
        tableView.register(UINib(nibName: "PersonListTableViewCell", bundle: .main), forCellReuseIdentifier: "PersonListTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func deletePerson(atIndexPath indexPath: IndexPath) {
        personListModel.deletePerson(atIndexPath: indexPath)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    // MARK: -
    // MARK: TableView DataSource and Delegate
    // MARK: -

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personListModel?.numberOfPersons ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        let personCell = tableView.dequeueReusableCell(withIdentifier: "PersonListTableViewCell", for: indexPath) as? PersonListTableViewCell
        personCell?.configureForPerson(personListModel.person(atIndex: indexPath.row))
        return personCell ?? defaultCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        personSelectionDelegate?.didSelectPerson(personListModel.person(atIndex: indexPath.row))
    }

    func didRequestToAddPerson(_ person: PersonProtocol) {
        personListModel.addPerson(person)
        let insertionIndexPath = IndexPath(row: personListModel.lastItemIndex, section: 0)
        tableView.insertRows(at: [insertionIndexPath], with: .fade)
        tableView.scrollToRow(at: insertionIndexPath, at: .middle, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deletePerson(atIndexPath: indexPath)
        default:
            break
        }
    }

    // MARK: -
    // MARK: IBActions
    // MARK: -
    @IBAction func addPersonTapped(_ sender: Any) {
        let personAdditionVC: PersonAdditionViewController = Storyboards.Home.instantiate(identifier: "PersonAdditionViewController")
        personAdditionVC.additionDelegate = self
        present(personAdditionVC, animated: true, completion: nil)
    }
}

