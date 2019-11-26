//
//  String+RegEx.swift
//  ConversationDemo
//
//  Created by Darshan D T on 24/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import Foundation

public extension String {
    func matchesPattern(_ pattern: String) -> Bool {
        var isMatched = false
        let wholeRange = range(of: self)
        if let matchedRange = self.range(of: pattern, options: .regularExpression, range: nil), matchedRange == wholeRange {
            isMatched = true
        }
        return isMatched
    }
}
