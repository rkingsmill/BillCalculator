//
//  Tax.swift
//  BillCalc
//
//  Created by Rosalyn Kingsmill on 2019-05-04.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation

internal struct Tax {
    let amount: NSDecimalNumber
    let name: String
    var categories: [Category]?
    
    init(_ input: (label: String, amount: Double, isEnabled: Bool)) {
        self.amount = NSDecimalNumber(value: input.amount)
        self.name = input.label
    }
    
    init(name: String, amount: NSDecimalNumber, itemCategories: [Category]) {
        self.amount = amount
        self.name = name
        self.categories = itemCategories.filter({ name.contains($0.name) })
    }
}
