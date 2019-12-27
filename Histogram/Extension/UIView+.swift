//
//  UIView+.swift
//  Histogram
//
//  Created by Hrayr Yeghiazaryan on 26.12.2019.
//  Copyright © 2019 Hrayr Yeghiazaryan. All rights reserved.
//

import UIKit

extension UIView: NibInitializable {
    func loadNib() {
        Bundle.main.loadNibNamed(className(), owner: self, options: nil)
    }

    class func fromNib<T: UIView>() -> T {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? T else {
            fatalError("Fail init view from .xib")
        }
        return view
    }
}
