//
//  Storyboard+Instance.swift
//  ChatAppDemo
//
//  Created by Darshan D T on 18/11/19.
//  Copyright © 2019 Darshan D T. All rights reserved.
//

import Foundation
import UIKit

/** An enum were all storyboards are to be placed */
enum Storyboards : String {
    case Home
    case Conversation
    
    /** Returns an UIStoryboard instance from the specified bundle (default is main) using the enum name */
    func instance(bundle:Bundle = Bundle.main) -> UIStoryboard {
        let storyboard = UIStoryboard(name: self.rawValue, bundle: bundle)
        return storyboard
    }
    
    /** Returns an instantiated view controller of the specified type using the identifier from the story board defined by the enum
     E.g. let storyboard = Storyboards.Main.instance
     let viewController:MyViewController = Storyboards.Main.instance()
     */
    func instantiate<T: UIViewController>(identifier: String = T.storyboardIdentifier) -> T  {
        guard let viewController = self.instance().instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        return viewController
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension StoryboardIdentifiable where Self: UINavigationController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable {}
