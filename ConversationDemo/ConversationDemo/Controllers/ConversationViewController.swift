//
//  ConversationViewController.swift
//  ChatAppDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    @IBOutlet weak var topDescriptionLabel: UILabel!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageEntryTextView: MessageEntryTextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatControlStackBottomConstraint: NSLayoutConstraint!

    private var cancelButton: UIBarButtonItem!

    var conversationObject: ConversationObject!
    var messageModel: MessageModel!

    // MARK: -
    // MARK: View Life Cycle
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageModel()
        configureMessageEntryTextView()
        configureCancelButton()
        messagesTableView.configureForReverseScrolling()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topDescriptionLabel.text = "\(conversationObject.fromPerson.title) to \(conversationObject.toPerson.title)"
        addObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }

    // MARK: -
    // MARK: Instance Creation
    // MARK: -
    static func instantiate(with conversationObject: ConversationObject) -> ConversationViewController {
        let controller: ConversationViewController = Storyboards.Conversation.instantiate(identifier: "ConversationViewController")
        controller.conversationObject = conversationObject
        return controller
    }

    // MARK: -
    // MARK: Private Methods
    // MARK: -
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func showPlaceholderText() {
        messageEntryTextView.text = "Type a message"
    }

    @objc private func cancelButtonTapped() {
        messageEntryTextView.resignFirstResponder()
        cancelButton.isEnabled = false

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.chatControlStackBottomConstraint.constant = 20
        }
    }

    // MARK: -
    // MARK: Private Methods
    // MARK: -
    private func showTextFieldAboveKeyboardWithInfoFrom(notification: Notification) {
        let userInfo = notification.userInfo!
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        let changeInHeight = keyboardFrame.height + 20
        UIView.animate(withDuration: animationDurarion, animations: { [weak self] in
            self?.chatControlStackBottomConstraint.constant += changeInHeight
        })
    }

    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        showTextFieldAboveKeyboardWithInfoFrom(notification: notification)
    }

    private func configureCancelButton() {
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        cancelButton.isEnabled = false
        navigationItem.rightBarButtonItem = cancelButton
    }

    private func configureMessageModel() {
        messageModel = MessageModel(conversation: conversationObject)
    }

    private func configureMessageEntryTextView() {
        messageEntryTextView.delegate = self
    }

    private func clearTextView() {
        messageEntryTextView.text = ""
    }

    private func sendMessageToReceiver() {
        guard let content = messageEntryTextView.text else { return }
        let message = ConversationMessage(sender: conversationObject.fromPerson, receiver: conversationObject.toPerson, content: content)
        addMessageToTable(message)
    }

    private func sendMessage() {
        sendMessageToReceiver()
    }

    private func addMessageToTable(_ message: MessageProtocol) {
        messageModel.addMessage(message)
        let insertionIndexPath = IndexPath(row: 0, section: 0)
        messagesTableView.insertRows(at: [insertionIndexPath], with: .fade)
        clearTextView()
    }

    private func deleteMessage(atIndexPath indexPath: IndexPath) {
        messageModel.
    }

    // MARK: -
    // MARK: IBActions
    // MARK: -
    @IBAction func sendButtonTapped(_ sender: Any) {
        if let isTextFieldEmpty = messageEntryTextView.text?.isEmpty, !isTextFieldEmpty {
            sendMessage()
        }
    }

}

// MARK: -
// MARK: Tableview DataSource and Delegate
// MARK: -
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageModel.numberOfMessages
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationTableViewCell", for: indexPath) as? ConversationTableViewCell
        let message = messageModel.messageAtIndex(indexPath.row)
        cell?.configureWith(message: message, position: message.fromPerson.number == conversationObject.fromPerson.number ? .right : .left)
        cell?.configureForReverseScrolling()
        return cell ?? defaultCell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteMessage(atIndexPath: indexPath)
        default:
            break
        }
    }
}

// MARK: -
// MARK: Textfield Delegate
// MARK: -
extension ConversationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        cancelButton.isEnabled = true
        messageEntryTextView.showsPlaceholderText = false
    }

    func textViewDidChange(_ textView: UITextView) {
        let isMessageTyped = !textView.text.isEmpty
        sendButton.isHidden = !isMessageTyped
        messageEntryTextView.showsPlaceholderText = !isMessageTyped
    }
}

fileprivate extension Selector {
    static let keyboardWillShow = #selector(ConversationViewController.keyboardWillShow(_:))
}
