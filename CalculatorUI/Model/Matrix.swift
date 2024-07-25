//
//  Matrix.swift
//  CalculatorUI
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//
import Foundation
import SwiftUI

struct Matrix {
    
    static let firstSectionData: [KeyboardButton] = [
        
        .init(title: "AC", symbol: nil, textColor: .black, backgroundColor: Color("customLightGray"), pressedBackgroundColor: .white, isDoubleWidth: false, type: .reset),
        
        .init(title: "+/-", symbol: "plus.forwardslash.minus", textColor: .black, backgroundColor: Color("customLightGray"), pressedBackgroundColor: .white, isDoubleWidth: false, type: .NumNegPos),
        
        .init(title: "%", symbol: "percent", textColor: .black, backgroundColor: Color("customLightGray"), pressedBackgroundColor: .white, isDoubleWidth: false, type: .percent),
        
        .init(title: "÷", symbol: "divide", textColor: .white, backgroundColor: Color("customOrange"), pressedBackgroundColor: .white, isDoubleWidth: false, type: .operation(.divide)),
        
        .init(title: "7", symbol: nil, textColor: .white, backgroundColor: Color("customDarkGray"), pressedBackgroundColor: Color("lightGrayPressed"), isDoubleWidth: false, type: .number(7)),
        
        .init(title: "8", symbol: nil, textColor: .white, backgroundColor: Color("customDarkGray"), pressedBackgroundColor: Color("lightGrayPressed"), isDoubleWidth: false, type: .number(8)),
        
        .init(title: "9", symbol: nil, textColor: .white, backgroundColor: Color("customDarkGray"), pressedBackgroundColor: Color("lightGrayPressed"), isDoubleWidth: false, type: .number(9)),
        
        .init(title: "x", symbol: "multiply", textColor: .white, backgroundColor: Color("customOrange"), pressedBackgroundColor: .white, isDoubleWidth: false, type: .operation(.multiply)),
        
        .init(title: "4", symbol: nil, textColor: .white, backgroundColor: Color("customDarkGray"), pressedBackgroundColor: Color("lightGrayPressed"), isDoubleWidth: false, type: .number(4)),
        
        .init(title: "5", symbol: nil, textColor: .white, backgroundColor: Color("customDarkGray"), pressedBackgroundColor: Color("lightGrayPressed"), isDoubleWidth: false, type: .number(5)),
        
        .init(title: "6", symbol: nil, textColor: .white, backgroundColor: Color("customDarkGray"), pressedBackgroundColor: Color("lightGrayPressed"), isDoubleWidth: false, type: .number(6)),
        
        .init(title: "-", symbol: "minus", textColor: .white, backgroundColor: Color("customOrange"), pressedBackgroundColor: .white, isDoubleWidth: false, type: .operation(.minus)),
        
        .init(title: "1", symbol: nil, textColor: .white, backgroundColor: Color("customDarkGray"), pressedBackgroundColor: Color("lightGrayPressed"), isDoubleWidth: false, type: .number(1)),
        
        .init(title: "2", symbol: nil, textColor: .white, backgroundColor: Color("customDarkGray"), pressedBackgroundColor: Color("lightGrayPressed"), isDoubleWidth: false, type: .number(2)),
        
        .init(title: "3", symbol: nil, textColor: .white, backgroundColor: Color("customDarkGray"), pressedBackgroundColor: Color("lightGrayPressed"), isDoubleWidth: false, type: .number(3)),
        
        .init(title: "+", symbol: "plus", textColor: .white, backgroundColor: Color("customOrange"), pressedBackgroundColor: .white, isDoubleWidth: false, type: .operation(.sum))
    ]
    
    static let secondSectionData: [KeyboardButton] = [
        .init(title: "0", symbol: nil, textColor: .white, backgroundColor: Color("customDarkGray"), pressedBackgroundColor: Color("lightGrayPressed"), isDoubleWidth: true, type: .number(0)),
        
        .init(title: ",", symbol: nil, textColor: .white, backgroundColor: Color("customDarkGray"), pressedBackgroundColor: Color("lightGrayPressed"), isDoubleWidth: false, type: .decimal),
        
        .init(title: "=", symbol: "equal", textColor: .white, backgroundColor: Color("customOrange"), pressedBackgroundColor: .white, isDoubleWidth: false, type: .result)
    ]
    
    static let firstSectionGrid: (CGFloat) -> [GridItem] = { width in
        return Array(repeating: GridItem(.flexible(minimum: width), spacing: 0), count: 4)
    }
    
    static let secondSectionGrid: (CGFloat) -> [GridItem] = { width in
        return [
            GridItem(.flexible(minimum: width * 2), spacing: 0),
            GridItem(.flexible(minimum: width), spacing: 0),
            GridItem(.flexible(minimum: width), spacing: 0)
        ]
    }
    
}

