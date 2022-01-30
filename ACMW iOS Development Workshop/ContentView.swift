//
//  ContentView.swift
//  ACMW iOS Development Workshop
//
//  Created by Maddie on 1/14/22.
//

import SwiftUI

// Our main view - everything that will happen in the UI!
struct ContentView: View {
    
    // 2D Array of the rows & buttons on each row of the calculator
        // Look at your calculator & see what types of buttons you see
        // Right now, we're going to use the minimum number of buttons needed & then you can add your own later!
    let buttons = [
        ["7", "8", "9", "÷"],
        ["4", "5", "6", "×"],
        ["1", "2", "3", "−"],
        [".", "0", "=", "+"]
    ]
    
    // What is an @State variable?
        // When you initialize a property that's marked @State, you're not actually creating your own variable, but rather prompting SwiftUI to create "something" in the background that stores what you set and monitors it from now on! Your @State var just acts as a delegate to access this wrapper.
        // Every time your @State variable is written, SwiftUI will know as it is monitoring it.
        // It will also know whether the @State variable was read from the View's body.
        // Using this information, it will be able to recompute any View having referenced a @State variable in its body after a change to this variable.
    
    // Make some state variables that will constantly be updated
    
    // variable of ____
    @State var noBeingEntered: String = ""
    
    // variable that will store the final value
    @State var finalValue:String = "acm-w calculator"
    
    // will store the mathematical equation being calculated (example: 2 + 2)
    @State var mathEquation: [String] = []
    
    // Basically, this is a view that will be shown on the screen!
    var body: some View {
        // What is a VStack?
            // A vertical stack of elements
            // You can stack them one on top of each other
        VStack {
            VStack {
                
                // This will show the final value of the calculator!
                Text(self.finalValue)
                    // These help us format the text so it's nice!
                        // Make the font bigger
                    .font(Font.custom("HelveticaNeue-Thin", size: 78))
                        // Make the alignment to the center
                    .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                        // Make the color of the text white so it pops!
                    .foregroundColor(Color.white)
                
                
                // Because this is in a VStack, it will be underneath the text above
                Text(flattenTheExpression(equation: mathEquation)) //Text("Math Equation")
                    // These help us format the text so it's nice!
                    .font(Font.custom("HelveticaNeue-Thin", size: 24))
                    .frame(alignment: Alignment.bottomTrailing)
                    .foregroundColor(Color.white)
                // Add a spacer before the bottom of the screen
                Spacer()
            }
            // This formats the VStack
                // I want to make the VStack at the top of the screen
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                // I want the color to be purple
            .background(Color.purple)
            
            
            // I'm going to make another VStack, and this is going to hold all of our buttons!
            VStack {
                // Put a spacer at the top!
                Spacer(minLength: 48)
                
                // VStack for rows of buttons
                VStack {
                    // We could add the buttons one at a time, but that would be time consuming! We can do a For each loop here, which will go through the rows in our 2D buttons array & add them
                    
                    ForEach(buttons, id: \.self) { row in // will go through each row
                        
                        // Now, an HStack is a HORIZONTAL Stack
                            // Will go through each button in the row horizontally
                        HStack(alignment: .top, spacing: 0) {
                            // We'll add a little space at the beginning of each row so the button isn't right up against the left edge
                            Spacer(minLength: 13)
                            
                            // loop through each column in the row
                            ForEach(row, id: \.self) { column in
                                // Add a button for each row!
                                Button(action: {
                                    
                                    // Figure out what to do when each button is pressed
                                    if column == "=" {
                                        self.mathEquation = []
                                        self.noBeingEntered = ""
                                        return
                                    } else if checkIfOperator(str: column)  {
                                        self.mathEquation.append(column)
                                        self.noBeingEntered = ""
                                    } else {
                                        self.noBeingEntered.append(column)
                                        if self.mathEquation.count == 0 {
                                            self.mathEquation.append(self.noBeingEntered)
                                        } else {
                                            if !checkIfOperator(str: self.mathEquation[self.mathEquation.count-1]) {
                                                self.mathEquation.remove(at: self.mathEquation.count-1)
                                            }

                                            self.mathEquation.append(self.noBeingEntered)
                                        }
                                    }

                                    // Set the final value to the value calculated by the math expression
                                    self.finalValue = processExpression(equation: self.mathEquation)
                                    
                                    // Reset the math equation so it's always in terms of two
                                    if self.mathEquation.count > 3 {
                                        self.mathEquation = [self.finalValue, self.mathEquation[self.mathEquation.count - 1]]
                                    }

                                }, label: {
                                    // This will label the buttons
                                    Text(column)
                                        // Figure out the font size for each button
                                    .font(.system(size: getFontSize(btnTxt: column)))
                                        // Size of each button
                                    .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                                }
                                )
                                // Color of the text
                                .foregroundColor(Color.white)
                                // Button background color
                                .background(getBackground(str: column))
                            }
                        }
                    }
                }
            }
            // Background color of the second v stack
            .background(Color.black)
            // Set the height of this v stack to be 1/2 the screen
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 414, maxHeight: .infinity, alignment: .topLeading)
        }
        // Background of this view is black (gets rid of white bar)
        .background(Color.black)
        // Ignore the safe area around the edges (makes things bigger)
        .edgesIgnoringSafeArea(.all)
    }
}

// logic for most of the formatting needs to be OUTSIDE the view

// Formatting for buttons!
// Background of numbers vs operators
func getBackground(str:String) -> Color {
    
    if checkIfOperator(str: str) {
        return Color.purple
    }
    return Color.black
}

// Font size of numbers vs operators
func getFontSize(btnTxt: String) -> CGFloat {
    
    if checkIfOperator(str: btnTxt) {
        return 42
    }
    return 24
    
}

// Check if the button pressed is an operator
func checkIfOperator(str:String) -> Bool {
    
    if str == "÷" || str == "×" || str == "−" || str == "+" || str == "=" {
        return true
    }
    
    return false
    
}

// Make the array of strings for the math equation into a single string
func flattenTheExpression(equation: [String]) -> String {
    var mathEquation = ""
    for expression in equation {
        mathEquation.append(expression)
    }
    
    return mathEquation
}

// Actual calculations!
func processExpression(equation:[String]) -> String {
    
    if equation.count < 3 {
        return "0.0"    // Less than 3 means that expression doesnt contain the 2nd number: Ex: ___ + ___
    }
    
    var a = Double(equation[0])         // Get the first number in the expression
    var c = Double("0.0")               // Initialize the second number
    let expressionSize = equation.count // Figure out how many expressions are in the equation
    
    // Go through each of the expressions in the equation
    for i in (1...expressionSize-2) {
        
        c = Double(equation[i+1])
        
        // Depending on the operator, do the correct operator
        switch equation[i] {
            case "+":
                a! += c!
            case "−":
                a! -= c!
            case "×":
                a! *= c!
            case "÷":
                a! /= c!
        default:
            print("skipping the rest")
        }
    }
    
    // Return a string of this specific format
    return String(format: "%.1f", a!) // has point precision! We're rounding to the nearest tenth!
}

// This is the function that lets us show the preview on the righthand side!
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // We're showing the preview of ContentView(). So, any code in content view will be previewed on the right
    }
}
