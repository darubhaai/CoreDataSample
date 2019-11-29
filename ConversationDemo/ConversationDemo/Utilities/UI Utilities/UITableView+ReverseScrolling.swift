//
//  UITableView+ReverseScrolling.swift
//  ConversationDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func configureForReverseScrolling() {
        self.transform = CGAffineTransform(scaleX: 1, y: -1)    
    }
}

extension UITableViewCell {
    func configureForReverseScrolling() {
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
}
