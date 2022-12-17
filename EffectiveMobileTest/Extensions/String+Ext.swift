//
//  String+Ext.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 14.12.2022.
//

import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
