//
//  RateViewControllerDelegate.swift
//  DollarRate
//
//  Created by Кирилл Тила on 25.06.2021.
//

import Foundation

protocol RateViewControllerDelegate: AnyObject {
    func updateValueAlert(oldValue: String, newValue: String)
}
