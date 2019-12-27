//
//  ColumnViewCell.swift
//  Histogram
//
//  Created by Hrayr Yeghiazaryan on 26.12.2019.
//  Copyright © 2019 Hrayr Yeghiazaryan. All rights reserved.
//

import Reusable
import UIKit

class ColumnViewCell: UICollectionViewCell, NibReusable {
    
    // MARK: - UI components
    
    @IBOutlet private var topValueLabel: UILabel!
    @IBOutlet private var bottomValueLabel: UILabel!
    @IBOutlet private var heightConstraint: NSLayoutConstraint!
    @IBOutlet private var topConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private var positiveView: UIView!
    @IBOutlet private var multiColumnBackgroundView: UIStackView!
    @IBOutlet private var selectedUnderlineView: UIView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topConstraint.isActive = false
    }
    
    // MARK: - Variables
    
    var viewModel: ColumnCellVM? {
        didSet {
            if let viewModel = viewModel {
                configure(with: viewModel)
            }
        }
    }
    
    // MARK: - Public
    
    func reverseCell() {
        guard let viewModel = viewModel else { return }
        
        topConstraint.isActive = true
        bottomConstraint.isActive = false
        
        positiveView.backgroundColor = UIColor.positiveReversedHistorgram
        backgroundColor = viewModel.isChild ? UIColor.negativeReversedHistorgram : UIColor.negativeMultiHistogram
        bottomValueLabel.text = topValueLabel.text?.replacingOccurrences(of: "-", with: "")
        topValueLabel.isHidden = true
        multiColumnBackgroundView.isHidden = viewModel.isMulti ? false : true
        showShadowIf(needed: false)
        showSelectedUnderlineIf(needed: false)
    }
    
    func normalizeCell() {
        guard let viewModel = viewModel else { return }

        topConstraint.isActive = false
        bottomConstraint.isActive = true
        
        positiveView.backgroundColor = UIColor.positiveHistorgram
        backgroundColor = UIColor.negativeHistogram
        topValueLabel.isHidden = false
        configure(with: viewModel)
        showShadowIf(needed: false)
        showSelectedUnderlineIf(needed: false)
    }
    
    func showSelectedUnderlineIf(needed: Bool) {
        selectedUnderlineView.isHidden = !needed
    }
    
    func showShadowIf(needed: Bool) {
        contentView.layer.cornerRadius = needed ? 2.0 : 0.0
        contentView.layer.borderWidth = needed ? 1.0 : 0.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: needed ? 2.0 : 0.0)//CGSizeMake(0, 2.0);
        layer.shadowRadius = needed ? 7.0 : 0.0
        layer.shadowOpacity = needed ? 0.7 : 0.0
        layer.masksToBounds = false
        layer.shadowPath = needed ? UIBezierPath(roundedRect: bounds,
                                                 cornerRadius: contentView.layer.cornerRadius).cgPath : nil
    }
    
    // MARK: - Configuration
    
    private func configure(with viewModel: ColumnCellVM) {
        topValueLabel.text = viewModel.negativeStringValue
        bottomValueLabel.text = viewModel.positiveStringValue
        heightConstraint.constant = viewModel.constraintHeight(superHeight: bounds.height)
        multiColumnBackgroundView.isHidden = true
    }
}
