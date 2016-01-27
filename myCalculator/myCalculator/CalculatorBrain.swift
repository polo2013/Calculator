//
//  CalculatorBrain.swift
//  myCalculator
//
//  Created by Zhou Chengbo(周成波) on 16/1/27.
//  Copyright © 2016年 周成波. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op {
        case Operand(Double)
        case Operation1(String, Double ->Double)
        case Operation2(String, (Double, Double) ->Double)
        
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
    
    private var opStack = [Op]()
    
    private var knowOps = [String : Op]()
    
    init() {
        func learnOp(op: Op) {
            knowOps[op.description] = op
        }
        learnOp(Op.Operation2("×", *))
        learnOp(Op.Operation2("÷") { $1 / $0 })
        learnOp(Op.Operation2("+", +))
        learnOp(Op.Operation2("−") { $1 - $0 })
        learnOp(Op.Operation1("√", sqrt))
    }
    
    private func evaluate(ops:[Op]) -> (result: Double? , remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Operation1(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .Operation2(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
            
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol:String) -> Double? {
        if let operation = knowOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
}