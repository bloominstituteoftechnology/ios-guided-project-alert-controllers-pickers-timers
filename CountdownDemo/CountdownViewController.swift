//
//  CountdownViewController.swift
//  CountdownDemo
//
//  Created by Paul Solt on 4/30/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit


//class TimePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
//    
//    
//}

class CountdownViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countDown.delegate = self
        updateViews()
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize, weight: .medium)
        
//        TimePickerView()
//        timePicker.delegate = timePicker
//        timePicker.dataSource = self
    }
    
//    var timePicker
    
    func updateViews() {
        timeLabel.text = String(countDown.timeRemaining)
        
        // TODO: Format
        let date = Date(timeIntervalSinceReferenceDate: countDown.timeRemaining)
        timeLabel.text = dateFormatter.string(from:date)
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        let duration = pickerView.countDownDuration
        
        countDown.start(duration: duration)
    }
    
    @IBAction func pickerDidChange(_ sender: Any) {
        print("P")
    }
    
    var countDown = Countdown()
    
    @IBOutlet var timePicker: UIPickerView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var pickerView: UIDatePicker!

    //    @IBOutlet var alertController: UIAlertController!
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SS"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        return formatter
    }()
    
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
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
        startDate = Date()
        stopDate = Date(timeIntervalSinceNow: duration)
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
        if let startDate = startDate, let stopDate = stopDate {
            let currentTime = Date()
            let elapsedTime = currentTime.timeIntervalSince(startDate)
            
            delegate?.countdownDidUpdate(elapsedTime: elapsedTime)
            
            if currentTime > stopDate {
                clearTimer()
                reset()
                delegate?.countdownDidFinish()
            } else {
                delegate?.countdownDidUpdate(elapsedTime: elapsedTime)
            }
            
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
