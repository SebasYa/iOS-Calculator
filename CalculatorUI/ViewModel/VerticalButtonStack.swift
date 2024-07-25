//
//  VerticalButtonStack.swift
//  CalculatorUI
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI

struct VerticalButtonStack: View {
    
    var viewModel: ViewModel
    // Press button binding to contentView
    @Binding private var activeButton: KeyboardButton?
    
    let data: [KeyboardButton]
    let columns: [GridItem]
    let width: CGFloat
    
    init(
        viewModel: ViewModel,
        data: [KeyboardButton],
        columns: [GridItem],
        width: CGFloat,
        activeButton: Binding<KeyboardButton?>) {
            
            self.viewModel = viewModel
            self.data = data
            self.columns = columns
            self.width = width
            self._activeButton = activeButton
        }
    
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 13) {
            ForEach(data, id: \.self) { model in
                Button(action: {
                    
                    viewModel.logic(key: model)
                    
                    // Press color change.
                    withAnimation(.easeInOut(duration: 0.2)){
                        if case .operation = model.type {
                            activeButton = model
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeInOut(duration: 0.2)){
                                    activeButton = nil
                                }
                            }
                        }
                    }
                }, label: {
                    
                    let isPressed = model == activeButton
                    let displayOperationTextColor = isPressed ? model.backgroundColor : model.textColor
                    let displayBackgroundColor = isPressed ? model.pressedBackgroundColor : model.backgroundColor
                    
                    Group {
                        if model.type == .reset{
                            if viewModel.errorResult {
                                Text("AC")
                                    .font(.system(size: 35, weight: .medium))
                                    .frame(width: width * 0.21,
                                           height: width * 0.21)
                                    .foregroundStyle(model.textColor)
                                    .background(displayBackgroundColor)
                            } else {
                                Text(viewModel.userStartedTyping ? "C" : "AC")
                                    .font(.system(size: 35, weight: .medium))
                                    .frame(width: width * 0.21,
                                           height: width * 0.21)
                                    .foregroundStyle(model.textColor)
                                    .background(displayBackgroundColor)
                            }
                            
                        }else if model.type == .NumNegPos && model.type == .percent{
                            Image(systemName: model.symbol!)
                                .foregroundStyle(model.textColor)
                                .background(displayBackgroundColor)
                            
                        }else if let symbolName = model.symbol{
                            Image(systemName: symbolName)
                                .font(.system(size: 31, weight: .medium))
                                .frame(width: width * 0.21,
                                       height: width * 0.21)
                                .foregroundStyle(displayOperationTextColor)
                                .background(displayBackgroundColor)
                            
                        }else if model.isDoubleWidth {
                            Rectangle()
                                .foregroundStyle(displayBackgroundColor)
                                .overlay(
                                    Text(model.title)
                                        .font(.system(size: 41, weight: .regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 25)
                                        .foregroundStyle(model.textColor)
                                )
                                .frame(width: width * 2 * 0.22, height: width * 0.21)
                            
                        } else {
                            Text(model.title)
                                .font(.system(size: 39, weight: .regular ))
                                .frame(width: width * 0.21,
                                       height: width * 0.21)
                                .foregroundStyle(model.textColor)
                                .background(displayBackgroundColor)
                        }
                    }
                })
                .background(model.pressedBackgroundColor)
                .cornerRadius(width * 0.18)
            }
        }
        .frame(width: width)
        .background(.black)
    }
}



#Preview {
    ContentView()
    
}
