//
//  AddDataVC.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit
import SwiftUI

final class AddDataVC: BaseVC {
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private var nameField: FormFieldView = {
        let field = FormFieldView()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private var typeField: FormFieldView = {
        let field = FormFieldView()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private var dateField: FormFieldView = {
        let field = FormFieldView()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private var dateInputView: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.current
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    private var viewModel: AddDataVM!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = AddDataVM(vc: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = AddDataVM(vc: self)
    }
    
    override func setupUI() {
        super.setupUI()
        title = "Add Data"
        navigationItem.largeTitleDisplayMode = .never
        
        containerStackView.addArrangedSubviews(nameField, typeField, dateField)
        scrollView.addSubview(containerStackView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameField.heightAnchor.constraint(equalToConstant: FormFieldView.PREFERRED_HEIGHT),
            typeField.heightAnchor.constraint(equalToConstant: FormFieldView.PREFERRED_HEIGHT),
            dateField.heightAnchor.constraint(equalToConstant: FormFieldView.PREFERRED_HEIGHT)
        ])
        
        dateField.setTextFieldInputView(dateInputView)
    }
    
    override func setupBindings() {
        nameField
            .textFieldPublisher
            .sink { [unowned self] value in
                self.viewModel.name = value
            }.store(in: &disposables)
        
        typeField
            .textFieldPublisher
            .sink { [unowned self] value in
                self.viewModel.type = value
            }.store(in: &disposables)
    }
    
}
