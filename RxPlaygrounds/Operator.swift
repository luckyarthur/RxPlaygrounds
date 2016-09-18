//
//  Operator.swift
//  RxPlaygrounds
//
//  Created by 杨弘宇 on 2016/9/17.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit
import RxSwift

enum SampleValue {
    
    case number(Int)
    case string(String)
    
    var displayString: String {
        switch self {
        case .number(let x):
            return "\(x)"
        case .string(let x):
            return x
        }
    }
    
    var color: UIColor {
        let hash: Int
        
        if case let .number(x) = self {
            hash = x
        } else if case let .string(x) = self {
            hash = x.hash
        } else {
            hash = 0
        }
        
        return [
            UIColor(red:0.26, green:0.64, blue:0.79, alpha:1.00),
            UIColor(red:0.99, green:0.42, blue:0.31, alpha:1.00),
            UIColor(red:0.52, green:0.84, blue:0.26, alpha:1.00),
            UIColor(red:1.00, green:0.79, blue:0.33, alpha:1.00)
        ][hash % 4]
    }
    
}


func +(lhs: SampleValue, rhs: SampleValue) -> SampleValue {
    return .string(lhs.displayString + rhs.displayString)
}


struct SampleInput {
    
    let value: SampleValue
    
    // Ranged from 0 to 100
    let timeOffset: Int8
    
}


struct Operator {

    typealias ApplyFunction = (Observable<SampleValue>, Observable<SampleValue>?) -> (Observable<SampleValue>)
    
    
    var input: [SampleInput]
    
    var parameterInput: [SampleInput]?
    
    let apply: ApplyFunction
    
    let summary: String
    
    let formula: String
    
    let detailDocument: String
    
}
