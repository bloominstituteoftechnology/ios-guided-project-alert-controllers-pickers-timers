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

        countdownPicker.countdownDelegate = self
        countdown.delegate = self
        countdown.duration = countdownPicker.duration
        
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize, weight: .medium)
        updateViews()
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
    
        // 1. Demo how to create a timer and call a method
        // let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: timerFinished(timer:))

        // 2. After connecting Countdown.swift switch to new logic
        countdown.start()
        updateViews()
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        countdown.reset()
        updateViews()
    }
    
    private func timerFinished(timer: Timer) {
        showAlert()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Timer Finished!", message: "Your countdown is over.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func updateViews() {
        switch countdown.state {
        case .started:
            timeLabel.text = string(from: countdown.timeRemaining)
        case .finished:
            timeLabel.text = string(from: 0)
        case .reset:
            timeLabel.text = string(from: countdown.duration)
        }
    }
    
    func string(from duration: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: duration)
        return dateFormatter.string(from: date)
    }
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SS"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        return formatter
    }()
    
    private var countdown = Countdown()
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var countdownPicker: CountdownPicker!
}

extension CountdownViewController: CountdownDelegate {
    func countdownDidFinish() {
        updateViews()
        showAlert()
    }
    
    func countdownDidUpdate(timeRemaining: TimeInterval) {
        updateViews()
    }
}

extension CountdownViewController: CountdownPickerDelegate {
    func countdownPickerDidSelect(duration: TimeInterval) {
        // Update countdown to use new picker duration value
        countdown.duration = duration
        updateViews()
    }
}

