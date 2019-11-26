//
//  MessageEntryTextView.swift
//  ConversationDemo
//
//  Created by Darshan D T on 20/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import UIKit

fileprivate let placeholderPadding = UIEdgeInsets(top: 8, left: 6, bottom: 0, right: 6)

@IBDesignable class MessageEntryTextView: UITextView {

    override func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        return nil
    }

    @IBInspectable var placeholderText: String = "Type here" {
        didSet {
            placeHolderTextLabel?.text = placeholderText
        }
    }
    @IBInspectable var placeholderTextColor: UIColor = .gray {
        didSet {
            placeHolderTextLabel?.textColor = placeholderTextColor
        }
    }

    private var placeHolderTextLabel: UILabel!

    var showsPlaceholderText: Bool {
        get {
            return placeHolderTextLabel.isHidden
        }
        set {
            placeHolderTextLabel.isHidden = !newValue
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.addPlaceHolderTextLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addPlaceHolderTextLabel()
    }

    private func addPlaceHolderTextLabel() {
        placeHolderTextLabel = UILabel()
        placeHolderTextLabel?.numberOfLines = 1
        placeHolderTextLabel?.text = placeholderText
        placeHolderTextLabel?.font = self.font
        placeHolderTextLabel?.textColor = placeholderTextColor
        addSubview(placeHolderTextLabel!)
        placeHolderTextLabel?.translatesAutoresizingMaskIntoConstraints = false
        placeHolderTextLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: placeholderPadding.left).isActive = true
        placeHolderTextLabel?.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: placeholderPadding.right).isActive = true
        placeHolderTextLabel?.topAnchor.constraint(equalTo: self.topAnchor, constant: placeholderPadding.top).isActive = true
        layoutIfNeeded()
    }

}
