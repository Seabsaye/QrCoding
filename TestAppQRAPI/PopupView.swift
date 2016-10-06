//
//  PopupView.swift
//  TestAppQRAPI
//
//  Created by Sebastian Kolosa on 2016-09-24.
//  Copyright © 2016 SebastianKolosa. All rights reserved.
//

import Foundation
import UIKit

class PopupView: UIView {
    
    var popup: Popup?

    init() {
        let popupViewRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        super.init(frame: popupViewRect)
        
        let backgroundView = UIView()
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.0
        self.addSubview(backgroundView)
        
        if ((Bundle.main.loadNibNamed("Popup", owner: self, options: [:])?.first as? Popup) != nil) {
            popup = Bundle.main.loadNibNamed("Popup", owner: self, options: [:])?.first as? Popup
            popup?.frame.size = CGSize(width: 0, height: 0)
            popup?.center = self.center
            popup?.alpha = 0.0
            var dView:[String:UIView] = [:]
            dView["popup"] = popup!
            popup?.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(popup!)
            let h_pin = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(36)-[popup]-(36)-|", options:[], metrics: nil, views: dView)
            let v_pin = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(100)-[popup]-(100)-|", options:[], metrics: nil, views: dView)
            let constX = NSLayoutConstraint(item: popup!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            let constY = NSLayoutConstraint(item: popup!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            self.addConstraints(h_pin)
            self.addConstraints(v_pin)
            self.addConstraint(constX)
            self.addConstraint(constY)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                backgroundView.alpha = 0.75
                self.popup?.alpha = 1.0
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelText(text: String) {
        popup?.setPopupLabelText(text: text)
    }
}
