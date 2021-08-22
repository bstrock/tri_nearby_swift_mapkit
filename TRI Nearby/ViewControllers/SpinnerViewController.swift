//
//  spinnerViewController.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/21/21.
//

import Foundation
import UIKit


class SpinnerViewController: UIViewController {
    // makes a spinner
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        // hashtag just spinner things
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
