//
//  ViewController.swift
//  Scoreboard Countdown
//
//  Created by Chris Byatt on 11/10/2015.
//  Copyright © 2015 Tyler Behnken. All rights reserved.
//

import UIKit

class ScoreBoardViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var backgroundImage: UIImageView!

    @IBOutlet var stadiumName: UITextField!
    @IBOutlet var gameName: UITextField!
    @IBOutlet var dateField: UITextField!
    
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var secondsLabel: UILabel!
    
    var targetDate: NSDate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        targetDate = NSUserDefaults.standardUserDefaults().objectForKey("targetDate") as? NSDate
        
        stadiumName.delegate = self
        gameName.delegate = self
        dateField.delegate = self
        
        stadiumName.text = NSUserDefaults.standardUserDefaults().stringForKey("stadiumName")
        gameName.text = NSUserDefaults.standardUserDefaults().stringForKey("gameName")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        switch textField {
        case stadiumName:
            NSUserDefaults.standardUserDefaults().setObject(textField.text, forKey: "stadiumName")
        case gameName:
            NSUserDefaults.standardUserDefaults().setObject(textField.text, forKey: "gameName")
        default:
            break
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == dateField {
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
            datePickerView.addTarget(self, action: "handleDatePickerView:", forControlEvents: .ValueChanged)
            datePickerView.addTarget(self, action: "setTimer:", forControlEvents: .EditingDidEnd)
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
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateField.text = dateFormatter.stringFromDate(sender.date)
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Hour, .Minute, .Second], fromDate: NSDate(), toDate: sender.date, options: [])
        daysLabel.text = String(components.day)
        hoursLabel.text = String(components.hour)
        minutesLabel.text = String(components.minute)
        secondsLabel.text = String(components.second)
    }
    
    func setTimer(sender: UIDatePicker) {
        targetDate = sender.date
        NSUserDefaults.standardUserDefaults().setObject(targetDate, forKey: "targetDate")
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "updateCounter:", userInfo: nil, repeats: true)
    }
    
    func updateCounter(timer: NSTimer) {
        let now = NSDate()
        if (targetDate?.earlierDate(now) == targetDate) {
            timer.invalidate()
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
        if let target = targetDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateField.text = dateFormatter.stringFromDate(target)
        }
        
        dateField.resignFirstResponder()
    }
    
    func finishDateField() {
        dateField.endEditing(true)
    }
}

