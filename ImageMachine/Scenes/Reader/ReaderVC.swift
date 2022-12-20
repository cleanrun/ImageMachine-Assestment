//
//  ReaderVC.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit
import AVFoundation

final class ReaderVC: BaseVC {
    private var cameraView: UIView!
    private var infoLabel: UILabel!
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!

    private var viewModel: ReaderVM!
    
    init(type: ReaderVM.ReaderType) {
        super.init(nibName: nil, bundle: nil)
        viewModel = ReaderVM(vc: self, type: type)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = ReaderVM(vc: self, type: .detect)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateInfoLabel(true)
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animateInfoLabel(false)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    override func setupUI() {
        super.setupUI()
        title = "Reader"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        cameraView = UIView()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.layer.cornerRadius = 8
        cameraView.layer.masksToBounds = true
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.text = "Scan your QR Code here"
        infoLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        infoLabel.textColor = .white
        
        view.addSubviews(cameraView, infoLabel)
        
        NSLayoutConstraint.activate([
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cameraView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            cameraView.heightAnchor.constraint(equalToConstant: (deviceWidth - 32)),
            
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            infoLabel.topAnchor.constraint(equalTo: cameraView.topAnchor, constant: 32),
        ])
        
        setupReader()
    }
    
    override func setupBindings() {
        
    }
    
    private func setupReader() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            // FIXME: Implement error input here
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            // FIXME: Implement error output here
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        DispatchQueue.main.async { [unowned self] in
            self.previewLayer.frame = self.cameraView.bounds
            self.cameraView.layer.addSublayer(self.previewLayer)
        }
        
        captureSession.startRunning()
    }
    
    private func showQRResultAlert(result: String) {
        let alert = UIAlertController(title: "QR Code Result",
                                      message: "This QR contains a data: \(result)",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .cancel) { [unowned self] _ in
            self.captureSession.startRunning()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func animateInfoLabel(_ animating: Bool) {
        if animating {
            UIView.animate(withDuration: 1,
                           delay: 0,
                           options: [.autoreverse, .repeat],
                           animations: { [unowned self] in
                self.infoLabel.alpha = 0
            })
        } else {
            infoLabel.layer.removeAllAnimations()
        }
    }
}

extension ReaderVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue
            else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            showQRResultAlert(result: stringValue)
        }
    }
}
