//
//  FirstViewController.swift
//  TestAppQRAPI
//
//  Created by Sebastian Kolosa on 2016-09-18.
//  Copyright © 2016 SebastianKolosa. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController {
    var captureSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let qrCodeScanner = QRCodeScanner(parentVC: self)
        captureSession = qrCodeScanner.captureSession
        self.view.addSubview(qrCodeScanner)
        
        let view = UIView(frame: qrCodeScanner.scanRect!)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(view)
        captureSession!.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.captureSession != nil) {
            if (self.captureSession!.isRunning == false) {
                self.captureSession!.startRunning();
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.captureSession?.isRunning == true) {
            self.captureSession?.stopRunning();
        }
    }
    
    func found(code: String) {
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false //defaulte
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

