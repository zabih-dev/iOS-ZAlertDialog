//
//  UIView+Anchors.swift
//  
//
//  Created by zabih atashbarg on 3/14/18.
//  Copyright © 2018 Zabih. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
extension UIView {
    public func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if let label = view as? UILabel , label.numberOfLines == 0 {
                label.sizeToFit()
            }
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
    public func fillSuperview(margin:CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: margin).isActive = true
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -margin).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor, constant: margin).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -margin).isActive = true
        }
    }
    
    
    
    
    
    
    public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    
    public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterSuperview(width:CGFloat = -1, height:CGFloat = -1) {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
        
        if width != -1 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != -1 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
   
    
    
    
    
}




