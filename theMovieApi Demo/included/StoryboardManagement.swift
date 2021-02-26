//
//  StoryboardManagement.swift
//  ReportsX
//
//  Created by Mustafa MEDENi on 3.10.2020.
//

import UIKit

// MARK: - Create
extension UIViewController {
    static func create(type: UIViewController.ViewType) -> UIViewController {
        let storyboard = UIStoryboard(name: type.storyboardType.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: type.storyboardIdentifier)
        return vc
    }
    
    func create(type: UIViewController.ViewType) -> UIViewController {
        return UIViewController.create(type: type)
    }
}

// MARK: - Storyboard Type
enum StoryboardType: String {
    case main = "Main"
}


protocol StoryboardDataSource {
    var storyboardType: StoryboardType { get }
    var storyboardIdentifier: String { get }
}


// MARK: - Enum
extension UIViewController {
    public enum ViewType: String {
        case home = "HomeViewController"
        case detail = "MovieDetailViewController"
        case search = "SearchViewController"

    }
}

// MARK: -
extension UIViewController.ViewType: StoryboardDataSource {
    var storyboardType: StoryboardType {
        switch self {

        case .home,.detail,.search:
            return StoryboardType.main

            
        }
    }
    
    var storyboardIdentifier: String {
        return self.rawValue
    }
}

