//
//  QRCodeGenerator.swift
//  TestAppQRAPI
//
//  Created by Sebastian Kolosa on 2016-09-18.
//  Copyright © 2016 SebastianKolosa. All rights reserved.
//

import UIKit
import CoreImage

class QRCodeGenerator: NSObject {
    var qrCodeImage: CIImage = CIImage()
    
    func setQRCodeData(data: String) {
        let formattedData = data.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(formattedData, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        qrCodeImage = filter.outputImage!
    }
}
