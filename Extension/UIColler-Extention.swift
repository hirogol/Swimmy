//
//  UIColler-Extention.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2021/08/15.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
}
