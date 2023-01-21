//
//  ReaderView.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import UIKit
import AVFoundation

final class ReaderView: BaseVC, ReaderPresenterToViewProtocol {
    private var cameraView: UIView!
    private var infoLabel: UILabel!
    
    private(set) var captureSession: AVCaptureSession!
    private(set) var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let readerType: ReaderVM.ReaderType
    
    var presenter: ReaderViewToPresenterProtocol!
    
    init(readerType: ReaderVM.ReaderType) {
        self.readerType = readerType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if checkIfCameraIsAuthorized() {
            animateInfoLabel(true)
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
        } else {
            presenter.showCameraNotAuthorizedAlert()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animateInfoLabel(false)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if checkIfCameraIsAuthorized() {
            previewLayer.frame = cameraView.bounds
        }
    }
    
    override func loadView() {
        super.loadView()
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
            infoLabel.alpha = 1
            infoLabel.layer.removeAllAnimations()
        }
    }
    
    func detectedCode(_ value: String) {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
        presenter.detectCode(type: readerType, value)
    }
    
    func restartCaptureSession() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }

}

extension ReaderView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue
            else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            detectedCode(stringValue)
        }
    }
}
