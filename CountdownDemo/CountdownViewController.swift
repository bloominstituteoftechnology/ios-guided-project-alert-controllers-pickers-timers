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
        updateViews()
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize, weight: .medium)
        
        countdownPicker.countdownDelegate = self
    }
    
    func updateViews() {
        timeLabel.text = String(countDown.timeRemaining)
        
        let date = Date(timeIntervalSinceReferenceDate: countDown.timeRemaining)
        timeLabel.text = dateFormatter.string(from:date)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Timer Finished!", message: "Your countdown is over.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        let duration = countdownPicker.duration
        countDown.start(duration: duration)
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        countDown.reset()
    }
    
    var countDown = Countdown()
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SS"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        return formatter
    }()
    
    @IBOutlet var timePicker: UIPickerView!
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
        updateViews()
    }
}

