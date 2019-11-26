//
//  PersonAdditionViewController.swift
//  ConversationDemo
//
//  Created by Darshan D T on 22/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import UIKit

protocol PersonAdditionDelegate: class {
    func didRequestToAddPerson(_ person: PersonProtocol)
}

class PersonAdditionViewController: UIViewController {

    // MARK: -
    // MARK: Outlets
    // MARK: -
    @IBOutlet weak var nameEntryTextField: UITextField!
    @IBOutlet weak var numberEntryTextField: UITextField!
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var numberValidationLabel: UILabel!

    // MARK: -
    // MARK: Properties
    // MARK: -
    weak var additionDelegate: PersonAdditionDelegate?
    private let namePattern = "[a-zA-z]{1}\\w{0,19}"
    private let numberPattern = "[1-9]{1}[0-9]{9}"

    // MARK: -
    // MARK: Instance Creation
    // MARK: -
    class func instantiate(delegate: PersonAdditionDelegate)->PersonAdditionViewController {
        let controller: PersonAdditionViewController = Storyboards.Home.instantiate(identifier: "PersonAdditionViewController")
        return controller
    }

    // MARK: -
    // MARK: View Life Cycle
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameEntryTextField?.resignFirstResponder()
        numberEntryTextField?.resignFirstResponder()
    }

    // MARK: -
    // MARK: Private Methods
    // MARK: -
    private var isNameValid: Bool {
        var isValid = false
        guard let name = nameEntryTextField.text else {
            return isValid
        }
        if !name.isEmpty {
            isValid = name.matchesPattern(namePattern)
            if isValid {
                setNameValidation(status: .valid(forFieldType: .name))
            } else {
                setNameValidation(status: .invalid(forFieldType: .name))
            }
        } else {
            setNameValidation(status: .empty(forFieldType: .name))
        }
        return isValid
    }

    private var isNumberValid: Bool {
        var isValid = false
        guard let number = numberEntryTextField.text else {
            return isValid
        }
        if !number.isEmpty {
            isValid = number.matchesPattern(numberPattern)
            if isValid {
                setNumberValidation(status: .valid(forFieldType: .mobileNumber))
            } else {
                setNumberValidation(status: .invalid(forFieldType: .mobileNumber))
            }
        } else {
            setNumberValidation(status: .empty(forFieldType: .mobileNumber))
        }
        return isValid
    }

    private func setNumberValidation(status: PersonPropertyEntryValidationStatus) {
        numberValidationLabel.text = status.validationText
        numberValidationLabel.textColor = status.color
    }

    private func setNameValidation(status: PersonPropertyEntryValidationStatus) {
        nameValidationLabel.text = status.validationText
        nameValidationLabel.textColor = status.color
    }

    private func configureTextFields() {
        nameEntryTextField.delegate = self
        numberEntryTextField.delegate = self
        setNumberValidation(status: .empty(forFieldType: .mobileNumber))
        setNameValidation(status: .empty(forFieldType: .name))
        nameEntryTextField.addTarget(self, action: .textFieldValueChanged, for: .editingChanged)
    }

    private func validateTextFields() {
        let isValidNameEntered = isNameValid
        let isValidMobileNumbereEntered = isNumberValid
        additionButton.isEnabled = isValidNameEntered && isValidMobileNumbereEntered
    }

    // MARK: -
    // MARK: IBActions
    // MARK: -
    @IBAction func additionButtonTapped(_ sender: Any) {
        let person = Communicator(name: nameEntryTextField.text!, number: Int(numberEntryTextField.text!)!)
        dismiss(animated: true) { [weak self] in
            self?.additionDelegate?.didRequestToAddPerson(person)
        }
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITextFieldDelegate
extension PersonAdditionViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateTextFields()
    }

    @objc fileprivate func textFieldValueChanged() {
//        validateTextFields()
    }
}

fileprivate extension Selector {
    static let textFieldValueChanged = #selector(PersonAdditionViewController.textFieldValueChanged)
}
