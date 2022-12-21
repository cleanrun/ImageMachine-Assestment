//
//  FormInputView.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit
import Combine

final class FormInputView: UIView {
    enum InputType {
        case field
        case button
    }
    
    static let PREFERRED_HEIGHT: CGFloat = 50
    
    private var bottomDividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemFill
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        textField.placeholder = "e.g. Lorem Ipsum"
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        return textField
    }()
    
    private lazy var inputButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Scan QR", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    var textFieldPublisher: AnyPublisher<String, Never> {
        inputTextField.textPublished
    }
    
    var inputButtonPublisher: UIControlPublisher<UIControl> {
        inputButton.publisher(for: .touchUpInside)
    }
    
    private let title: String
    private let type: InputType
    
    init(title: String, type: InputType = .field) {
        self.title = title
        self.type = type
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        self.title = ""
        self.type = .field
        super.init(coder: coder)
    }
    
    private func setupViews() {
        if type == .field {
            addSubviews(bottomDividerView, titleLabel, inputTextField)
        } else {
            addSubviews(bottomDividerView, titleLabel, inputButton)
        }
        
        NSLayoutConstraint.activate([
            bottomDividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomDividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            bottomDividerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            bottomDividerView.heightAnchor.constraint(equalToConstant: 1),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            titleLabel.widthAnchor.constraint(equalToConstant: 150),
        ])
        
        NSLayoutConstraint.activate(
            type == .field ? [
                inputTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
                inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                inputTextField.topAnchor.constraint(equalTo: topAnchor, constant: 6),
                inputTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            ] : [
                inputButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                inputButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
                inputButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            ]
        )
        
        titleLabel.text = title
        inputTextField.delegate = self
    }
    
    func setTextFieldInputView(_ view: UIView) {
        guard type == .field else {
            fatalError("FormInputView's type must be .field to execute this function ")
        }
        
        inputTextField.inputView = view
    }
    
    func setDateText(_ date: Date) {
        guard type == .field, inputTextField.inputView is UIDatePicker else {
            fatalError("FormInputView's type must be .field and the TextField's inputView must be a UIDatePicker to execute this function ")
        }
        
        inputTextField.text = date.toString(format: "dd/MM/yyyy")
    }
    
    func setInputButtonTitle(_ title: String) {
        guard type == .button else {
            fatalError("FormInputView's type must be .button to execute this function ")
        }
        
        inputButton.setTitle(title, for: .normal)
    }

}

extension FormInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
