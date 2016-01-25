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
        //print(operation)
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
            //几种形式，从复杂到简单
            //case "×": performOperation(multiply)  //另写一个函数
            //case "×": performOperation( { (op1:Double, op2:Double)->Double in return op1*op2 } )  //直接把函数放到参数里，称为“闭包”
            //case "×": performOperation( { (op1, op2) in return op1*op2 } )  //由于类型推断功能，可以省略类型
            //case "×": performOperation( { (op1, op2) in op1*op2 } )  //因为只有一句，所以可以省略return
            //case "×": performOperation( { $0 * $1 } )  //甚至可以省略参数列表，swift默认用$0、$1、$2。。。替代
            //case "×": performOperation() { $0 * $1 }  //最后一个参数可以移到括号外面来
            case "×": performOperation {$0 * $1}  //只有一个参数的话，可以不要括号
            case "÷": performOperation {$1 / $0}
            case "+": performOperation {$0 + $1}
            case "−": performOperation {$1 - $0}
            case "√": performOperation2 { sqrt($0) }
            default: break
        }
    }
    
    func performOperation(operation: (Double,Double)->Double){
        if operateStack.count >= 2 {
            displayValue = operation(operateStack.removeLast() , operateStack.removeLast())
            enter()
        }
    }
    
//    func multiply(op1:Double, op2:Double)->Double{
//        return op1*op2
//    }
    
    func performOperation2(operation: Double -> Double){
        if operateStack.count >= 1 {
            displayValue = operation(operateStack.removeLast())
            enter()
        }
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

