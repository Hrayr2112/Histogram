//
//  ColumnCellVM.swift
//  Histogram
//
//  Created by Hrayr Yeghiazaryan on 26.12.2019.
//  Copyright © 2019 Hrayr Yeghiazaryan. All rights reserved.
//

import UIKit

class ColumnCellVM {
    let data: Column
    
    init(data: Column) {
        self.data = data
    }
    
    var value: Int {
        return data.value
    }
    
    var status: Bool {
        return data.status
    }
    
    var isMulti: Bool {
        return data.multi
    }
    
    var isChild: Bool {
        return data.child
    }
    
    var maxValue = 0
    
    var isMaxColumn: Bool {
        return maxValue == data.value
    }
    
    var positiveStringValue: String {
        return isMaxColumn ? "100%" : String(format: "%.2f", (CGFloat(data.value) / CGFloat(maxValue)) * 100)
    }
    
    var negativeStringValue: String {
        return isMaxColumn ? "0%" : String(format: "-%.2f", (100 - (CGFloat(data.value) / CGFloat(maxValue)) * 100))
    }
    
    func constraintHeight(superHeight: CGFloat) -> CGFloat {
        return isMaxColumn ? superHeight : (superHeight * (CGFloat(data.value) / CGFloat(maxValue)) * 100) / 100
    }
}
