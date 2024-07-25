//
//  ViewModel.swift
//  CalculatorUI
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI
import Observation

@Observable class ViewModel {
    
    var textField: String = "0"
    var userStartedTyping: Bool = false
    
    // Properties to handle the state and logic of the calculator.
    var textFieldSaved: String = "0"
    var currentOperationToExecute: OperationType?
    var shouldRunOperation: Bool = false
    var firstPercentResult: Double?
    var firstNumber: Double?
    var lastNumber: Double?
    var repeatLastOperation: Bool = false
    var errorResult: Bool = false
    
    private let maximumLimit: Double = 1e150
    private let minimumLimit: Double = -1e150
    
    
    
    //MARK: - Main Logic
    
    func logic(key: KeyboardButton) {
        print("logic called with key: \(key.title)")
        
        switch key.type {
            // Handle number input & textField.
        case .number(let value):
            handleNumberInput(value)
            
            // Handle Reset key logic
        case .reset:
            handleReset()
            
            //Calculate and display the Result of the current operation.
        case .result:
            print("Result pressed")
            calculateResult()
            
            // Handle the sign (+/-) of the current number
        case .NumNegPos:
            print("Toggle sign pressed")
            toggleSign()
            
            // Handle the selection of an operation (+, -, X, /, %)
        case .operation(let type):
            handleOperation(type)
            
            //Handle decimal("," for latam) input
        case .decimal:
            handleDecimal()
            
            //Handle the percentage calculation.
        case .percent:
            calculatePercent()
        }
    }
    
    // MARK: - Handlers
    
    private func handleNumberInput(_ value: Int) {
        let numericCount = textField.filter { $0.isNumber }.count
        if shouldRunOperation {
            textField = "\(value)"
            shouldRunOperation = false
        } else if textField == "0" || !userStartedTyping {
            textField = "\(value)"
        } else {
            if textField.contains(",") && numericCount < 9 {
                textField += "\(value)"
                
            } else {
                let newText = textField + "\(value)"
                let countWithoutComma = newText.filter { $0.isNumber }.count
                
                if countWithoutComma <= 9 {
                    textField = formatStringNumber(newText)
                }
            }
        }
        userStartedTyping = true
        repeatLastOperation = false
        print("Updated textField: \(textField), userStartedTyping: \(userStartedTyping), repeatLastOperation: \(repeatLastOperation)")
        
    }
    
    private func handleReset() {
        if userStartedTyping {
            textField = "0"
            userStartedTyping = false
        } else {
            resetCalculator()
        }
        
        if errorResult {
            resetCalculator()
            errorResult = false
        }
    }

    private func resetCalculator() {
        textField = "0"
        userStartedTyping = false
        textFieldSaved = "0"
        currentOperationToExecute = nil
        shouldRunOperation = false
        firstPercentResult = 0
        lastNumber = nil
        repeatLastOperation = false
    }
    
    private func toggleSign() {
        if let number = parseNumberFromString(textField) {
            let signNumber = -number
            textField = limitCharacters(in: formatNumberForDisplay(signNumber))
            print("Toggled sign: \(signNumber)")
        }
    }
    
    private func handleOperation(_ type: OperationType) {
        print("Operation pressed: \(type)")
        // If there's already an operation, calculate the result first.
        if currentOperationToExecute != nil && userStartedTyping {
            calculateResult()
        }
        currentOperationToExecute = type
        textFieldSaved = textField
        userStartedTyping = false
        print("Operation set to: \(type), textFieldSaved: \(textFieldSaved)")
        
        
        if userStartedTyping {
            if let number = parseNumberFromString(textField) {
                lastNumber = number
                textFieldSaved = formatNumberForDisplay(lastNumber!)
            }
        }
        
        if !userStartedTyping && repeatLastOperation {
            firstNumber = lastNumber
        } else {
            firstNumber = parseNumberFromString(textFieldSaved) ?? 0
        }
        currentOperationToExecute = type
        shouldRunOperation = true
        firstPercentResult = nil
        repeatLastOperation = false
    }
    
    private func handleDecimal() {
        let countWithoutComma = textField.filter { $0.isNumber }.count
        if !textField.contains(",") && countWithoutComma < 9 {
            textField += ","
        }
        userStartedTyping = true
    }
    
    private func calculatePercent() {
        if let number = parseNumberFromString(textField),
           let savedNumber = parseNumberFromString(textFieldSaved) {
            switch currentOperationToExecute {
            case .sum, .minus:
                firstPercentResult = savedNumber * (number * 0.01)
            case .multiply, .divide:
                firstPercentResult = number * 0.01
            default:
                firstPercentResult = number * 0.01
            }
            textField = formatNumberForDisplay(firstPercentResult!)
        }
        repeatLastOperation = false
    }
    
    private func calculateResult() {
        
        print("calculateResult called")
        
        if let operation = currentOperationToExecute{
            var result: Double = 0
            
            if let number = parseNumberFromString(textField) {
                let savedNumber = parseNumberFromString(textFieldSaved) ?? 0
                print("savedNumber: \(savedNumber), current number: \(number)")
                
                let numberToUse: Double
                if repeatLastOperation {
                    numberToUse = lastNumber ?? 0
                    print("Using lastNumber: \(numberToUse)")
                } else {
                    numberToUse = number
                    lastNumber = number
                    print("Setting lastNumber: \(lastNumber!)")
                }
                
                switch operation {
                    
                case .sum:
                    result = savedNumber + numberToUse
                    print("Performing sum: \(savedNumber) + \(numberToUse) = \(result)")
                    
                case .minus:
                    result = savedNumber - numberToUse
                    print("Performing sum: \(savedNumber) - \(numberToUse) = \(result)")
                    
                    
                case .multiply:
                    result = savedNumber * numberToUse
                    print("Performing sum: \(savedNumber) * \(numberToUse) = \(result)")
                    
                case .divide:
                    if numberToUse == 0 {
                        textField = "Error"
                        errorResult = true
                        print("Division by zero")
                        return
                    } else {
                        result = savedNumber / numberToUse
                        print("Performing division: \(savedNumber) / \(numberToUse) = \(result)")
                    }
                    
                }
                if result > maximumLimit || result < minimumLimit {
                    print("Error condition triggered")
                    textField = "Error"
                    errorResult = true
                    return
                } else if textField != "Error"{
                    textField = limitCharacters(in: formatNumberForDisplay(result))
                    textFieldSaved = formatNumberForDisplay(result)
                    print("Result: \(result), textField: \(textField)")
                }
                
            }
            
            firstPercentResult = nil
            userStartedTyping = false
            shouldRunOperation = false
            repeatLastOperation = true
            print("Calculation finished, repeatLastOperation: \(repeatLastOperation)")
        }
    }
    
    // MARK: - Format Numbers
    
    //Function to format a number for display accordig to the locale settings.
    /*private*/ func formatNumberForDisplay(_ number: Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "es_AR")
        formatter.maximumFractionDigits = 8
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        
        // Use scientific notation if the number is too big or too small
        if abs(number) >= 1e9 || abs(number) < 1e-8 {
            formatter.numberStyle = .scientific
            formatter.exponentSymbol = "e"
            formatter.maximumFractionDigits = 5
        }
        
        let formattedString = formatter.string(from: NSNumber(value: number)) ?? "\(number)"
        
        // Check if the formatted result is "0e0" and change it to "Error"
        if formattedString == "0e0" {
//            errorResult = true
            return "0"
        }
        
//        // Handle special case for zero
//        if number == 0 {
//            return "0"
//        }
        
        
        return formattedString
    }
    
    //Function to format a string number for display accordig to the locale settings.
    /*private*/ func formatStringNumber(_ text: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "es_AR")
        formatter.maximumFractionDigits = 8
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        
        let numberFromString = text.filter { $0.isNumber || $0 == formatter.decimalSeparator.first }
        
        if let number = formatter.number(from: numberFromString)?.doubleValue {
            let formattedString = formatter.string(from: NSNumber(value: number)) ?? "\(number)"
            return limitCharacters(in: formattedString)
        } else {
            return limitCharacters(in: text)
        }
    }
    
    //Function to parse a number from a formatted string.
    /*private*/ func parseNumberFromString(_ text: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "es_AR")
        formatter.maximumFractionDigits = 8
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        
        let numberFromString = text.replacingOccurrences(of: formatter.groupingSeparator, with: "")
            .replacingOccurrences(of: formatter.decimalSeparator, with: ".")
        
        return Double(numberFromString)
    }
    
    // MARK: - Limiting Numbers
    
    /*private*/ func limitCharacters(in text: String) -> String {
        let countWithoutComma = text.filter { $0.isNumber }.count
        if countWithoutComma <= 9 {
            return text
        } else {
            let numericCharacters = text.filter { $0.isNumber || $0 == "," || $0 == "." }
            let extraCharacters = numericCharacters.dropFirst(9)
            return text.replacingOccurrences(of: extraCharacters, with: "")
        }
    }
    
}
