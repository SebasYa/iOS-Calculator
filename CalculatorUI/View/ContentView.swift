//
//  ContentView.swift
//  CalculatorUI
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI

struct ContentView: View {
    
    var viewModel = ViewModel()
    @State private var activeButton: KeyboardButton? = nil
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            GeometryReader { proxy in
                VStack {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            // Display the calculator´s textField with resizabe text.
                            ResizableText(text: viewModel.textField,
                                          maxWidth: proxy.size.width)
                            .padding(.trailing, 15)
                        }
                    }
                    // Display the first section of calculator buttons.
                    VerticalButtonStack(
                        viewModel: viewModel,
                        data: Matrix.firstSectionData,
                        columns: Matrix.firstSectionGrid(proxy.size.width * 0.25),
                        width: proxy.size.width,
                        activeButton: $activeButton)
                    
                    Spacer(minLength: 12)
                    
                    // Display the second section of calculator buttons.
                    VerticalButtonStack(
                        viewModel: viewModel,
                        data: Matrix.secondSectionData,
                        columns: Matrix.secondSectionGrid(proxy.size.width * 0.25),
                        width: proxy.size.width,
                        activeButton: $activeButton)
                }
            }
            .background(.black)
        }
    }
}

#Preview {
    ContentView()
}
