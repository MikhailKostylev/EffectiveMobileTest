//
//  PickerViewPresenter.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 14.12.2022.
//

import UIKit

enum PickerViewType: CaseIterable {
    case brand
    case price
    case size
}

protocol PickerViewPresenterProtocol: AnyObject {
    func itemsRequest() -> [String]
}

class PickerViewPresenter: UITextField {
    
    weak var pickerDelegate: PickerViewPresenterProtocol?
    
    // MARK: - Properties
    
    public var didSelectItem: ((String) -> Void)?
    private var items: [String] = [] {
        didSet {
            clearSelectedItem()
            getSelectedItemName()
        }
    }
    private var selectedItem: String? {
        didSet {
            if let selectedItem = selectedItem {
                didSelectItem?(selectedItem)
            }
        }
    }
    
    // MARK: - Subviews
    
    private lazy var doneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: .zero, y: .zero, width: R.Screen.size.width, height: C.toolbarHeight))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapSelect))
        toolbar.items = [flexSpace, closeButton]
        toolbar.sizeToFit()
        return toolbar
    }()
    
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = R.Color.background
        pickerView.tintColor = R.Color.night
        return pickerView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setup()
        setupSubviews()
        getItems()
        getSelectedItemName()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Constants

private extension PickerViewPresenter {
    typealias C = Constants
    
    enum Constants {
        static let toolbarHeight: CGFloat = 50
    }
}

// MARK: - Public

extension PickerViewPresenter {
    public func showPicker() {
        becomeFirstResponder()
    }
    
    public func getItems() {
        items.removeAll()
        guard let items = pickerDelegate?.itemsRequest() else { return }
        self.items = items
    }
}

// MARK: - Setups

private extension PickerViewPresenter {
    func setup() {
        inputView = pickerView
        inputAccessoryView = doneToolbar
        backgroundColor = R.Color.background
    }
    
    func setupSubviews() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func getSelectedItemName() {
        if let firstItem = items.first {
            didSelectItem?(firstItem)
        } else {
            guard let selectedItem = selectedItem else { return }
            didSelectItem?(selectedItem)
        }
    }
    
    func clearSelectedItem() {
        pickerView.selectRow(.zero, inComponent: .zero, animated: false)
    }
}

// MARK: - Actions

private extension PickerViewPresenter {
    @objc func didTapSelect() {
        if let selectedItem = selectedItem {
            didSelectItem?(selectedItem)
        }
        resignFirstResponder()
    }
}

// MARK: - Picket DataSource / Delegate

extension PickerViewPresenter: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = items[row]
    }
}
