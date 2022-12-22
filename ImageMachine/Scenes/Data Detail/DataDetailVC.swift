//
//  DataDetailVC.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit

final class DataDetailVC: BaseVC {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Data>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Data>
    
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
    
    private var nameField: FormInputView = {
        let field = FormInputView(title: "Name")
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private var typeField: FormInputView = {
        let field = FormInputView(title: "Type")
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private var qrField: FormInputView = {
        let field = FormInputView(title: "QR Number", type: .button)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isButtonEnabled(false)
        return field
    }()
    
    private var dateField: FormInputView = {
        let field = FormInputView(title: "Maintenance Date")
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var saveButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var editAndSaveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setTitle("Edit", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private var dateInputView: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.current
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    private(set) var viewModel: DataDetailVM!
    private var dataSource: DataSource!

    init(model: MachineModel) {
        super.init(nibName: nil, bundle: nil)
        viewModel = DataDetailVM(vc: self, model: model)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupUI() {
        super.setupUI()
        //dismissKeyboardWhenViewIsTapped()
        title = "Machine Detail"
        navigationItem.largeTitleDisplayMode = .never
        
        containerStackView.addArrangedSubviews(nameField, typeField, qrField, dateField, imagesCollectionView)
        scrollView.addSubview(containerStackView)
        saveButtonContainerView.addSubview(editAndSaveButton)
        view.addSubviews(saveButtonContainerView, scrollView)
        
        NSLayoutConstraint.activate([
            saveButtonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            saveButtonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            saveButtonContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            saveButtonContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            editAndSaveButton.leadingAnchor.constraint(equalTo: saveButtonContainerView.leadingAnchor, constant: 16),
            editAndSaveButton.trailingAnchor.constraint(equalTo: saveButtonContainerView.trailingAnchor, constant: -16),
            editAndSaveButton.topAnchor.constraint(equalTo: saveButtonContainerView.topAnchor, constant: 16),
            editAndSaveButton.bottomAnchor.constraint(equalTo: saveButtonContainerView.bottomAnchor, constant: -16),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: saveButtonContainerView.topAnchor, constant: 0),
            
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameField.heightAnchor.constraint(equalToConstant: FormInputView.PREFERRED_HEIGHT),
            typeField.heightAnchor.constraint(equalToConstant: FormInputView.PREFERRED_HEIGHT),
            dateField.heightAnchor.constraint(equalToConstant: FormInputView.PREFERRED_HEIGHT),
            qrField.heightAnchor.constraint(equalToConstant: FormInputView.PREFERRED_HEIGHT),
            imagesCollectionView.heightAnchor.constraint(equalToConstant: ImageCell.PREFERRED_HEIGHT_AND_WIDTH)
        ])
        
        dateField.setTextFieldInputView(dateInputView)
        nameField.setDefaultTextFieldText(viewModel.model.name)
        typeField.setDefaultTextFieldText(viewModel.model.type)
        dateField.setDateText(viewModel.model.maintenanceDate)
        
        imagesCollectionView.delegate = self
        imagesCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.REUSABLE_IDENTIFIER)
        dataSource = DataSource(collectionView: imagesCollectionView, cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.REUSABLE_IDENTIFIER, for: indexPath) as! ImageCell
            if let image = viewModel.images[indexPath.row].createDownsampledImage(to: CGSize(width: 100, height: 100)) {
                cell.setImage(image)
            }
            return cell
        })
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
        
        dateInputView
            .publisher(for: .valueChanged)
            .sink { [unowned self] value in
                self.viewModel.maintenanceDate = self.dateInputView.date
            }.store(in: &disposables)
        
        editAndSaveButton
            .publisher(for: .touchUpInside)
            .sink { [unowned self] _ in
                if self.viewModel.formType == .detail {
                    self.viewModel.formType = .edit
                } else {
                    self.viewModel.saveEdittedData()
                    self.viewModel.formType = .detail
                }
                
                self.editAndSaveButton.setTitle(self.viewModel.formType == .detail ? "Edit" : "Save", for: .normal)
            }.store(in: &disposables)
        
        viewModel
            .$maintenanceDate
            .sink { [unowned self] value in
                self.dateField.setDateText(value)
            }.store(in: &disposables)
        
        viewModel
            .$qrNumber
            .sink { [unowned self] value in
                self.qrField.setInputButtonTitle("\(value)")
            }.store(in: &disposables)
        
        viewModel
            .$images
            .sink { [unowned self] value in
                self.setupSnapshot()
            }.store(in: &disposables)
        
        viewModel
            .$formType
            .sink { [unowned self] value in
                let enabled = value == .edit
                self.nameField.isFieldEnabled(enabled)
                self.typeField.isFieldEnabled(enabled)
                self.dateField.isFieldEnabled(enabled)
            }.store(in: &disposables)
    }
    
    private func setupSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.images)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension DataDetailVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: ImageCell.PREFERRED_HEIGHT_AND_WIDTH, height: ImageCell.PREFERRED_HEIGHT_AND_WIDTH)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.showImagePreviewModal(forImageAt: indexPath.row)
    }
}
