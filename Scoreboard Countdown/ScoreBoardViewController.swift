//
//  ViewController.swift
//  Scoreboard Countdown
//
//  Created by Chris Byatt on 11/10/2015.
//  Copyright © 2015 Tyler Behnken. All rights reserved.
//

import UIKit
import iAd

class ScoreBoardViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tapMeWidth: NSLayoutConstraint!
    @IBOutlet var backgroundImage: UIImageView!

    @IBOutlet var stadiumName: UITextField! {
        didSet {
            stadiumName.delegate = self
            let stadiumString = NSUserDefaults.standardUserDefaults().stringForKey("stadiumName")
            stadiumName.attributedText = NSAttributedString(string: stadiumString!, attributes: [NSStrokeColorAttributeName: UIColor.blackColor(), NSStrokeWidthAttributeName: -3])
        }
    }
    @IBOutlet var gameName: UITextField! {
        didSet {
            gameName.delegate = self
            gameName.text = NSUserDefaults.standardUserDefaults().stringForKey("gameName")
        }
    }
    @IBOutlet var dateField: UITextField! {
        didSet {
            dateField.delegate = self
        }
    }
    @IBOutlet var tolLeft: UITextField! {
        didSet {
            tolLeft.delegate = self
            tolLeft.text = NSUserDefaults.standardUserDefaults().stringForKey("tolLeft")
        }
    }
    @IBOutlet var tolRight: UITextField! {
        didSet {
            tolRight.delegate = self
            tolRight.text = NSUserDefaults.standardUserDefaults().stringForKey("tolRight")

        }
    }
    @IBOutlet var onField: UITextField! {
        didSet {
            onField.delegate = self
            onField.text = NSUserDefaults.standardUserDefaults().stringForKey("onField")
        }
    }
    @IBOutlet var quarterField: UITextField! {
        didSet {
            quarterField.delegate = self
            quarterField.text = NSUserDefaults.standardUserDefaults().stringForKey("quarterField")
        }
    }
    
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var secondsLabel: UILabel!
    
    var targetDate: NSDate?
    var previousTargetDate: NSDate?
    
    /**
     Here we set up the view if a previous timer has been set or reset everything if there is no target date/the timer has expired.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        targetDate = NSUserDefaults.standardUserDefaults().objectForKey("targetDate") as? NSDate
        if (!(targetDate?.earlierDate(NSDate()) == targetDate)) {
            setTimer()

            dateField.text = targetDate!.parseDateShortFormat()
        } else {
            targetDate = nil
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "dateString")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "targetDate")

            dateField.text = "Tap Here!"
        }
        
        let screenSize = UIScreen.mainScreen().bounds.size
        
        if screenSize.width + screenSize.height == 480 + 320 {
            tapMeWidth.constant = 215
        }
        
        self.canDisplayBannerAds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Here we ensure that when the user has made any changes they are stored right away
     
     - parameter textField: The text field that has had changes made to it
     */
    func textFieldDidEndEditing(textField: UITextField) {
        
        switch textField {
        case stadiumName:
            NSUserDefaults.standardUserDefaults().setObject(textField.text, forKey: "stadiumName")
            textField.attributedText = NSAttributedString(string: textField.text!, attributes: [NSStrokeColorAttributeName: UIColor.blackColor(), NSStrokeWidthAttributeName: -3])
        case gameName:
            NSUserDefaults.standardUserDefaults().setObject(textField.text, forKey: "gameName")
        case tolLeft:
            NSUserDefaults.standardUserDefaults().setObject(textField.text, forKey: "tolLeft")
        case tolRight:
            NSUserDefaults.standardUserDefaults().setObject(textField.text, forKey: "tolRight")
        case onField:
            NSUserDefaults.standardUserDefaults().setObject(textField.text, forKey: "onField")
        case quarterField:
            NSUserDefaults.standardUserDefaults().setObject(textField.text, forKey: "quarterField")
        default:
            break
        }
    }
    
    /**
     This is where we set up the date picker for the date field so that the picker is displayed rather than a keyboard. We also set up the controls for changing the value of the date/time and the toolbar that allows us to dismiss the datepicker.
     
     - parameter textField: The text field the user has requested to edit
     
     - returns: Whether we should allow the user to begin editing or not. Always true.
     */
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == dateField {
            previousTargetDate = targetDate
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
            datePickerView.minimumDate = NSDate().dateByAddingTimeInterval(60)
            if targetDate != nil {
                datePickerView.date = targetDate!
            }
            datePickerView.addTarget(self, action: "handleDatePickerView:", forControlEvents: .ValueChanged)
            textField.inputView = datePickerView
            
            let datePickerToolbar = UIToolbar()
            datePickerToolbar.barStyle = .Default
            datePickerToolbar.items = [UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelDateField"),
                                       UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
                                       UIBarButtonItem(title: "Done", style: .Done, target: self, action: "finishDateField")]
            datePickerToolbar.sizeToFit()
            textField.inputAccessoryView = datePickerToolbar
        }
        
        return true
    }
    
    /**
     This is where we enable the return key on the keyboard to dismiss the keyboard.
     
     - parameter textField: The text field that has had the return key pressed on it
     
     - returns: Always true as we don't need to override the default return behaviour
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    /**
     In this method we set the datefield to whatever date is on the picker each time it's changed. We also set the days etc.
     
     - parameter sender: The date picker that has had the date changed
     */
    func handleDatePickerView(sender: UIDatePicker) {
    
        dateField.text = sender.date.parseDateShortFormat()
        targetDate = sender.date
        
        let components = sender.date.parseToCalendarComponents()
        daysLabel.text = String(components.day)
        hoursLabel.text = String(components.hour)
        minutesLabel.text = String(components.minute)
        secondsLabel.text = String(components.second)
    }
    
    /**
     In setTimer we start the timer based on the final date when the done button was pressed in the date picker. 
     */
    func setTimer() {
        
        NSUserDefaults.standardUserDefaults().setObject(targetDate, forKey: "targetDate")
        dateField.text = targetDate?.parseDateShortFormat()
        
        NSUserDefaults.standardUserDefaults().setObject(dateField.text!, forKey: "dateString")
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "updateCounter:", userInfo: nil, repeats: true)
        
        // Cancel previously set notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "Timer has finished!" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = targetDate // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.category = "TODO_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    /**
     This function is called each time the timer changes. It checks whether the timer has finished, in which case we invalidate it, or if it hasn't then it updates the UI to show new values
     
     - parameter timer: The timer that's updating
     */
    func updateCounter(timer: NSTimer) {
        let now = NSDate()
        if (targetDate?.earlierDate(now) == targetDate) {
            timer.invalidate()
            dateField.text = "Finish!"
            
            showFinishAlert()
        } else {
            let components = targetDate!.parseToCalendarComponents()
            daysLabel.text = String(components.day)
            hoursLabel.text = String(components.hour)
            minutesLabel.text = String(components.minute)
            secondsLabel.text = String(components.second)
        }
    }
    
    /**
     This function handles what we should do when pressing the cancel button on the date field while a there is a previous target date or no date at all.
     */
    func cancelDateField() {
        targetDate = previousTargetDate
        if let target = targetDate {
            dateField.text = target.parseDateShortFormat()
        } else {
            targetDate = nil
            daysLabel.text = "365"
            hoursLabel.text = "24"
            minutesLabel.text = "60"
            secondsLabel.text = "60"
            dateField.text = "Tap Here!"
        }
        
        dateField.resignFirstResponder()
    }
    
    
    /**
     This handles what happens when the done button on the toolbar for the date picker is pressed.
     */
    func finishDateField() {
        dateField.endEditing(true)
        dateField.resignFirstResponder()
        
        setTimer()
    }
    
    /**
     An alert for the user letting them know the timer has finished.
     */
    func showFinishAlert() {
        let alert = UIAlertController(title: "Finished!", message: "Your timer has finished!", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Finish", style: .Destructive, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

