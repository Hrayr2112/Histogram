//
//  Parser.swift
//  Histogram
//
//  Created by Hrayr Yeghiazaryan on 26.12.2019.
//  Copyright © 2019 Hrayr Yeghiazaryan. All rights reserved.
//

import UIKit

struct Parser {
    
    var columns: [Column] = []
    private var jsonKeys = ["unit_group_cuts",
                            "unit_group_dropsinsections",
                            "unit_group_hot_counter",
                            "unit_icam",
                            "unit_after_icam",
                            "unit_mcal",
                            "unit_after_mcal",
                            "unit_multi",
                            "unit_after_multi",
                            "unit_m320"]
    
    mutating func readInfo() {
        if let path = Bundle.main.path(forResource: "info", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    for key in jsonKeys {
                        if let unit = jsonResult[key] as? [String: String?] {
                            self.columns.append(getColumn(from: unit))
                        }
                    }
                  }
              } catch {
                   print("Info loading failed")
              }
        }
    }
    
    private func getColumn(from unit: [String: String?]) -> Column {
        var columnValue = 0
        var columnStatus = false
        var columnMulti = false
        var columnChild = false
        
        if let value = unit["value"] as? String {
            columnValue = Int(value) ?? 0
        }
        
        if let status = unit["status"] as? String {
            columnStatus = status == "on" ? true : false
        }
        
        if let multi = unit["multi"] as? String {
            columnMulti = multi == "on" ? true : false
        }
        
        if let child = unit["child"] as? String {
            columnChild = child == "on" ? true : false
        }
        
        return Column(value: columnValue, status: columnStatus, multi: columnMulti, child: columnChild)
    }
}
