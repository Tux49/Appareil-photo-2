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
    
    var imagePicker = UIImagePickerController()
    var imageChoisie: UIImage?
    var imageView: CustomImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        montrerImage()
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
    
    func montrerImage() {
        if imageView != nil {
            imageView = nil
        }
        guard imageChoisie != nil else { return }
        imageView = CustomImageView()
        imageView?.montrerImage(imageChoisie)
        guard imageView != nil else { return }
        view.addSubview(imageView!)
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView?.frame.size = self.view.frame.size
            self.imageView?.center = self.view.center
        }) { (success) in
            self.imageView?.backgroundColor = .darkGray
        }
    }

    @IBAction func prendrePhoto(_ sender: Any) {
        guard capturePhotoOutput != nil else { return }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.previewPhotoFormat = photoSettings.embeddedThumbnailPhotoFormat
        capturePhotoOutput?.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func versLibrarie(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func rotationCamera(_ sender: Any) {
        switch position {
        case .back: position = .front
        default: position = .back
        }
        setupCamera()
    }
}

extension CameraController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageChoisie = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let erreur = error {
            print("Erreur: \(erreur.localizedDescription)")
        } else {
            if let data = photo.fileDataRepresentation() {
                self.imageChoisie = UIImage(data: data)
                self.montrerImage()
            } else {
                print("Erreur: le résultat ne m'a pas donné de data")
            }
        }
    }
}
