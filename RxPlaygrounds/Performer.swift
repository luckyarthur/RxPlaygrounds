//
//  Performer.swift
//  RxPlaygrounds
//
//  Created by 杨弘宇 on 2016/9/17.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxBlocking

typealias Timestamped<T> = (Int8, T)


protocol PerformerDelegate: NSObjectProtocol {
    
    func performer(_ performer: Performer, didEmitOutputValue value: Timestamped<SampleValue>)
    
    func performer(didComplete performer: Performer)
    
    func performer(_ performer: Performer, didChangeProgress progress: Int8)
    
}


class Performer: NSObject {
    
    private var timer: Timer?
    private var playedFrame: Int8 = 0
    
    var currentOperator: Operator! {
        willSet {
            self.stop()
        }
    }
    
    private var majorObservable: PublishSubject<SampleValue>!
    private var parameterObservable: PublishSubject<SampleValue>!
    
    private var outputSubscription: Disposable?
    
    weak var delegate: PerformerDelegate?
    
    var isPlaying: Bool {
        get {
            return timer != nil && timer!.isValid
        }
    }
    
    override init() {
        super.init()
        
        self.majorObservable = PublishSubject<SampleValue>()
        self.parameterObservable = PublishSubject<SampleValue>()
    }
    
    func start() {
        self.stop()
        self.outputSubscription?.dispose()
        self.outputSubscription = nil
        
        self.playedFrame = 0
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerDidTick), userInfo: nil, repeats: true)
        
        let outputObservable = self.currentOperator.apply(self.majorObservable, self.parameterObservable)
        self.outputSubscription = outputObservable
            .map({ value -> Timestamped<SampleValue> in
                return (self.playedFrame, value)
            })
            .subscribe(onNext: { value in
                self.delegate?.performer(self, didEmitOutputValue: value)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    func stop() {
        if case .some = self.timer {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    @objc func timerDidTick(sender: AnyObject?) {
        let filterClosure = { (input: SampleInput) -> Bool in
            return input.timeOffset == self.playedFrame
        }
        
        if let input = self.currentOperator.input.filter(filterClosure).first {
            self.majorObservable.onNext(input.value)
        }
        
        if let parameterInput = self.currentOperator.parameterInput?.filter(filterClosure).first {
            self.parameterObservable.onNext(parameterInput.value)
        }
        
        self.playedFrame += 1
        self.delegate?.performer(self, didChangeProgress: self.playedFrame)
        
        if self.playedFrame >= 100 {
            self.delegate?.performer(didComplete: self)
            self.stop()
        }
    }
    
}
