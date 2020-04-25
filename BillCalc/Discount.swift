//
//  Discount.swift
//  BillCalc
//
//  Created by Rosalyn Kingsmill on 2019-05-04.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation

internal struct Discount {
    let type: Type<NSDecimalNumber>

    init(_ input: (label: String, amount: Double, isEnabled: Bool)) {
        self.type = input.label.contains("%") ? .percent(NSDecimalNumber(value: input.amount)) : .amount(NSDecimalNumber(value: input.amount))
    }
}

internal enum Type<NSDecimalNumber> {
    case amount(NSDecimalNumber)
    case percent(NSDecimalNumber)
}
