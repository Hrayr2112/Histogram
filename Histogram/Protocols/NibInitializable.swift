//
//  NibInitializable.swift
//  Histogram
//
//  Created by Hrayr Yeghiazaryan on 26.12.2019.
//  Copyright © 2019 Hrayr Yeghiazaryan. All rights reserved.
//

import UIKit

protocol NibInitializable {}

extension NibInitializable where Self: UIView {
    func className() -> String {
        let fullName: String = description
        let separators = CharacterSet(charactersIn: ".:")
        let parts = fullName.components(separatedBy: separators)
        guard let name = parts[safe: 1] else {
            fatalError("Fail of getting class name")
        }
        return name
    }
}
