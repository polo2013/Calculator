//
//  ViewController.swift
//  myCalculator
//
//  Created by 周成波 on 16/1/13.
//  Copyright © 2016年 周成波. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×": performOperation(multiple)
//        case "÷":
//            if operateStack.count >= 2 {
//                displayValue = operateStack.removeLast() / operateStack.removeLast()
//                enter()
//            }
//        case "+":
//            if operateStack.count >= 2 {
//                displayValue = operateStack.removeLast() + operateStack.removeLast()
//                enter()
//            }
//        case "−":
//            if operateStack.count >= 2 {
//                displayValue = operateStack.removeLast() - operateStack.removeLast()
//                enter()
//            }
        default: break
        }
    }
    
    func performOperation(operation: (Double,Double)->Double){
        if operateStack.count >= 2 {
            displayValue = operateStack.removeLast() * operateStack.removeLast()
            enter()
        }
    }
    
    func multiple (op1:Double,op2:Double)->Double{
        return op1 * op2
    }
    
    var operateStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operateStack.append(displayValue)
        print("\(operateStack)")
        
    }
    
    var displayValue : Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }

}

