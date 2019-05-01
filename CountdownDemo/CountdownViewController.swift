//
//  CountdownViewController.swift
//  CountdownDemo
//
//  Created by Paul Solt on 4/30/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countDown.delegate = self
    }
    
    func updateViews() {
        timeLabel.text = String(countDown.timeRemaining)
        // TODO: Format
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        let duration = pickerView.countDownDuration
        
        countDown.start(duration: duration)
    }
    @IBAction func pickerDidChange(_ sender: Any) {
        print("P")
    }
    
    var countDown = Countdown()
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var pickerView: UIDatePicker!

    //    @IBOutlet var alertController: UIAlertController!
    
}

extension CountdownViewController: CountdownDelegate {
    func countdownDidFinish() {
        updateViews()
        print("DONE!")
        // TODO: show allert contorller
    }
    
    func countdownDidUpdate(elapsedTime: TimeInterval) {
        updateViews()
    }
}

protocol CountdownDelegate: AnyObject {
    func countdownDidUpdate(elapsedTime: TimeInterval)
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
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
        startDate = Date()
    }
    
    func stop() {
        stopDate = Date()
    }
    
//    func startStop() {
//        if isActive() {
//            stop()
//        } else {
//            start()
//        }
//    }
    
    func isActive() -> Bool {
        return startDate != nil
    }
    
    // TODO: State? started, stopped, reset
    
    func reset() {
        startDate = nil
        stopDate = nil
        clearTimer()
    }
    
    func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimer(timer: Timer) {
        if let startDate = startDate {
            let currentTime = Date()
            let elapsedTime = currentTime.timeIntervalSince(startDate)
            
            delegate?.countdownDidUpdate(elapsedTime: elapsedTime)
        }
    }
    
    
    private var timer: Timer?
    private var startDate: Date?
    private var stopDate: Date?

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
    
    weak var delegate: CountdownDelegate?
}
