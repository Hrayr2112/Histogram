//
//  ViewController.swift
//  Histogram
//
//  Created by Hrayr Yeghiazaryan on 26.12.2019.
//  Copyright © 2019 Hrayr Yeghiazaryan. All rights reserved.
//

import UIKit

private enum HistogramState: Int {
    case normal
    case reversed
}

class ViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cellMargin: CGFloat = 250
    }
    
    // MARK: - UI components

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var reverseButton: UIButton!
    
    // MARK: - Variables
    
    var columnTapped: ((_ positiveValue: String, _ negativeValue: String, _ maxValue: Int, _ id: Int) -> Void)?
    
    private var cellSize: CGSize = .zero
    private var viewModels: [ColumnCellVM] = []
    private var multiViewModels: [ColumnCellVM] = []
    private var singleViewModels: [ColumnCellVM] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureCollectionView()
        configureNavigationBar()
    }
    
    // MARK: - Configurations
    
    private func configureCollectionView() {
        collectionView.register(cellType: ColumnViewCell.self)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Баланс сырья"
    }

    // MARK: - Private
    
    private func loadData() {
        var parser = Parser()
        parser.readInfo()
        let models = parser.columns.map { ColumnCellVM(data: $0) }
        if let maxValue = models.first?.value {
            for model in models {
                model.maxValue = maxValue
                if model.status {
                    singleViewModels.append(model)
                }
                
                if model.isChild {
                    multiViewModels.append(model)
                }
            }
        }
        viewModels = singleViewModels
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction
    private func reverseHistogram(_ sender: Any) {
        reverseButton.tag = reverseButton.tag == HistogramState.normal.rawValue ? HistogramState.reversed.rawValue : HistogramState.normal.rawValue
        let title = reverseButton.tag == HistogramState.normal.rawValue ? "Show reversed histogram" : "Show normal histogram"
        reverseButton.setTitle(title, for: .normal)
        collectionView.reloadData()
    }
    
    private func multiColumnOpen() {
        viewModels = viewModels.filter {$0.isMulti != true}
        viewModels.append(contentsOf: multiViewModels)
        collectionView.reloadData()
        collectionView.isScrollEnabled = true
        reverseButton.isHidden = true
    }
    
    private func multiColumnClose() {
        viewModels = singleViewModels
        collectionView.reloadData()
        collectionView.isScrollEnabled = false
        reverseButton.isHidden = false
        collectionView.setContentOffset(.zero, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ColumnViewCell
        cell.viewModel = viewModels[safe: indexPath.row]
        reverseButton.tag == HistogramState.normal.rawValue ? cell.normalizeCell() : cell.reverseCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModels[safe: indexPath.row] else { return }
        
        if viewModel.isChild {
            animateCellOpening(indexPath: indexPath)
        } else if viewModel.isMulti, reverseButton.tag == HistogramState.reversed.rawValue {
            multiColumnOpen()
        } else if reverseButton.isHidden {
            multiColumnClose()
        } else {
            animateCellOpening(indexPath: indexPath)
            columnTapped?(viewModel.positiveStringValue, viewModel.negativeStringValue, viewModel.maxValue, 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let unselectedCell = collectionView.cellForItem(at: indexPath) as? ColumnViewCell {
            unselectedCell.showSelectedUnderlineIf(needed: false)
            unselectedCell.showShadowIf(needed: false)
        }
    }
    
    // MARK: - Animations

    private func animateCellOpening(indexPath: IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? ColumnViewCell {
            collectionView.bringSubviewToFront(selectedCell)
            selectedCell.showSelectedUnderlineIf(needed: true)
            selectedCell.showShadowIf(needed: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch reverseButton.tag {
        case HistogramState.normal.rawValue:
            cellSize = CGSize(width: view.bounds.width / CGFloat(viewModels.count),
                              height: view.bounds.height - Constants.cellMargin)
        default:
            break
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
}
