//
//  Bill.swift
//  BillCalc
//
//  Created by Rosalyn Kingsmill on 2019-05-04.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation

public struct Bill {
    public let subtotal: NSDecimalNumber
    public let discounts: NSDecimalNumber
    public let taxes: NSDecimalNumber
    public let total: NSDecimalNumber
}
