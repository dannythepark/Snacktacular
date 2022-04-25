//
//  UIBarButtonItem+hide.swift
//  Snacktacular
//
//  Created by Danny Park on 4/24/22.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
}
