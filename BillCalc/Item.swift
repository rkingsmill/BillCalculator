//
//  Item.swift
//  BillCalc
//
//  Created by Rosalyn Kingsmill on 2019-05-04.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation

internal struct Item {
    let category: Category
    let isTaxExempt: Bool
    let price: NSDecimalNumber
    
    init(_ input: (name: String, category: String, price: NSDecimalNumber, isTaxExempt: Bool)) {
        self.price = input.price
        self.isTaxExempt = input.isTaxExempt
        self.category = Category(name: input.category)
    }
    
    private func shouldInclude(tax: Tax) -> Bool {
        guard !isTaxExempt, let taxCategories = tax.categories else { return false }
        guard taxCategories.count > 0 else { return true } //assume all if no cateogries are set on tax
        return (taxCategories.filter { $0.name == category.name }).count > 0 ? true : false
    }
    
    internal func price(after discounts: [Discount]) -> NSDecimalNumber {
        return discounts.reduce(self.price) { total, discount in
            switch discount.type {
            case .percent(let amount):
                return total.subtracting(total.multiplying(by: amount))
            case .amount(let amount):
                return (total.subtracting(amount).doubleValue > 0.0) ? total.subtracting(amount) : NSDecimalNumber(value: 0.0)
            }
        }
    }
    
    internal func price(after discounts: [Discount], andTaxes taxes: [Tax]) -> NSDecimalNumber {
        let taxesToInclude = taxes.filter { shouldInclude(tax: $0) }
        return taxesToInclude.reduce(price(after: discounts)) { total, tax in
            return total.subtracting(total.multiplying(by: tax.amount))
        }
    }
}

internal struct Category {
    let name: String
}
