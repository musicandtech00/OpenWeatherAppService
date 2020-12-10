//
//  Extension+UIView.swift
//  OpenWeatherAppService
//
//  Created by Curtis Wiseman on 12/6/20.
//

import UIKit

extension UIView {
    public func activateConstraints(_ constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

    @discardableResult
    public func constrain(within view: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right)
        ]

        activateConstraints(constraints)

        return constraints
    }
}
