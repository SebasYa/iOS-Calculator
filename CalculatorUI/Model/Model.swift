//
//  Model.swift
//  CalculatorUI
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI

struct KeyboardButton: Hashable {
    let title: String
    let symbol: String?
    var textColor: Color
    var backgroundColor: Color
    var pressedBackgroundColor: Color
    let isDoubleWidth: Bool
    let type: ButtonType
}

enum ButtonType: Hashable {
    case number(Int)
    case operation(OperationType)
    case decimal
    case result
    case reset
    case NumNegPos
    case percent
}

enum OperationType: Hashable {
    case sum
    case minus
    case multiply
    case divide
}
