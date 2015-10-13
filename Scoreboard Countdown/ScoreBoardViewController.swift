//
//  ViewController.swift
//  Scoreboard Countdown
//
//  Created by Chris Byatt on 11/10/2015.
//  Copyright © 2015 Tyler Behnken. All rights reserved.
//

import UIKit

class ScoreBoardViewController: UIViewController, UITextFieldDelegate {

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
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
//        self.resignFirstResponder()
        return false
    }

    func handleDatePickerView(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateField.text = dateFormatter.stringFromDate(sender.date)
        let elapsedSeconds = sender.date.timeIntervalSinceDate(NSDate())
        daysLabel.text = String((elapsedSeconds / 24) % 24)
        //hoursLabel.text = String(elapsedSeconds / 3600)
        //minutesLabel.text = String((elapsedSeconds / 60) % 60)
        //secondsLabel.text = String(elapsedSeconds % 60)
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
            if let elapsedSeconds = targetDate?.timeIntervalSinceDate(now) {
                daysLabel.text = String(elapsedSeconds % 24)
                hoursLabel.text = String(elapsedSeconds / 3600)
                minutesLabel.text = String((elapsedSeconds / 60) % 60)
                secondsLabel.text = String(elapsedSeconds % 60)
            }
        }
    }
}

