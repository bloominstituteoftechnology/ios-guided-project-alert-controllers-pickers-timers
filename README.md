# Alert Controllers, Pickers, and Timers Guided Project


## Starter Project

Have students fork and clone the [starter guided project](https://github.com/LambdaSchool/ios-guided-project-starter-alert-controllers-pickers-timers).


# Summary

<img src="images/Countdown.png" width="400">

1. Demo the countdown app

2. Design the UI using stack view with spacing (8 spacing)

		[UIPicker]
		[UILabel: 00:00:00.00]
		[UIButton: START]
		[UIButton: RESET]

3. Pin Stack View to bottom (40), leading (16), trailing (16) 
4. Create a "CountdownViewController.swfit" subclass of `UIViewController`
5. Create actions for "START" and "RESET" buttons
	1. `startButtonPressed()`
	2. `resetButtonPressed()`
6. Create a method `showAlert()` to show a Timer finished UIAlertController alert.
7. Show the alert when `startButtonPressed()`
8. Show `Timer` documentation
9. Create a method to show the alert after 2 seconds using a `Timer` object
10. Users want visual feedback when a timer is running, use the included "Countdown.swift" to keep track of time remaining.
	1. Discuss how the class works from a high level
	2. Set a default duration of 5 seconds to test logic
	3. Integrate logic into start/reset actions
	4. Conform to the delegate protocol using an extension to get updates
	5. Display unformatted time remaining
11. Update the user interface
	1. Share code to format TimeInterval using DateFormatter + helper method
12. Create a "CountdownPicker.swift" subclass of `UIPickerView` to enable user selection of time.
	1. Set class on UIPickerView in "Main.storyboard"
	2. Conform to delegate protocol in 
13. Connect the app logic and user interface together and cleanup any logic

## Lesson Plan


1. Demo the countdown app

2. Design the UI using stack view with spacing (8 spacing and fill)

		[UIPickerView]
		[UILabel: 00:00:00.00]
		[UIButton: START]
		[UIButton: RESET]

3. Pin Stack View to bottom (40), leading (16), trailing (16) 
4. Adjust the fonts

	1. Time Label Font: System Regular 70
	2. Time Label: Auto-shrink: Minimum Font Scale: 0.5 (to resize on smaller devices)
	3. START / RESET button font: System Medium 25

5. Make the buttons have constraints to be 60 points tall (Height constraint = 60, equal button heights)

4. The "CountdownViewController.swift" subclass of `UIViewController` is connected in the starter project storyboard

5. Create outlets for the UI components in "CountdownViewController.swift"

	    @IBOutlet var timeLabel: UILabel!
	    @IBOutlet var startButton: UIButton!
	    @IBOutlet var countdownPicker: CountdownPicker!

5. Create actions for "START" and "RESET" buttons

		@IBAction func startButtonPressed(_ sender: Any) {
		
		}
		
		@IBAction func resetButtonPressed(_ sender: Any) {
		
		}

6. Create a method `showAlert()` to show a Timer finished UIAlertController alert in the "CountdownViewController.swift"


		private func showAlert() {
		    let alert = UIAlertController(title: "Timer Finished!", message: "Your countdown is over.", preferredStyle: .alert)
		    
		    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		    self.present(alert, animated: true)
		}


7. Show the alert when `startButtonPressed()`


		@IBAction func startButtonPressed(_ sender: Any) {
		    showAlert()
		}
		
		private func showAlert() {
		    let alert = UIAlertController(title: "Timer Finished!", message: "Your countdown is over.", preferredStyle: .alert)
		    
		    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		    self.present(alert, animated: true)
		}

8. Show `Timer` documentation and explain how we can call a method after 2 seconds using the `Timer.scheduledTimer(withTimeInterval: repeats: block:)` method

9. Create a method `timerFinished(timer:)` to show the alert after 2 seconds using a `Timer` object

	    @IBAction func startButtonPressed(_ sender: Any) {
	
	        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: timerFinished(timer:))
	
	    }
	    
	    private func timerFinished(timer: Timer) {
	        showAlert()
	    }


9. Discuss: Users want visual feedback when a timer is running, use the included "Countdown.swift" to keep track of time remaining (business logic).
	1. Discuss how the "Countdown.swift" works from a high level
	2. It manages a timer, and clears the timer when finished
	3. It does date math to figure out how much time is remaining
	4. It can be reset

10. Create a `Countdown` object into the "CountdownViewController.swift" 

		    @IBOutlet var countdownPicker: UIPickerView!
		    @IBOutlet var timeLabel: UILabel!
		    @IBOutlet var startButton: UIButton!
		    
		    
		    private let countdown = Countdown()
		}


11. Set the duration in `viewDidLoad()`

	    override func viewDidLoad() {
	        super.viewDidLoad()
	
	        countdown.duration = 5
	    }


12. Start the countdown in `startButtonPressed()` (remove/comment previous logic)


	    @IBAction func startButtonPressed(_ sender: Any) {
	
	        // let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: timerFinished(timer:))
	
	        countdown.start()
	    }


13. CHECKIN: Raise hand if you can build and run the app

14. QUESTION: Does anything happen when you press start?

ANSWER: No, because it doesn't print anything, and we haven't connected delegate.

1. Let's add print statements so we can see when timer is done on the console.
2. Open "Countdown.swift" and add 2 print statements:
	1. Print the time remaining if the timer is still active
	2. Print the timer "Finished" when it passes the duration


		    private func updateTimer(timer: Timer) {
		        
		        if let stopDate = stopDate {
		            let currentTime = Date()
		            if currentTime <= stopDate {
		                // Timer is active, keep counting down
		                delegate?.countdownDidUpdate(timeRemaining: timeRemaining)
		                
		                print("Time remaining: \(timeRemaining)")
		                
		            } else {
		                // Timer is finished, reset and stop counting down
		                state = .finished
		                cancelTimer()
		                self.stopDate = nil
		                delegate?.countdownDidFinish()
		                
		                print("Finished!")
		            }
		        }
		    }


3. Conform to the `CountdownDelegate` protocol to update the UI in the "CountdownViewController.swift" (Show the alert in didFinish)

	1. Set the delegate

		    override func viewDidLoad() {
		        super.viewDidLoad()
		
		        countdown.duration = 5
		        countdown.delegate = self
		    }

	2. Conform to the protocol

			extension CountdownViewController: CountdownDelegate {
			    func countdownDidFinish() {
			        showAlert()
			    }
			    
			    func countdownDidUpdate(timeRemaining: TimeInterval) {
	
			    }
			}


4. Add an `updateViews()` method to update the label with the current time.

	1. Create `updateViews()`

		    private func updateViews() {
		        timeLabel.text = String(countdown.timeRemaining)
		    }

	2. Call `updateViews()` from delegate methods:


			extension CountdownViewController: CountdownDelegate {
			    func countdownDidFinish() {
			        updateViews()
			        showAlert()
			    }
			    
			    func countdownDidUpdate(timeRemaining: TimeInterval) {
			        updateViews()
			    }
			}

5. The UI needs to be updated, it's not user friendly, and the font resizes in "CountdownViewController.swift"

	1. Make the font a fixed width number font, and updateViews() on start

		    override func viewDidLoad() {
		        super.viewDidLoad()
		
		        countdown.duration = 5
		        countdown.delegate = self
		        
		        // Use a fixed width font, so numbers don't "pop" and update UI to show duration
		        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize, weight: .medium)
		        updateViews()
		    }

	2. SHARE CODE via Slack: Format the duration using the helper method and property (Add above the IBOutlets)


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

	3. Update the `updateViews()` method to use the new formatter code to give text: "00:00:00.00" format


			private func updateViews() {
				timeLabel.text = string(from: countdown.timeRemaining)
			}

6. QUESTION: Does the countdown start and update the UI?
	1. If not, what issues are you having? 

7. BREAK: Take a 5 minute break


9. ACTIVITY (Optional): The countdown will update ~33 times per second when we make the interval `0.03`
	10. QUESTION: What happens to the UI if we change "Countdown.swift" to use 1 second for the interval?


		    func start() {
		        // Cancel timer before starting new timer
		        cancelTimer()
		        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: updateTimer(timer:))
		        stopDate = Date(timeIntervalSinceNow: duration)
		        state = .started
		    }

8. Make the reset button work:

	    @IBAction func resetButtonPressed(_ sender: Any) {
	        countdown.reset()
	    }



	1. Set a default duration of 5 seconds to test logic
	2. Integrate logic into start/reset actions
	3. Conform to the delegate protocol using an extension to get updates
	4. Display unformatted time remaining
8. Update the user interface
	1. Share code to format TimeInterval using DateFormatter + helper method
9. Create a "CountdownPicker.swift" subclass of `UIPickerView` to enable user selection of time.
	1. Set class on UIPickerView in "Main.storyboard"
	2. Conform to delegate protocol in 
10. Connect the app logic and user interface together and cleanup any logic
