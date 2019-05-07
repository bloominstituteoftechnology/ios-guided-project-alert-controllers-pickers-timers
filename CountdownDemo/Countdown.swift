//
//  Countdown.swift
//  CountdownDemo
//
//  Created by Paul Solt on 5/7/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import Foundation

protocol CountdownDelegate: AnyObject {
    func countdownDidUpdate(timeRemaining: TimeInterval)
    func countdownDidFinish()
}

class Countdown {
        
    init() {
        timer = nil
        startDate = nil
        stopDate = nil
        duration = 0
    }
    
    func start(duration: TimeInterval) {
        self.duration = duration
        
        clearTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
        startDate = Date()
        stopDate = Date(timeIntervalSinceNow: duration)
    }
    
    func stop() {
        // TODO:
    }
    
    func isActive() -> Bool {
        return startDate != nil
    }
    
    func reset() {
        startDate = nil
        stopDate = nil
        clearTimer()
        
        delegate?.countdownDidUpdate(timeRemaining: duration)
    }
    
    func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    //    @objc private func updateTimer(timer: Timer) {
    //        delegate?.countdownDidUpdate(timeRemaining: timeRemaining)
    //    }
    @objc private func updateTimer(timer: Timer) {
        if let stopDate = stopDate {
            
            let currentTime = Date()
            if currentTime > stopDate {
                clearTimer()
                reset()
                delegate?.countdownDidFinish()
            } else {
                delegate?.countdownDidUpdate(timeRemaining: timeRemaining)
            }
        }
    }
    
    weak var delegate: CountdownDelegate?
    
    var duration: TimeInterval
    
    var timeRemaining: TimeInterval {
        if let startDate = startDate {
            let currentTime = Date()
            let elapsedTime = currentTime.timeIntervalSince(startDate)
            let timeRemaining = duration - elapsedTime
            return timeRemaining
        } else {
            return duration
        }
    }
    
    private var timer: Timer?
    private var startDate: Date?
    private var stopDate: Date?
}
