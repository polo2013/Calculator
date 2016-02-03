//
//  ViewController.swift
//  myCalculator
//
//  Created by 周成波 on 16/1/13.
//  Copyright © 2016年 周成波. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //界面上的结果显示窗口
    @IBOutlet weak var display: UILabel!
    
    //用户是否正在录入
    var userIsInTheMiddleOfTypingANumber = false
    
    //实例化Model逻辑
    var brain = CalculatorBrain()

    //点击数字：如果正在录入，接着录，如果没有正在录入，则是录入第一个数字
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    //点击操作符：如果正在录入，停止录入并计算
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    //停止录入，将窗口里的内容压入，并开始计算，然后显示计算结果
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        
    }
    
    //窗口内容的字符串化
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

