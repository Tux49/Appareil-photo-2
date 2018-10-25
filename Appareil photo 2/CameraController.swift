//
//  CameraController.swift
//  Appareil photo 2
//
//  Created by Thierry Huu on 25/10/2018.
//  Copyright © 2018 Thierry Huu. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    
    var captureSession: AVCaptureSession?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var position = AVCaptureDevice.Position.back
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    func setupCamera() {
        previewLayer?.removeFromSuperlayer()
        
        captureSession = AVCaptureSession()
        guard captureSession != nil else { return }
        
        guard let appareil =
            AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                    for: .video, position: position) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: appareil)
            if captureSession!.canAddInput(input) {
                captureSession!.addInput(input)
                capturePhotoOutput = AVCapturePhotoOutput()
                guard capturePhotoOutput != nil else { return }
                if captureSession!.canAddOutput(capturePhotoOutput!) {
                    captureSession!.addOutput(capturePhotoOutput!)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                    guard previewLayer != nil else { return }
                    previewLayer!.videoGravity = .resizeAspectFill
                    previewLayer!.connection?.videoOrientation = .portrait
                    previewLayer!.frame = cameraView.bounds
                    cameraView.layer.addSublayer(previewLayer!)
                    captureSession!.startRunning()
                }
            }
        } catch {
            print("Erreur -> \(error.localizedDescription)")
        }
    }

    @IBAction func prendrePhoto(_ sender: Any) {
    }
    
    @IBAction func versLibrarie(_ sender: Any) {
    }
    
    @IBAction func rotationCamera(_ sender: Any) {
        switch position {
        case .back: position = .front
        default: position = .back
        }
        setupCamera()
    }
}

