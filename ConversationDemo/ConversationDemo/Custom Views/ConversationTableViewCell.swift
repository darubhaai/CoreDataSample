//
//  ConversationTableViewCell.swift
//  ChatAppDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import UIKit

enum BubblePosion {
    case left
    case right
}

fileprivate let senderBubbleColor = UIColor(named: "Sender Bubble Color")!
fileprivate let receiverBubbleColor = UIColor(named: "Receiver Bubble Color")!

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var messageContentLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var bubbleViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectionOverlay: UIView!

    override func prepareForReuse() {
        super.prepareForReuse()
        bubbleViewCenterXConstraint?.constant = 0
        bubbleView.backgroundColor = .clear
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setShowSelectionOverlay(_ isShown: Bool) {
        selectionOverlay.isHidden = !isShown
    }

    func configureWith(message: MessageProtocol, position: BubblePosion, isSelected: Bool) {
        selectionStyle = .none
        messageContentLabel.text = message.textMessage
        timeStampLabel.text = message.timeStampString
        configureBubble(forPosition: position)
        selectionOverlay.isHidden = !isSelected
    }

    private func configureBubble(forPosition position: BubblePosion) {
        switch position {
        case .left:
            bubbleViewCenterXConstraint?.constant -= self.bubbleView.bounds.width/4
            bubbleView.backgroundColor = receiverBubbleColor

        case .right:
            bubbleViewCenterXConstraint?.constant += self.bubbleView.bounds.width/4
            bubbleView.backgroundColor = senderBubbleColor
        }
    }

}
