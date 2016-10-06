//
//  QRCodeScanner.swift
//  TestAppQRAPI
//
//  Created by Sebastian Kolosa on 2016-09-18.
//  Copyright © 2016 SebastianKolosa. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScanner: UIView, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var parentViewController: UIViewController?
    var metadataOutput: AVCaptureMetadataOutput?
    var previewLayerRect: CGRect?
    var scanRect: CGRect?
    var scannerOverlay: ScannerOverlay?
    var invalidScannerTimeout: Double?
    var validScannerTimeout: Double?
    
    init(parentVC: UIViewController) {
        parentViewController = parentVC
        previewLayerRect = CGRect(x: 0, y: 0, width: parentVC.view.bounds.width, height: parentVC.view.bounds.height - (parentVC.tabBarController?.tabBar.frame.size.height)!)
        super.init(frame: previewLayerRect!)
        
        captureSession = AVCaptureSession()
        
        configureInput(captureSession: captureSession!)
        configureOutput(captureSession: captureSession!)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.frame = self.bounds
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.avCaptureInputPortFormatDescriptionDidChangeNotification), name:NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.popupDidDismiss), name: CustomNotifications.popupDismissedNotification, object: nil)
        
        scanRect = CGRect(x: parentViewController!.view.frame.midX - 150, y: parentViewController!.view.frame.midY - 250, width: 300, height: 300)
        
        scannerOverlay = ScannerOverlay(frame: previewLayerRect!, backgroundColour: UIColor.black.withAlphaComponent(0.25), transparentRect: NSValue(cgRect: scanRect!))
        scannerOverlay?.isOpaque = false
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        let scanView = UIView(frame: previewLayerRect!)
        scanView.layer.addSublayer(previewLayer!)
        self.addSubview(scanView)
        self.addSubview(scannerOverlay!)
        
        //config as required
        invalidScannerTimeout = 3
        validScannerTimeout = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureInput(captureSession: AVCaptureSession) {
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
    }
    
    private func configureOutput(captureSession: AVCaptureSession) {
        metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput?.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            failed()
            return
        }
    }
    
    private func failed() {
        let ac = UIAlertController(title: "Camera not supported", message: "Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.parentViewController?.present(ac, animated: true)
        
        self.captureSession = nil
    }
    
    private func scanTimeout(timeout: Double) {
        self.captureSession?.removeOutput(metadataOutput)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            self.captureSession?.addOutput(self.metadataOutput)
        }
    }
    
    private func removeCaptureSessionOutput() {
        self.captureSession?.removeOutput(metadataOutput)
    }
    
    private func addCaptureSessionOutput() {
        self.captureSession?.addOutput(metadataOutput)
    }
    
    //notification that previewLayer ready to configure rectOfInterest
    func avCaptureInputPortFormatDescriptionDidChangeNotification(notification: NSNotification) {
        self.metadataOutput?.rectOfInterest = (self.previewLayer?.metadataOutputRectOfInterest(for: scanRect!))!
    }
    
    //notification callback
    func popupDidDismiss() {
        scanTimeout(timeout: validScannerTimeout!)
    }
    
    //AVCaptureMetaDataOutputObjectsDelegate method
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            if (readableObject.stringValue != Constants.kURL) {
                scanTimeout(timeout: invalidScannerTimeout!)
                scannerOverlay?.invalidQRReaction(displayTime: invalidScannerTimeout!)
                return
            }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            removeCaptureSessionOutput()
            Http.getRequest(strUrl: readableObject.stringValue, completionHandler: { (dataDict) -> Void in
                if let value = dataDict["returnValue"] as? String {
                    let popupView = PopupView()
                    DispatchQueue.main.async {
                        self.parentViewController?.view.addSubview(popupView)
                        popupView.setLabelText(text: value)
                        popupView.center = self.center
                    }
                }
            })
        }
    }
}
