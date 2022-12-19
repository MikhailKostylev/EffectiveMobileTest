//
//  CartTableView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 19.12.2022.
//

import UIKit

protocol CartTableViewProtocol: AnyObject {
    func didTapMinus(at indexPath: IndexPath)
    func didTapPlus(at indexPath: IndexPath)
    func didTapDelete(at indexPath: IndexPath)
}

final class CartTableView: UIView {
    
    public weak var delegate: CartTableViewProtocol?
    
    public var viewModel: CartModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Subviews
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = R.Color.night
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        addSubviews()
        setupTableView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension CartTableView {
    func setup() {
        backgroundColor = R.Color.night
        layer.cornerRadius = C.selfCornerRadius
        layer.shadowOffset = CGSize(width: .zero, height: C.selfShadowOffsetHeight)
        layer.shadowColor = R.Color.cartTableViewShadow.cgColor
        layer.shadowRadius = C.selfShadowRadius
        layer.shadowOpacity = 1
        clipsToBounds = true
    }
    
    func addSubviews() {
        addSubview(tableView)
    }
    
    func setupTableView() {
        tableView.tableHeaderView = createTableHeader()
        tableView.rowHeight = C.cellHeight
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.id)
    }
    
    func createTableHeader() -> UIView {
        let view = UIView(
            frame: CGRect(
                x: .zero,
                y: .zero,
                width: R.Screen.size.width,
                height: C.headerHeight
            )
        )
        view.backgroundColor = R.Color.night
        return view
    }
}

// MARK: - Public

extension CartTableView {
    public func countDidChange(at indexPath: IndexPath, with newValue: Int) {
        viewModel?.basket[indexPath.row].count = newValue
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - TableView DataSource / Delegate

extension CartTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.basket.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.id, for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.viewModel = viewModel?.basket[indexPath.row]
        return cell
    }
}

// MARK: - Cell Delegate

extension CartTableView: CartTableViewCellProtocol {
    func didTapMinus(at cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            delegate?.didTapMinus(at: indexPath)
        }
    }
    
    func didTapPlus(at cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            delegate?.didTapPlus(at: indexPath)
        }
    }
    
    func didTapDelete(at cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            delegate?.didTapDelete(at: indexPath)
        }
    }
}

// MARK: - Constants

private extension CartTableView {
    typealias C = Constants
    
    enum Constants {
        static let selfCornerRadius: CGFloat = 30
        static let selfShadowOffsetHeight: CGFloat = -5
        static let selfShadowRadius: CGFloat = 20
        static let headerHeight: CGFloat = 80
        static let cellHeight: CGFloat = 134
    }
}

// MARK: - Layout

private extension CartTableView {
    func setupLayout() {
        tableView.prepareForAutoLayout()
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
