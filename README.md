# Alert Controllers, Pickers, and Timers Guided Project


## Starter Project

Have students fork and clone the [starter guided project](https://github.com/LambdaSchool/ios-guided-project-starter-alert-controllers-pickers-timers).


# Summary

1. Demo the countdown app
2. Design the UI using stack view with spacing (16 to sides, 8 between)

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
8. Create a method to show the alert after 5 seconds using a `Timer` object
9. Users want visual feedback when a timer is running, use the included "Countdown.swift" to keep track of time remaining.
	1. Discuss how the class works from a high level
	2. Set a default duration of 5 seconds to test logic
	3. Integrate logic into start/reset actions
	4. Conform to the delegate protocol using an extension to get updates
	5. Display unformatted time remaining
10. Update the user interface
	1. Share code to format TimeInterval using DateFormatter + helper method
11. Create a "CountdownPicker.swift" subclass of `UIPickerView` to enable user selection of time.
	1. Set class on UIPickerView in "Main.storyboard"
	2. Conform to delegate protocol in 
12. Connect the app logic and user interface together and cleanup any logic
