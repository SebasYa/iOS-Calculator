//
//  CalculatorViewModelTests.swift
//  CalculatorUITests
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import XCTest
@testable import CalculatorUI

final class CalculatorViewModelTests: XCTestCase {
    
    var viewModel: ViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.textField, "0")
        XCTAssertFalse(viewModel.userStartedTyping)
        XCTAssertNil(viewModel.currentOperationToExecute)
        XCTAssertFalse(viewModel.shouldRunOperation)
    }
    
    func testNumberInput() {
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        XCTAssertEqual(viewModel.textField, "5")
        XCTAssertTrue(viewModel.userStartedTyping)
        
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        XCTAssertEqual(viewModel.textField, "53")
    }
    
    func testReset() {
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        viewModel.logic(key: KeyboardButton(title: "C", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .reset))
        XCTAssertEqual(viewModel.textField, "0")
        XCTAssertFalse(viewModel.userStartedTyping)
        
        viewModel.logic(key: KeyboardButton(title: "AC", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .reset))
        XCTAssertEqual(viewModel.textField, "0")
        XCTAssertFalse(viewModel.userStartedTyping)
        XCTAssertNil(viewModel.currentOperationToExecute)
    }
    
    func testToggleSign() {
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        viewModel.logic(key: KeyboardButton(title: "+/-", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .NumNegPos))
        XCTAssertEqual(viewModel.textField, "-5")
        
        viewModel.logic(key: KeyboardButton(title: "+/-", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .NumNegPos))
        XCTAssertEqual(viewModel.textField, "5")
    }
    
    func testBasicOperations() {
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        viewModel.logic(key: KeyboardButton(title: "+", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.sum)))
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "8")
        
        viewModel.logic(key: KeyboardButton(title: "-", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.minus)))
        viewModel.logic(key: KeyboardButton(title: "2", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(2)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "6")
        
        viewModel.logic(key: KeyboardButton(title: "x", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.multiply)))
        viewModel.logic(key: KeyboardButton(title: "4", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(4)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "24")
        
        viewModel.logic(key: KeyboardButton(title: "/", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.divide)))
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "8")
    }
    
    func testDivisionByZero() {
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        viewModel.logic(key: KeyboardButton(title: "/", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.divide)))
        viewModel.logic(key: KeyboardButton(title: "0", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(0)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "Error")
    }
    
    func testChainingOperations() {
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        viewModel.logic(key: KeyboardButton(title: "+", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.sum)))
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        viewModel.logic(key: KeyboardButton(title: "x", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.multiply))) 
        // Should calculate 5 + 3 and then multiply (not like ios, but like any basic calculator)
        XCTAssertEqual(viewModel.textField, "8")
        // Should use the same operation type
        viewModel.logic(key: KeyboardButton(title: "2", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(2)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "16")
    }
    
    func testDecimalInput() {
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        viewModel.logic(key: KeyboardButton(title: ",", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .decimal))
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        XCTAssertEqual(viewModel.textField, "5,3")
        
        viewModel.logic(key: KeyboardButton(title: "2", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(2)))
        XCTAssertEqual(viewModel.textField, "5,32")
    }
    
    func testPercentageCalculation() {
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        viewModel.logic(key: KeyboardButton(title: "+", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.sum)))
        viewModel.logic(key: KeyboardButton(title: "20", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(20)))
        viewModel.logic(key: KeyboardButton(title: "%", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .percent))
        XCTAssertEqual(viewModel.textField, "1")
        
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "6")
    }
    
    func testMaxLimit() {
        viewModel.textField = "1e150"
        viewModel.logic(key: KeyboardButton(title: "x", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.multiply)))
        viewModel.logic(key: KeyboardButton(title: "10", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(10)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "Error")
    }
    
    func testMinLimit() {
        viewModel.textField = "-1e150"
        viewModel.logic(key: KeyboardButton(title: "x", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.multiply)))
        viewModel.logic(key: KeyboardButton(title: "10", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(10)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "Error")
    }
    
    func testBasicNegativeNumbers() {
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        viewModel.logic(key: KeyboardButton(title: "x", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.multiply)))
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        viewModel.logic(key: KeyboardButton(title: "+/-", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .NumNegPos))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "-15")
    }
    
    func testAdvancedNegativeNumbers() {
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        viewModel.logic(key: KeyboardButton(title: "+/-", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .NumNegPos))
        XCTAssertEqual(viewModel.textField, "-5")
        
        viewModel.logic(key: KeyboardButton(title: "+", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.sum)))
        viewModel.logic(key: KeyboardButton(title: "1", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(1)))
        viewModel.logic(key: KeyboardButton(title: "0", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(0)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "5")
        
        viewModel.logic(key: KeyboardButton(title: "+/-", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .NumNegPos))
        XCTAssertEqual(viewModel.textField, "-5")
        
        viewModel.logic(key: KeyboardButton(title: "x", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.multiply)))
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "-15")
        
        viewModel.logic(key: KeyboardButton(title: "x", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.multiply)))
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "-45")
    }
    
    func testFormatNumberForDisplay() {
        let number = 12345678.12345678
        let formattedNumber = viewModel.formatNumberForDisplay(number)
        XCTAssertEqual(formattedNumber, "12.345.678,12345678")
    }
    
    func testParseNumberFromString() {
        let text = "12.345.678,12345678"
        let number = viewModel.parseNumberFromString(text)
        XCTAssertEqual(number, 12345678.12345678)
    }
    
    func testLimitCharacters() {
        let text = "1234567890,123456789"
        let limitedText = viewModel.limitCharacters(in: text)
        XCTAssertEqual(limitedText, "123456789")
    }
    
    func testEzSum() throws {
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        viewModel.logic(key: KeyboardButton(title: "+", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.sum)))
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "8")
    }
    
    func testRepeatOperation() {
        viewModel.logic(key: KeyboardButton(title: "2", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(2)))
        viewModel.logic(key: KeyboardButton(title: "x", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.multiply)))
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "6")
        
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "18")
        
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "54")
    }
    
    func testChangeOperationSymbol() {
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        viewModel.logic(key: KeyboardButton(title: "+", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.sum)))
        viewModel.logic(key: KeyboardButton(title: "x", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.multiply)))
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "15")
    }

    func testOperationsAfterError() {
        viewModel.logic(key: KeyboardButton(title: "1", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(1)))
        viewModel.logic(key: KeyboardButton(title: "/", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.divide)))
        viewModel.logic(key: KeyboardButton(title: "0", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(0)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "Error")

        viewModel.logic(key: KeyboardButton(title: "AC", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .reset))
        viewModel.logic(key: KeyboardButton(title: "5", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(5)))
        viewModel.logic(key: KeyboardButton(title: "+", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.sum)))
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "8")
    }
    
    func testMultipleDecimalEntries() {
        viewModel.logic(key: KeyboardButton(title: "1", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(1)))
        viewModel.logic(key: KeyboardButton(title: ",", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .decimal))
        viewModel.logic(key: KeyboardButton(title: "1", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(1)))
        viewModel.logic(key: KeyboardButton(title: "+", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.sum)))
        viewModel.logic(key: KeyboardButton(title: "2", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(2)))
        viewModel.logic(key: KeyboardButton(title: ",", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .decimal))
        viewModel.logic(key: KeyboardButton(title: "2", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(2)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "3,3")
    }
    
    func testSequentialOperationsWithoutResult() {
        viewModel.logic(key: KeyboardButton(title: "1", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(1)))
        viewModel.logic(key: KeyboardButton(title: "+", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.sum)))
        viewModel.logic(key: KeyboardButton(title: "2", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(2)))
        viewModel.logic(key: KeyboardButton(title: "-", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.minus)))
        viewModel.logic(key: KeyboardButton(title: "3", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(3)))
        viewModel.logic(key: KeyboardButton(title: "x", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .operation(.multiply)))
        viewModel.logic(key: KeyboardButton(title: "4", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .number(4)))
        viewModel.logic(key: KeyboardButton(title: "=", symbol: nil, textColor: .black, backgroundColor: .white, pressedBackgroundColor: .gray, isDoubleWidth: false, type: .result))
        XCTAssertEqual(viewModel.textField, "0") // Assuming the calculator shows an intermediate or zero result
    }
}
