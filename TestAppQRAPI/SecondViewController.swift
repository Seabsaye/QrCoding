//
//  SecondViewController.swift
//  TestAppQRAPI
//
//  Created by Sebastian Kolosa on 2016-09-18.
//  Copyright © 2016 SebastianKolosa. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var qrCodeImage: UIImageView!
    var qrCodeGenerator = QRCodeGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func generateButtonAction(_ sender: UIButton) {
        if let strData = dataTextField.text {
            qrCodeGenerator.setQRCodeData(data: strData)
            self.qrCodeImage.image = UIImage(ciImage: qrCodeGenerator.qrCodeImage)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

