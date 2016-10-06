//
//  ScannerOverlay.swift
//  TestAppQRAPI
//
//  Created by Sebastian Kolosa on 2016-09-29.
//  Copyright © 2016 SebastianKolosa. All rights reserved.
//

import UIKit

class ScannerOverlay: UIView {
    var backgroundColour: UIColor?
    var transparentRect: NSValue?
    init(frame: CGRect, backgroundColour: UIColor, transparentRect:NSValue) {
        super.init(frame: frame)
        self.backgroundColour = backgroundColour
        self.transparentRect = transparentRect
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        backgroundColour?.setFill()
        UIRectFill(rect)

        let holeRect = transparentRect?.cgRectValue
        let holeRectIntersection = holeRect?.intersection(rect)
        UIColor.clear.setFill()
        UIRectFill(holeRectIntersection!)
    }
    
    func invalidQRReaction(displayTime: Double) {
        let previousBGColour = self.backgroundColour
        self.backgroundColour = UIColor.red.withAlphaComponent(0.25)
        self.setNeedsDisplay()
        //add extra second to give time after background goes back to initial state
        DispatchQueue.main.asyncAfter(deadline: .now() + (displayTime + 1)) {
            self.backgroundColour = previousBGColour
            self.setNeedsDisplay()
        }
    }
}
