//
//  CountdownViewController.swift
//  CountdownDemo
//
//  Created by Paul Solt on 4/30/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var countdownPicker: UIPickerView!
    
    // MARK: - Properties
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    private var duration: TimeInterval {
        // Convert from minutes + seconds to total seconds
        let minuteString = countdownPicker.selectedRow(inComponent: 0)
        let secondString = countdownPicker.selectedRow(inComponent: 2)
        
        let minutes = Int(minuteString)
        let seconds = Int(secondString)
        
        let totalSeconds = TimeInterval(minutes * 60 + seconds)
        return totalSeconds
    }
    
    lazy private var countdownPickerData: [[String]] = {
        // Create string arrays using numbers wrapped in string values: ["0", "1", ... "60"]
        let minutes: [String] = Array(0...60).map { String($0) }
        let seconds: [String] = Array(0...59).map { String($0) }
        
        // "min" and "sec" are the unit labels
        let data: [[String]] = [minutes, ["min"], seconds, ["sec"]]
        return data
    }()
    
    private var countdown = Countdown()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countdownPicker.dataSource = self
        countdownPicker.delegate = self
        
        // Set default duration to 1 minute 30 seconds
        countdownPicker.selectRow(1, inComponent: 0, animated: false)
        countdownPicker.selectRow(30, inComponent: 2, animated: false)
        
        countdown.delegate = self
        countdown.duration = duration
        
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize, weight: .medium)
        
        startButton.layer.cornerRadius = 4.0
        resetButton.layer.cornerRadius = 4.0
        
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        countdown.start()
        updateViews()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        countdown.reset()
        updateViews()
    }
    
    // MARK: - Private
    
    private func showAlert() {
        let alert = UIAlertController(title: "Timer Finished!", message: "Your countdown is over.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func updateViews() {
        startButton.isEnabled = true
        
        switch countdown.state {
        case .started:
            timeLabel.text = string(from: countdown.timeRemaining)
            startButton.isEnabled = false
        case .finished:
            timeLabel.text = string(from: 0)
        case .reset:
            timeLabel.text = string(from: countdown.duration)
        }
    }
    
    private func string(from duration: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: duration)
        return dateFormatter.string(from: date)
    }
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

extension CountdownViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return countdownPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countdownPickerData[component].count
    }
}

extension CountdownViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let timeValue = countdownPickerData[component][row]
        return String(timeValue)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countdown.duration = duration
        updateViews()
    }
}
