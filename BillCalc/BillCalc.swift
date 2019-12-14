//
//  BillCalc.swift
//  BillCalc
//
//  Created by Rosalyn Kingsmill on 2019-05-04.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation

public struct BillCalc {
    public typealias ItemInput = (name: String, category: String, price: NSDecimalNumber, isTaxExempt: Bool)
    public typealias DiscountInput = (label: String, amount: Double, isEnabled: Bool)
    public typealias TaxInput = (label: String, amount: Double, isEnabled: Bool)
    
    private var calculator: Calculator
    
    public init(items: [ItemInput], discounts: [DiscountInput], taxes: [TaxInput]) {
        self.calculator = Calculator(items: items.map { Item($0) },
                                     taxes: taxes.filter { $0.isEnabled }.map { Tax($0) },
                                     discounts: discounts.filter { $0.isEnabled }.map { Discount($0) })
    }
    
    public mutating func update(items: [ItemInput]) -> Bill {
        calculator.items = items.map { Item($0) }
        return calculatedBill()
    }
    
    public mutating func update(discounts: [DiscountInput]) -> Bill {
        calculator.discounts = discounts.filter { $0.isEnabled }.map { Discount($0) }
        return calculatedBill()
    }
    
    public mutating func update(taxes: [TaxInput]) -> Bill {
        calculator.updateTaxes(newTaxes: taxes.filter { $0.isEnabled }.map { Tax($0) } )
        return calculatedBill()
    }
    
    private func calculatedBill() -> Bill {
        return Bill(subtotal: calculator.billSubtotal, discounts: calculator.totalDiscounts, taxes: calculator.totalTaxes, total: calculator.billTotal)
    }
}

//items to own categories and taxes?
