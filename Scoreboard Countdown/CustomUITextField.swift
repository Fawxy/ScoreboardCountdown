//
//  CustomUITextField.swift
//  Scoreboard Countdown
//
//  Created by Chris Byatt on 16/10/2015.
//  Copyright © 2015 Tyler Behnken. All rights reserved.
//

import Foundation
import UIKit

class CustomUITextField : UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.font = UIFont(name: "Score Board", size: self.font!.pointSize)
    }
}