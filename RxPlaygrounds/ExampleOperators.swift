//
//  ExampleOperators.swift
//  RxPlaygrounds
//
//  Created by 杨弘宇 on 2016/9/17.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import Foundation
import RxSwift

class ExampleOperators {
    
    private(set) var operators: [(String, Operator)]!
    
    init() {
        self.operators = [(String, Operator)]()
        
        // MARK: delay
        self.operators.append(("delay", Operator(
            input: [
                SampleInput(value: .number(1), timeOffset: 10),
                SampleInput(value: .number(2), timeOffset: 20),
                SampleInput(value: .number(1), timeOffset: 30)],
            parameterInput: nil,
            apply: { (input, _) -> (Observable<SampleValue>) in
                return input.delay(0.1, scheduler: MainScheduler.instance)
            },
            summary: "shift the emissions from an Observable forward in time by a particular amount",
            formula: "delay",
            detailDocument: "The Delay operator modifies its source Observable by pausing for a particular increment of time (that you specify) before emitting each of the source Observable’s items. This has the effect of shifting the entire sequence of items emitted by the Observable forward in time by that specified increment.")))
        
        // MARK: map
        self.operators.append(("map", Operator(
            input: [
                SampleInput(value: .number(1), timeOffset: 20),
                SampleInput(value: .number(2), timeOffset: 40),
                SampleInput(value: .number(3), timeOffset: 70)],
            parameterInput: nil,
            apply: { (input, _) -> (Observable<SampleValue>) in
                return input.map({
                    if case .number(let x) = $0 {
                        return .number(x * 2 + 5)
                    } else {
                        return $0
                    }
                })
            },
            summary: "transform the items emitted by an Observable by applying a function to each item",
            formula: "map({ $0 * 2 + 5 })",
            detailDocument: "The Map operator applies a function of your choosing to each item emitted by the source Observable, and returns an Observable that emits the results of these function applications.")))
        
        // MARK: combineLatest
        self.operators.append(("combineLatest", Operator(
            input: [
                SampleInput(value: .number(1), timeOffset: 10),
                SampleInput(value: .number(2), timeOffset: 30),
                SampleInput(value: .number(3), timeOffset: 60),
                SampleInput(value: .number(4), timeOffset: 70),
                SampleInput(value: .number(5), timeOffset: 90)],
            parameterInput: [
                SampleInput(value: .string("A"), timeOffset: 20),
                SampleInput(value: .string("B"), timeOffset: 35),
                SampleInput(value: .string("C"), timeOffset: 45),
                SampleInput(value: .string("D"), timeOffset: 52)],
            apply: { (input, parameterInput) -> (Observable<SampleValue>) in
                return Observable<SampleValue>.combineLatest(input, parameterInput!) { (x: SampleValue, y: SampleValue) -> SampleValue in
                    return x + y
                }
            },
            summary: "when an item is emitted by either of two Observables, combine the latest item emitted by each Observable via a specified function and emit items based on the results of this function",
            formula: "combineLatest(x, y, { x + y })",
            detailDocument: "The CombineLatest operator behaves in a similar way to Zip, but while Zip emits items only when each of the zipped source Observables have emitted a previously unzipped item, CombineLatest emits an item whenever any of the source Observables emits an item (so long as each of the source Observables has emitted at least one item). When any of the source Observables emits an item, CombineLatest combines the most recently emitted items from each of the other source Observables, using a function you provide, and emits the return value from that function.")))
    }
    
}
