//
//  ContentView.swift
//  CalculatorSwift
//
//  Created by 赖宝光 on 2023/12/12.
//

import SwiftUI

struct ContentView: View {
    @State private var displayText = "0"
    
    let buttons: [[CalculatorButton]] = [
        [.clear, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Text(displayText)
                    .font(.system(size: 64))
                    .foregroundColor(.white)
            }.padding()
            
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { button in
                        CalculatorButtonView(button: button, displayText: $displayText)
                    }
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct CalculatorButtonView: View {
    let button: CalculatorButton
    @Binding var displayText: String
    
    var body: some View {
        Button(action: {
            self.button.tapAction(displayText: &self.displayText)
        }) {
            Text(button.title)
                .font(.system(size: 32))
                .frame(width: self.buttonWidth(button: button), height: (UIScreen.main.bounds.width - 5 * 12) / 4)
                .foregroundColor(.white)
                .background(button.backgroundColor)
                .cornerRadius(self.buttonWidth(button: button))
        }
    }
    
    private func buttonWidth(button: CalculatorButton) -> CGFloat {
        if button == .zero {
            return (UIScreen.main.bounds.width - 5 * 12) / 4 * 2
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
}




enum CalculatorButton: String {
    case zero = "0", one = "1", two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9"
    case clear, plusMinus, percent
    case plus = "+", minus = "-", multiply = "x", divide = "÷", equal
    case decimal
    
    
    
    
    var title: String {
        
        switch self {
            case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .plus, .minus, .multiply, .divide:
            return rawValue
            case .clear:
                return "AC"
            case .plusMinus:
                return "+/-"
            case .percent:
                return "%"
            case .equal:
                return "="
            case .decimal:
                return "."
        }
    }
    
    var backgroundColor: Color {
        switch self {
            case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
                return Color(.darkGray)
            case .clear, .plusMinus, .percent:
                return Color(.lightGray)
            default:
                return Color(.orange)
        }
    }
    
    func tapAction(displayText: inout String) {
        switch self {
            case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
                if(displayText == "0"){
                    displayText = self.rawValue
                }else{
                    displayText += self.rawValue
                }
            case .clear:
                displayText = "0"
            case .plusMinus:
                displayText = String(Double(displayText)! * -1)
            case .percent:
                displayText = String(Double(displayText)! / 100)
            case .plus, .minus, .multiply, .divide, .decimal:
                if let value = Double(displayText) {
                    displayText = String(value)
                }
                displayText += " \(self.rawValue) "
            case .equal:
                calculate(displayText : &displayText)
        }
    }
    
    private func calculate(displayText : inout String) {
        let expression = NSExpression(format: displayText)
        if let value = expression.expressionValue(with: nil, context: nil) as? Double {
            displayText = formatResult(value)
        } else {
            displayText = "Error"
        }
    }
    
    
    private func formatResult(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
