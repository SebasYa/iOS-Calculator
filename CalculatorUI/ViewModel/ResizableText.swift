//
//  ResizableText.swift
//  CalculatorUI
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI

//MARK: - View to display resizable text, adjusting its size based on the available width.
struct ResizableText: View {
    
    let text: String
    let maxWidth: CGFloat
    
    @State private var fontSize: CGFloat = 100
    @State private var availableWidth: CGFloat = 0
    @State private var lastKnownWidth: CGFloat = 0
    
    var body: some View {
        Text(text)
            .foregroundStyle(.white)
            .font(.system(size: fontSize, weight: .light))
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .frame(height: 100)
            .padding(.horizontal)
            .background(GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        
                        print("onAppear: geometry width: \(geometry.size.width)")
                        updateWidth(geometry.size.width)
                    }
                    .onChange(of: geometry.size.width) { newWidth, _ in
                        print("onChange: newWidth: \(newWidth)")
                            updateWidth(newWidth)
                    }
                
            })
    }
    
    // MARK: - Function to update width-related states and adjust font size
        private func updateWidth(_ width: CGFloat) {
            print("updateWidth called with width: \(width)")

            // Update available width and adjust font size only if width changes significantly
            guard abs(width - lastKnownWidth) > 1 else {
                print("Width change is insignificant. Skipping update.")

                return
            }
            
            availableWidth = width
            lastKnownWidth = width
        }

}

