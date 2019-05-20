//
//  StyleSheet.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/11/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import UIKit

//All the extensions in this file are only for changing the style of the elements
extension UIColor {
    static let customBlue = UIColor(red: 255/255, green: 111/255, blue: 97/255, alpha: 1.0) // 1c7bd6
    static let customGray = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1.0) // 636363
    static let customLightGray = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0) // d9d9dd
    
}

extension UILabel {
    
    func styleHeader0() {
        self.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        self.textColor = .black
    }
    
    func styleHeader1() {
        self.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        self.textColor = .customGray
    }
    
    func styleHeader2() {
        self.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.textColor = .customGray
    }
    
    func styleHeader3() {
        self.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.textColor = .customGray
    }
    
    func styleBody1() {
        self.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.textColor = .customGray
    }
    
    func styleBody2() {
        self.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.textColor = .customGray
    }
    
}

//This extension is used to tint the status bar when using a navigation controller
extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
}
