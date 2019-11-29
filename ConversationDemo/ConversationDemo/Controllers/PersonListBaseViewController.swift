//
//  PersonListBaseViewController.swift
//  ConversationDemo
//
//  Created by Darshan D T on 21/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import UIKit

typealias PersonListController = UIViewController & PersonSelectionDelegate

class PersonListBaseViewController: PersonListController {
    var personListTableViewController: PersonListTableViewController?
    class func instantiate() -> PersonListBaseViewController {
        let personListController: PersonListBaseViewController = Storyboards.Home.instantiate(identifier: "PersonListViewController")
        return personListController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPersons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        personListTableViewController?.reloadData()
    }

    // Subclassess must overide this method
    func loadPersons() {
        
    }

    //Subclasses override this method to choose next screen on item selection
    func didSelectPerson(_ person: PersonProtocol) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonListTableVCEmbedSegue" {
            if let controller = segue.destination as? PersonListTableViewController {
                controller.personListModel = PersonListModel()
            }
        }
    }

}
