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

    @IBOutlet var stadiumName: UITextField!
    @IBOutlet var gameName: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var tolLeft: UITextField!
    @IBOutlet var tolRight: UITextField!
    @IBOutlet var onField: UITextField!
    @IBOutlet var quarterField: UITextField!
    
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
        let now = NSDate()
        if (!(targetDate?.earlierDate(now) == targetDate)) {
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
        
        stadiumName.delegate = self
        gameName.delegate = self
        dateField.delegate = self
        tolLeft.delegate = self
        tolRight.delegate = self
        onField.delegate = self
        quarterField.delegate = self
        
        let stadiumString = NSUserDefaults.standardUserDefaults().stringForKey("stadiumName")
        stadiumName.attributedText = NSAttributedString(string: stadiumString!, attributes: [NSStrokeColorAttributeName: UIColor.blackColor(), NSStrokeWidthAttributeName: -3])
        gameName.text = NSUserDefaults.standardUserDefaults().stringForKey("gameName")
        tolLeft.text = NSUserDefaults.standardUserDefaults().stringForKey("tolLeft")
        tolRight.text = NSUserDefaults.standardUserDefaults().stringForKey("tolRight")
        onField.text = NSUserDefaults.standardUserDefaults().stringForKey("onField")
        quarterField.text = NSUserDefaults.standardUserDefaults().stringForKey("quarterField")
        
        self.canDisplayBannerAds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
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

