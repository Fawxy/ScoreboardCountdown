//
//  CustomUILabel.swift
//  Scoreboard Countdown
//
//  Created by Chris Byatt on 16/10/2015.
//  Copyright © 2015 Tyler Behnken. All rights reserved.
//

import Foundation
import UIKit

class CustomUILabel : UILabel {
    
    private func shouldShrinkFont() -> Bool {
        let size = UIScreen.mainScreen().bounds.size
        return size.width + size.height == 480 + 320
    }
    
    override var font: UIFont! {
        didSet {
            if shouldShrinkFont() {
                super.font = UIFont(name: "Score Board", size: font.pointSize - 10)
            } else {
                super.font = UIFont(name: "Score Board", size: font.pointSize)
            }
        }
    }
}