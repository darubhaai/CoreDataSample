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

extension String {
    static let duplicateNumberAlertTitle = "Mobile number exists!"
    static let duplicateNumberAlertMessage = "You already have a person with entered mobile number. Please add a different number"
}

class PersonAdditionViewController: UIViewController {

    // MARK: -
    // MARK: Outlets
    // MARK: -
    @IBOutlet weak var personNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var personNameValidationLabel: UILabel!
    @IBOutlet weak var mobileNumberValidationLabel: UILabel!

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
        personNameTextField?.resignFirstResponder()
        mobileNumberTextField?.resignFirstResponder()
    }

    // MARK: -
    // MARK: Private Methods
    // MARK: -
    private var isNameValid: Bool {
        var isValid = false
        guard let name = personNameTextField.text else {
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

    private var isMobileNumberValid: Bool {
        var isValid = false
        guard let number = mobileNumberTextField.text else {
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
        mobileNumberValidationLabel.text = status.validationText
        mobileNumberValidationLabel.textColor = status.color
    }

    private func setNameValidation(status: PersonPropertyEntryValidationStatus) {
        personNameValidationLabel.text = status.validationText
        personNameValidationLabel.textColor = status.color
    }

    private func configureTextFields() {
        personNameTextField.delegate = self
        mobileNumberTextField.delegate = self
        setNumberValidation(status: .empty(forFieldType: .mobileNumber))
        setNameValidation(status: .empty(forFieldType: .name))
        personNameTextField.addTarget(self, action: .textFieldValueChanged, for: .editingChanged)
        mobileNumberTextField.addTarget(self, action: .textFieldValueChanged, for: .editingChanged)
    }

    private func validateTextFields() {
        let isValidNameEntered = isNameValid
        let isValidMobileNumbereEntered = isMobileNumberValid
        addButton.isEnabled = isValidNameEntered && isValidMobileNumbereEntered
    }

    private func showDuplicateMobileNumberAlert() {
        let alertController = UIAlertController(title: .duplicateNumberAlertTitle, message: .duplicateNumberAlertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: -
    // MARK: IBActions
    // MARK: -
    @IBAction func additionButtonTapped(_ sender: Any) {
        let person = MessageParticipant(name: personNameTextField.text!, number: Int(mobileNumberTextField.text!)!)
        if PersistentStorageManager.shared.hasPerson(withNumber: person.mobile) {
            showDuplicateMobileNumberAlert()
        } else {
            dismiss(animated: true) { [weak self] in
                self?.additionDelegate?.didRequestToAddPerson(person)
            }
        }
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: -
// MARK: UITextFieldDelegate
// MARK: -
extension PersonAdditionViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateTextFields()
    }

    @objc fileprivate func textFieldValueChanged() {
        validateTextFields()
    }
}

fileprivate extension Selector {
    static let textFieldValueChanged = #selector(PersonAdditionViewController.textFieldValueChanged)
}
