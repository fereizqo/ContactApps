//
//  Spinner.swift
//  ContactsApp
//
//  Created by Fereizqo Sulaiman on 09/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import UIKit

class Spinner {
    static let shared = Spinner()
    private init(){}

    var loader: UIView?

    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let spinner = UIActivityIndicatorView.init(style: .medium)
        spinner.startAnimating()
        spinner.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(spinner)
            onView.addSubview(spinnerView)
        }

        loader = spinnerView
    }

    func removeSpinner() {
        loader?.removeFromSuperview()
        loader = nil
    }
}
