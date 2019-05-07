//
//  CountdownViewController.swift
//  CountdownDemo
//
//  Created by Paul Solt on 4/30/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit


protocol StopWatchPickerDelegate: AnyObject {
    func stopWatchPickerDidSelect(duration: TimeInterval)
}

//enum StopWatchPickerComponents: Int {
//    case minutes = 0
//    case minutesTitle = 1
//    case seconds = 2
//    case secondsTitle = 3
//}

//DateModel

class CountdownPicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return countdownPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countdownPickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let timeValue = countdownPickerData[component][row]
        return String(timeValue)
    }
//    secondsDigit = 0...59
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("row: \(row) component: \(component)")
        
        print("Duration: \(duration) sec")
        delegate?.stopWatchPickerDidSelect(duration: duration)
    }
    
    var duration: TimeInterval {
        let minuteString = pickerView.selectedRow(inComponent: 0)
        let secondString = pickerView.selectedRow(inComponent: 2)

        let minutes = Int(minuteString)
        let seconds = Int(secondString)
        
        let totalSeconds = TimeInterval(minutes * 60 + seconds)
        return totalSeconds
    }
    
    var pickerView: UIPickerView! {
        didSet {
            // Set default selections (based on specific time)
            pickerView.selectRow(1, inComponent: 0, animated: false)
            pickerView.selectRow(0, inComponent: 2, animated: false)
        }
    }
    
    var countdownPickerData = [
        ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
        ["min"],
        ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
        ["sec"]
    ]
    
    weak var delegate: StopWatchPickerDelegate?
}



class CountdownViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countDown.delegate = self
        updateViews()
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize, weight: .medium)
        
//        TimePickerView()
        timePicker.delegate = countdownPicker
        timePicker.dataSource = countdownPicker
        
        countdownPicker.pickerView = timePicker
        
        countdownPicker.delegate = self
    }
    
    var countdownPicker = CountdownPicker()
    
    func updateViews() {
        timeLabel.text = String(countDown.timeRemaining)
        
        // TODO: Format
        let date = Date(timeIntervalSinceReferenceDate: countDown.timeRemaining)
        timeLabel.text = dateFormatter.string(from:date)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Timer Finished!", message: "Your countdown is over.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // TODO: Cancel alert? reset button?
    
    // TODO: Finished animation
    
    @IBAction func startButtonPressed(_ sender: Any) {
        let duration = datePicker.countDownDuration
//        let duration = timePickerSource.duration
        
        countDown.start(duration: duration)
    }
    
    @IBAction func pickerDidChange(_ sender: Any) {
        if !countDown.isActive() {
            countDown.duration = datePicker.countDownDuration //timePickerSource.duration
            updateViews()
        }
    }
    
    var countDown = Countdown()
    
    @IBOutlet var timePicker: UIPickerView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var datePicker: UIDatePicker!
    
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
        showAlert()
    }
    
    func countdownDidUpdate(timeRemaining: TimeInterval) {
        updateViews()
    }
}

extension CountdownViewController: StopWatchPickerDelegate {
    func stopWatchPickerDidSelect(duration: TimeInterval) {
        // Update label
//        let duration = timePickerSource.duration
        updateViews()
    }
}



protocol CountdownDelegate: AnyObject {
    func countdownDidUpdate(timeRemaining: TimeInterval)
    func countdownDidFinish()
}

class Countdown {
    
    // TODO: State? started, stopped, reset

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
    
    func isActive() -> Bool {
        return startDate != nil
    }
    
    func reset() {
        startDate = nil
        stopDate = nil
        clearTimer()
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
