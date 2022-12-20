//
//  FormFieldView.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit
import Combine

final class FormFieldView: UIView {
    
    static let PREFERRED_HEIGHT: CGFloat = 70
    
    private var topDividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemFill
        return view
    }()
    
    private var bottomDividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemFill
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "Title"
        return label
    }()
    
    private var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var textFieldPublisher: AnyPublisher<String, Never> {
        inputTextField.textPublished
    }
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        addSubviews(topDividerView, bottomDividerView, titleLabel, inputTextField)
        
        NSLayoutConstraint.activate([
            topDividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            topDividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            topDividerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            topDividerView.heightAnchor.constraint(equalToConstant: 1),
            
            bottomDividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            bottomDividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            bottomDividerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            bottomDividerView.heightAnchor.constraint(equalToConstant: 1),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            
            inputTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            inputTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            inputTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
        ])
    }
    
    func setTextFieldInputView(_ view: UIView) {
        inputTextField.inputView = view
    }
    
}
