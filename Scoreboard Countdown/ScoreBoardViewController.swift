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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        targetDate = NSUserDefaults.standardUserDefaults().objectForKey("targetDate") as? NSDate
        if (!(targetDate?.earlierDate(NSDate()) == targetDate)) {
            setTimer()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateField.text = dateFormatter.stringFromDate(targetDate!)
        } else {
            targetDate = nil
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "dateString")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "targetDate")

            dateField.text = "Tap Here!"
        }
        
        if UIScreen.mainScreen().bounds.size.width + UIScreen.mainScreen().bounds.size.height == 480 + 320 {
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

    func handleDatePickerView(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateField.text = dateFormatter.stringFromDate(sender.date)
        
        targetDate = sender.date
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Hour, .Minute, .Second], fromDate: NSDate(), toDate: sender.date, options: [])
        daysLabel.text = String(components.day)
        hoursLabel.text = String(components.hour)
        minutesLabel.text = String(components.minute)
        secondsLabel.text = String(components.second)
    }
    
    func setTimer() {
        NSUserDefaults.standardUserDefaults().setObject(targetDate, forKey: "targetDate")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateField.text = dateFormatter.stringFromDate(targetDate!)
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
    
    func updateCounter(timer: NSTimer) {
        let now = NSDate()
        if (targetDate?.earlierDate(now) == targetDate) {
            timer.invalidate()
            dateField.text = "Finish!"
            
            showFinishAlert()
        } else {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day, .Hour, .Minute, .Second], fromDate: now, toDate: targetDate!, options: [])
            daysLabel.text = String(components.day)
            hoursLabel.text = String(components.hour)
            minutesLabel.text = String(components.minute)
            secondsLabel.text = String(components.second)
        }
    }
    
    func cancelDateField() {
        targetDate = previousTargetDate
        if let target = targetDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateField.text = dateFormatter.stringFromDate(target)
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
    
    func finishDateField() {
        dateField.endEditing(true)
        dateField.resignFirstResponder()
        
        setTimer()
    }
    
    func showFinishAlert() {
        let alert = UIAlertController(title: "Finished!", message: "Your timer has finished!", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Finish", style: .Destructive, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

