//
//  UIViewController.swift
//  
//
//  Created by Zabih on 1/27/18.
//  Copyright © 2018 Zabih. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
            
            if let label = view as? UILabel {
                label.sizeToFit()
            }
        }
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
}






