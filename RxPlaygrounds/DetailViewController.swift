//
//  DetailViewController.swift
//  RxPlaygrounds
//
//  Created by 杨弘宇 on 2016/9/17.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var playBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var majorTimeline: TimelineView!
    @IBOutlet weak var parameterTimeline: TimelineView!
    @IBOutlet weak var outputTimeline: TimelineView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var parameterTimelineHeightConstraint: NSLayoutConstraint!
    
    var performer = Performer()
    
    var currentOperator: Operator? {
        get {
            return performer.currentOperator
        }
        
        set(value) {
            performer.currentOperator = value
            self.playBarButtonItem.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.playBarButtonItem.isEnabled = self.currentOperator != nil
        
        self.performer.delegate = self
        
        self.majorTimeline.delegate = self
        self.parameterTimeline.delegate = self
        
        self.summaryLabel.text = self.currentOperator?.summary
        self.formulaLabel.text = self.currentOperator?.formula
        self.detailLabel.text = self.currentOperator?.detailDocument
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.resetStage(resetAll: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: -
    
    @IBAction func playButtonDidTap(_ sender: AnyObject) {
        if self.performer.isPlaying {
            self.performer.stop()
        } else {
            self.resetStage(resetAll: false)
            self.performer.start()
        }
        
        (sender as! UIButton).isSelected = self.performer.isPlaying
    }

    func resetStage(resetAll: Bool) {
        self.outputTimeline.clearMarbles()
        
        if resetAll {
            self.parameterTimeline.isHidden = self.currentOperator?.parameterInput == nil
            self.parameterTimelineHeightConstraint.isActive = !self.parameterTimeline.isHidden
            
            self.majorTimeline.clearMarbles()
            self.parameterTimeline.clearMarbles()
            self.currentOperator?.input.forEach { input in
                let marble = MarbleView(frame: CGRect.zero)
                marble.position = input.timeOffset
                marble.textLabel.text = input.value.displayString
                marble.backgroundColor = input.value.color
                
                self.majorTimeline.addMarble(marble)
            }
            self.currentOperator?.parameterInput?.forEach { input in
                let marble = MarbleView(frame: CGRect.zero)
                marble.position = input.timeOffset
                marble.textLabel.text = input.value.displayString
                marble.backgroundColor = input.value.color
                
                self.parameterTimeline.addMarble(marble)
            }
        }
    }
    
}


extension DetailViewController: PerformerDelegate {
    
    func performer(_ performer: Performer, didEmitOutputValue value: (Int8, SampleValue)) {
        let marble = MarbleView(frame: CGRect.zero)
        marble.position = value.0
        marble.textLabel.text = value.1.displayString
        marble.backgroundColor = value.1.color
        
        self.outputTimeline.addMarble(marble)
    }
    
    func performer(didComplete performer: Performer) {
        (self.playBarButtonItem.customView as! UIButton).isSelected = false
    }
    
}


extension DetailViewController: TimelineViewDelegate {
    
    func timelineView(marblesDidChange view: TimelineView) {
        if view == self.majorTimeline {
            self.currentOperator?.input = view.marbles.enumerated().map { i, view -> SampleInput in
                return SampleInput(value: self.currentOperator!.input[i].value, timeOffset: view.position)
            }
        } else {
            self.currentOperator?.parameterInput = view.marbles.enumerated().map { i, view -> SampleInput in
                return SampleInput(value: self.currentOperator!.parameterInput![i].value, timeOffset: view.position)
            }
        }
    }
    
}
