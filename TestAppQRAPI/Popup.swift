//
//  Popup.swift
//  TestAppQRAPI
//
//  Created by Sebastian Kolosa on 2016-09-25.
//  Copyright © 2016 SebastianKolosa. All rights reserved.
//

import Foundation
import UIKit

class Popup: UIView {
    @IBOutlet weak var popupLabel: UILabel!
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        if let popupView = self.superview {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                popupView.alpha = 0
            }) { _ in
                NotificationCenter.default.post(name: CustomNotifications.popupDismissedNotification, object: self)
                popupView.removeFromSuperview()
            }
        }
    }
    
    func setPopupLabelText(text:String) {
        popupLabel.text = text
    }
}
