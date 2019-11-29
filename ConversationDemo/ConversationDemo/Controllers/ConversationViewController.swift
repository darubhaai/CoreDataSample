//
//  ConversationViewController.swift
//  ChatAppDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import UIKit

extension String {
    static let messageDeletionAlertTitle = "Are you sure you want to delete the selected messages?"
    static let messageDeletionAlertMessage = "Deleting messages will delete them from the conversation on both sides"
}

class ConversationViewController: UIViewController {

    @IBOutlet weak var topDescriptionLabel: UILabel!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageEntryTextView: MessageEntryTextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatControlStackBottomConstraint: NSLayoutConstraint!
    
    private var cancelButton: UIBarButtonItem?
    private var deleteButton: UIBarButtonItem?
    private var singleTapGestureRecogniser: UITapGestureRecognizer?
    private var longTapGestureRecogniser: UILongPressGestureRecognizer?

    private var isSelectionModeOn = false {
        didSet {
            messagesTableView.allowsMultipleSelection = self.isSelectionModeOn
            messagesTableView.allowsSelection = self.isSelectionModeOn
            longTapGestureRecogniser?.isEnabled = !self.isSelectionModeOn
            singleTapGestureRecogniser?.isEnabled = self.isSelectionModeOn
            setMessageDeleteButtonEnabled(self.isSelectionModeOn)
        }
    }

    var conversationObject: ConversationObject!
    var messageModel: ConversationModel!

    // MARK: -
    // MARK: View Life Cycle
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageModel()
        configureMessageEntryTextView()
        messagesTableView.configureForReverseScrolling()
        addGestureRecognizers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topDescriptionLabel.text = "\(conversationObject.fromPerson.firstName) to \(conversationObject.toPerson.firstName)"
        addObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }

    deinit {
        print("=== \(#file) Deallocated")
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

    private func addGestureRecognizers() {
        longTapGestureRecogniser = UILongPressGestureRecognizer(target: self, action: .longTappedOnMessage)
        messagesTableView.addGestureRecognizer(longTapGestureRecogniser!)

        singleTapGestureRecogniser = UITapGestureRecognizer(target: self, action: .singleTappedOnMessage)
        singleTapGestureRecogniser?.isEnabled = false
        messagesTableView.addGestureRecognizer(singleTapGestureRecogniser!)
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func showPlaceholderText() {
        messageEntryTextView.text = "Type a message"
    }

    @objc fileprivate func deleteButtonTapped() {
        let alertController = UIAlertController(title: .messageDeletionAlertTitle, message: .messageDeletionAlertMessage, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
            self?.deleteSelectedMessages()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc fileprivate func cancelButtonTapped() {
        messageEntryTextView.resignFirstResponder()
        messageEntryTextView.showsPlaceholderText = messageEntryTextView.text.isEmpty
        setKeyboardDismissButtonEnabled(false)
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.chatControlStackBottomConstraint.constant = 20
        }
    }

    /// Animating text field position with keyboard
    func setKeyboardDismissButtonEnabled(_ isEnabled: Bool) {
        if isEnabled {
            cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: .cancelButtonTapped)
            var buttons = [cancelButton!]
            if let _ = deleteButton {
                buttons.append(deleteButton!)
            }
            navigationItem.setRightBarButtonItems(buttons, animated: true)
        } else {
            navigationItem.rightBarButtonItems?.removeFirst()
            cancelButton = nil
        }
    }

    func setMessageDeleteButtonEnabled(_ isEnabled: Bool) {
        if isEnabled {
            deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: .deleteButtonTapped)
            deleteButton?.tintColor  = .red
            var buttons = [deleteButton!]
            if let _ = cancelButton {
                buttons.insert(cancelButton!, at: 0)
            }
            navigationItem.setRightBarButtonItems(buttons, animated: true)
        } else {
            navigationItem.rightBarButtonItems?.removeLast()
            deleteButton = nil
        }
    }

    private func showTextFieldAboveKeyboardWithInfoFrom(notification: Notification) {
        let userInfo = notification.userInfo!
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        let changeInHeight = keyboardFrame.height + 40
        UIView.animate(withDuration: animationDurarion, animations: { [weak self] in
            self?.chatControlStackBottomConstraint.constant += changeInHeight
        })
    }

    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        showTextFieldAboveKeyboardWithInfoFrom(notification: notification)
    }

    private func configureMessageModel() {
        messageModel = ConversationModel(conversation: conversationObject)
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

    private func deleteSelectedMessages() {
        isSelectionModeOn = false
        let selectedIndexPaths = messageModel.indexPathsForSelectedMessages
        if !selectedIndexPaths.isEmpty {
            messageModel.deleteSelectedMessages()
            messagesTableView.deleteRows(at: selectedIndexPaths, with: .fade)
        }
    }

    private func didSelectMessage(atIndexPath indexPath: IndexPath) {
        messageModel.toggleMessageSelection(atIndexPath: indexPath)
        let cell = messagesTableView.cellForRow(at: indexPath) as? ConversationTableViewCell
        let isSelected = messageModel.isMessageSelected(atIndexPath: indexPath)
        cell?.setShowSelectionOverlay(isSelected)
        isSelectionModeOn = messageModel.hasSelections
    }

    @objc func singleTapGestureDetected(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let touchPoint = sender.location(in: messagesTableView)
            if let indexPath = messagesTableView.indexPathForRow(at: touchPoint) {
                didSelectMessage(atIndexPath: indexPath)
            }
        }
    }

    @objc func longtapGestureDetected(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: messagesTableView)
            debugPrint("==== Long Tapped at\(touchPoint)...")
            if let indexPath = messagesTableView.indexPathForRow(at: touchPoint) {
                didSelectMessage(atIndexPath: indexPath)
            }
        }
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
        cell?.configureWith(message: message,
                            position: message.fromPerson.mobile == conversationObject.fromPerson.mobile ? .right : .left,
                            isSelected: messageModel.isMessageSelected(atIndexPath: indexPath))
        cell?.configureForReverseScrolling()
        return cell ?? defaultCell
    }
}

// MARK: -
// MARK: Textfield Delegate
// MARK: -
extension ConversationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setKeyboardDismissButtonEnabled(true)
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
    static let singleTappedOnMessage = #selector(ConversationViewController.singleTapGestureDetected)
    static let longTappedOnMessage = #selector(ConversationViewController.longtapGestureDetected)
    static let cancelButtonTapped = #selector(ConversationViewController.cancelButtonTapped)
    static let deleteButtonTapped = #selector(ConversationViewController.deleteButtonTapped)
}
