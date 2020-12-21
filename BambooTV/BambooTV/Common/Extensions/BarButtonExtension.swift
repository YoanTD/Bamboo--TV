//
//  BarButtonExtension.swift
//  BambooTV
//
//  Created by Yoan Tarrillo
import Foundation
import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
    
    func show() {
        self.isEnabled = true
        self.tintColor = nil
    }
}
