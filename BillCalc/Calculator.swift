//
//  Calculator.swift
//  BillCalc
//
//  Created by Rosalyn Kingsmill on 2019-05-04.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation

internal struct Calculator {
    internal var taxes: [Tax]!
    
    internal var items: [Item] {
        didSet {
            categories = items.map { $0.category }
        }
    }
    
    internal var discounts: [Discount] {
        didSet {
            "Discounts set"
        }
    }
    
    private var categories: [Category]! {
        didSet {
            updateTaxes()
        }
    }
    
    internal init(items: [Item], taxes: [Tax], discounts: [Discount]) {
        self.items = items
        self.taxes = taxes
        self.discounts = discounts
    }
    
    internal mutating func updateTaxes(newTaxes: [Tax]? = nil) {
        taxes = (newTaxes ?? taxes).map { Tax(name: $0.name, amount: $0.amount, itemCategories: self.categories) }
    }
    
    internal var billSubtotal: NSDecimalNumber {
        return items.sum { $0.price }
    }
    
    internal var billTotal: NSDecimalNumber {
        return items.sum { $0.price(after: discounts, andTaxes: taxes) }
    }
    
    internal var totalDiscounts: NSDecimalNumber {
        return billSubtotal.subtracting(discountedSubtotal)
    }
    
    internal var totalTaxes: NSDecimalNumber {
        return billSubtotal.subtracting(billTotal).subtracting(totalDiscounts)
    }
    
    private var discountedSubtotal: NSDecimalNumber {
        return items.sum { $0.price(after: discounts) }
    }
}

fileprivate extension Collection {
    func sum<N: NSDecimalNumber>(by valueProvider: (Element) -> N) -> NSDecimalNumber {
        return reduce(0) { result, element in
            return result.adding(valueProvider(element))
        }
    }
}
