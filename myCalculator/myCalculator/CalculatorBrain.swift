//
//  CalculatorBrain.swift
//  myCalculator
//
//  Created by Zhou Chengbo(周成波) on 16/1/27.
//  Copyright © 2016年 周成波. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    //定义一个枚举类型（1个操作数，1个一元操作，1个二元操作，1个描述字符串）
    private enum Op {
        //操作数
        case Operand(Double)
        //一元操作（操作符、计算函数）
        case Operation1(String, Double ->Double)
        //二元操作（操作符、计算函数）
        case Operation2(String, (Double, Double) ->Double)
        //这个枚举类型的描述变量
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Operation1(let symbol, _):
                    return symbol
                case .Operation2(let symbol, _):
                    return symbol
                    
                }
            }
        }
    }
    
    //操作栈，枚举类型数组
    private var opStack = [Op]()
    
    //已知操作与枚举类型数组的对应关系，这里是一个字典数组
    private var knowOps = [String : Op]()
    
    //初始化
    init() {
        //定义一个函数，输入枚举类型的值，无返回值，作用是给knowOps这个字典数组（数组中的每一个字典，key是字符串，value是枚举类型）赋值
        func learnOp(op: Op) {
            knowOps[op.description] = op
        }
        //创建实例的时候，就给该实例的knowOps这个字典数组（数组中的每一个字典，key是字符串，value是枚举类型）赋值
        learnOp(Op.Operation2("×", *))
        learnOp(Op.Operation2("÷") { $1 / $0 })
        learnOp(Op.Operation2("+", +))
        learnOp(Op.Operation2("−") { $1 - $0 })
        learnOp(Op.Operation1("√", sqrt))
    }
    
    //表示自身，get返回堆栈的描述，set把堆栈重置为newValue
    var program: AnyObject {
        get {
            return opStack.map { $0.description }
        }
        
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knowOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                
            }
        }
    }
    
    //递归运算，传入枚举类型数组（操作数和操作符），返回操作结果、剩余的栈
    private func evaluate(ops:[Op]) -> (result: Double? , remainingOps: [Op]) {
        //非空
        if !ops.isEmpty {
            var remainingOps = ops
            //弹出最后一个元素
            let op = remainingOps.removeLast()
            switch op {
            //如果弹出的是数字，则返回操作数、堆栈
            case .Operand(let operand):
                return (operand, remainingOps)
            //如果是一元操作符
            case .Operation1(_, let operation):
                //递归，剩余堆栈再取最后一个元素
                let operandEvaluation = evaluate(remainingOps)
                //直到取到操作数，才进行运算
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            //如果是二元操作符
            case .Operation2(_, let operation):
                //递归，剩余堆栈再取最后一个元素
                let op1Evaluation = evaluate(remainingOps)
                //取到最后一个操作数
                if let operand1 = op1Evaluation.result {
                    //递归，剩余堆栈再取最后一个元素
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    //取到倒数第二个操作数
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    //总运算
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }
    
    //压入操作数到堆栈，并计算，返回结果
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    //压入运算符到堆栈，并计算，返回结果
    func performOperation(symbol:String) -> Double? {
        if let operation = knowOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
}