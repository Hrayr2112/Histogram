//
//  ColumnView.swift
//  Histogram
//
//  Created by Hrayr Yeghiazaryan on 26.12.2019.
//  Copyright © 2019 Hrayr Yeghiazaryan. All rights reserved.
//

import UIKit

class ColumnView: UIView {

    // MARK: - UI
    
    @IBOutlet private var heightConstraint: NSLayoutConstraint!
    @IBOutlet private var contentView: UIView!
    
    // MARK: - Initializations

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }

    // MARK: - View loading

    private func loadView() {
        loadNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    // MARK: - Public
    
    func updateHeight(constant: CGFloat) {
        heightConstraint.constant = constant
        layoutIfNeeded()
    }
    
}
