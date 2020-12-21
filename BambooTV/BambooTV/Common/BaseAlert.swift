//
//  BaseAlert.swift
//  BambooTV
//
//
//  Created by Yoan Tarrillo
//

import Foundation
import UIKit

class BaseAlert {
    static func defaultAlert(title: String, message: String, buttonText: String, buttonStyle: UIAlertAction.Style = UIAlertAction.Style.default, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: buttonText, style: buttonStyle, handler: handler)
        alert.addAction(okAction)
        
        return alert
    }
    
    static func destroyAlert(title: String, message: String, destroyText: String, cancelText: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let destroyAction: UIAlertAction = UIAlertAction(title: destroyText, style: .destructive, handler: handler)
        alert.addAction(destroyAction)
        
        return alert
    }
}
