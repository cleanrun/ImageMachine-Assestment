//
//  DataDetailView.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import UIKit
import Combine

final class DataDetailView: BaseVC, DataDetailPresenterToViewProtocol {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, ImageModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ImageModel>
    
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
    
    private var dataSource: DataSource!
    var presenter: DataDetailViewToPresenterProtocol!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoadFired()
    }
    
    override func loadView() {
        super.loadView()
        super.setupUI()
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
        
        imagesCollectionView.delegate = self
        imagesCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.REUSABLE_IDENTIFIER)
        dataSource = DataSource(collectionView: imagesCollectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.REUSABLE_IDENTIFIER, for: indexPath) as! ImageCell
            cell.setImageModel(item)
            cell.delegate = self
            return cell
        })
    }
    
    override func setupBindings() {
        nameField
            .textFieldPublisher
            .sink { [unowned self] value in
                self.presenter.setName(value)
            }.store(in: &disposables)
        
        typeField
            .textFieldPublisher
            .sink { [unowned self] value in
                self.presenter.setType(value)
            }.store(in: &disposables)
        
        dateInputView
            .publisher(for: .valueChanged)
            .sink { [unowned self] value in
                self.presenter.setMaintenanceDate(self.dateInputView.date)
            }.store(in: &disposables)
        
        editAndSaveButton
            .publisher(for: .touchUpInside)
            .sink { [unowned self] _ in
                if self.presenter.getCurrentFormType() == .detail {
                    self.presenter.editData()
                } else {
                    self.presenter.saveEdittedData()
                }
            }.store(in: &disposables)
    }
    
    func setFieldsInitialValue(_ model: MachineModel) {
        nameField.setDefaultTextFieldText(model.name)
        typeField.setDefaultTextFieldText(model.type)
        dateField.setDateText(model.maintenanceDate)
    }
    
    func observeFields(formType: AnyPublisher<DetailFormType, Never>,
                       name: AnyPublisher<String?, Never>,
                       type: AnyPublisher<String?, Never>,
                       qrNumber: AnyPublisher<Int?, Never>,
                       maintenanceDate: AnyPublisher<Date?, Never>,
                       images: AnyPublisher<[ImageModel], Never>) {
        maintenanceDate
            .receive(on: RunLoop.main)
            .sink { [unowned self] value in
                if let value {
                    self.dateField.setDateText(value)
                }
            }.store(in: &disposables)
        
        qrNumber
            .receive(on: RunLoop.main)
            .sink { [unowned self] value in
                if let value {
                    self.qrField.setInputButtonTitle("\(value)")
                }
            }.store(in: &disposables)
        
        images
            .receive(on: RunLoop.main)
            .sink { [unowned self] value in
                self.setupSnapshot(value)
            }.store(in: &disposables)
        
        formType
            .receive(on: RunLoop.main)
            .sink { [unowned self] value in
                let enabled = value == .edit
                self.nameField.isFieldEnabled(enabled)
                self.typeField.isFieldEnabled(enabled)
                self.dateField.isFieldEnabled(enabled)
                self.toggleDeleteButtonOnCell(enabled)
                self.editAndSaveButton.setTitle(value == .detail ? "Edit" : "Save", for: .normal)
                value == .edit ? self.dismissKeyboardWhenViewIsTapped() : self.removeKeyboardDismissHandler()
                
            }.store(in: &disposables)
    }
    
    private func setupSnapshot(_ images: [ImageModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(images)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func toggleDeleteButtonOnCell(_ enabled: Bool) {
        for (index, _) in presenter.getImages().enumerated() {
            if let cell = imagesCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? ImageCell {
                cell.enableDeleteButton(enabled)
            }
        }
    }
}

extension DataDetailView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: ImageCell.PREFERRED_HEIGHT_AND_WIDTH, height: ImageCell.PREFERRED_HEIGHT_AND_WIDTH)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter.showImagePreviewModal(presenter.getImage(index: indexPath.row))
    }
}

extension DataDetailView: ImageCellDelegate {
    func onDelete(for model: ImageModel) {
        presenter.deleteImage(model)
    }
    
}
