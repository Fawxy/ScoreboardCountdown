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
        
    let size = UIScreen.mainScreen().bounds.size
    
    private func shouldChangeFont(screenSize: CGFloat) -> Bool {
        return size.width + size.height == screenSize
    }
    
    override var font: UIFont! {
        didSet {
            if shouldChangeFont(480 + 320) {
                super.font = UIFont(name: "Score Board", size: font.pointSize - 10)
            } else if shouldChangeFont(667 + 375) {
                super.font = UIFont(name: "Score Board", size: font.pointSize + 4)
            } else if shouldChangeFont(736 + 414) {
                super.font = UIFont(name: "Score Board", size: font.pointSize + 7)
            } else {
                super.font = UIFont(name: "Score Board", size: font.pointSize)
            }
        }
    }
}
