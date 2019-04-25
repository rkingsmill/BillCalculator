//
//  Menu.swift
//  POS
//
//  Created by Tayson Nguyen on 2019-04-23.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation

struct Item {
    let id: String
    let name: String
    let category: String
    
    var quantity: Int
    var price: NSDecimalNumber
    var isTaxExempt: Bool
    
    var priceLabel: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: price)
    }
}

struct Tax {
    let id: String
    let rate: NSDecimalNumber
    //let conditions (on Item id and category)
}

struct Discount {
    let id: String
    let amountType: AmountType
    let shouldApplyTaxBeforeDiscount: Bool
    
    enum AmountType {
        case percentage(NSDecimalNumber)
        case dollar(NSDecimalNumber)
    }
}

struct Bill {
    let subtotal: NSDecimalNumber
    let discountTotal: NSDecimalNumber
    let taxTotal: NSDecimalNumber
    let total: NSDecimalNumber
    let roundedTotal: NSDecimalNumber
}

func calcBill(items: [Item], discounts: [Discount], taxes: [Tax], roundToNearestAmount: NSDecimalNumber?) -> Bill {
    return Bill(subtotal: 0, discountTotal: 0, taxTotal: 0, total: 0, roundedTotal: 0)
}

func category(_ category: String) -> (String, NSDecimalNumber) -> Item {
    return { name, price in
        return Item(id: name,
                    name: name,
                    category: category,
                    quantity: 1,
                    price: price,
                    isTaxExempt: false)
    }
}

let appetizers = category("Appetizers")
let mains = category("Mains")
let desserts = category("Desserts")
let drinks = category("Drinks")

let appetizersCategory = [
    appetizers("Nachos", 13.99),
    appetizers("Calamari", 11.99),
    appetizers("Caesar Salad", 10.99),
]

let mainsCategory = [
    mains("Burger", 9.99),
    mains("Hotdog", 3.99),
    mains("Pizza", 12.99),
]

let drinksCategory = [
    drinks("Water", 0),
    drinks("Pop", 2.00),
    drinks("Orange Juice", 3.00),
    drinks("Beer", 5.00),
]
