//
//  CartVC.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 18.12.2022.
//

import UIKit

protocol CartVCProtocol: AnyObject {
    func receiveData(for viewModel: CartModel)
    func setTotalResult(with price: Int)
    func setDeliveryResult(with text: String)
    func changeProductCount(at indexPath: IndexPath, with newValue: Int)
}

final class CartVC: UIViewController {
    
    public var presenter: CartPresenterProtocol!
    
    // MARK: - Subviews
    
    private let statusBarView = UIView()
    
    private let navBarView = CartNavBarView()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = R.Text.Home.myCart
        view.textColor = R.Color.night
        view.font = R.Font.markPro(type: .bold, size: C.titleLabelFontSize)
        return view
    }()
    
    private let cartTableView = CartTableView()
    
    private let totalResultView = TotalResultView()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        addSubviews()
        setupSubviews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
        toggleTabBarAppearance()
        presenter.fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        toggleTabBarAppearance()
    }
}

// MARK: - Setups

private extension CartVC {
    func setupVC() {
        view.backgroundColor = R.Color.background
        statusBarView.backgroundColor = R.Color.background
    }
    
    func addSubviews() {
        [
            statusBarView,
            navBarView,
            titleLabel,
            cartTableView,
            totalResultView
        ].forEach { view.addSubview($0) }
    }
    
    func setupSubviews() {
        navBarView.delegate = self
        cartTableView.delegate = self
        totalResultView.delegate = self
    }
    
    func hideNavBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func toggleTabBarAppearance() {
        presenter.toggleTabBarAppearance()
    }
}

//MARK: - CartVC Protocol

extension CartVC: CartVCProtocol {
    func receiveData(for viewModel: CartModel) {
        cartTableView.viewModel = viewModel
    }
    
    func setTotalResult(with price: Int) {
        totalResultView.setTotalResult(with: price)
    }
    
    func setDeliveryResult(with delivery: String) {
        totalResultView.setDeliveryResult(with: delivery)
    }
    
    func changeProductCount(at indexPath: IndexPath, with newValue: Int) {
        cartTableView.countDidChange(at: indexPath, with: newValue)
    }
}

// MARK: - Nav Bar Delegate

extension CartVC: CartNavBarViewProtocol {
    func didTapBack() {
        navigationController?.popViewController(animated: true)
        if navigationController == nil {
            NotificationCenter.default.post(
                name: NSNotification.Name(R.Text.NotificationKey.tabBarGoHome),
                object: nil
            )
        }
    }
    
    func didTapLocation() {
        print(#function)
    }
}

// MARK: - CartTableView Delegate

extension CartVC: CartTableViewProtocol {
    func didTapMinus(at indexPath: IndexPath) {
        presenter.didTapMinus(at: indexPath)
    }
    
    func didTapPlus(at indexPath: IndexPath) {
        presenter.didTapPlus(at: indexPath)
    }
    
    func didTapDelete(at indexPath: IndexPath) {
        presenter.didTapDelete(at: indexPath)
    }
}

// MARK: - TotalResultView Delegate

extension CartVC: TotalResultViewProtocol {
    func didTapCheckout() {
        print(#function)
    }
}

// MARK: - Constants

private extension CartVC {
    typealias C = Constants
    
    enum Constants {
        static let navBarTop: CGFloat = 35
        static let navBarHeight: CGFloat = 37
        static let titleLabelFontSize: CGFloat = 35
        static let tableViewBottom: CGFloat = 30
        
        static let titleLabelTop: CGFloat = 50
        static let titleLabelLeading: CGFloat = 42
        static let tableViewTop: CGFloat = 49
        static let totalResultViewHeight: CGFloat = 218
    }
}

// MARK: - Layout

private extension CartVC {
    func setupLayout() {
        [
            statusBarView,
            navBarView,
            titleLabel,
            cartTableView,
            totalResultView
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusBarView.widthAnchor.constraint(equalTo: view.widthAnchor),
            statusBarView.heightAnchor.constraint(equalToConstant: R.Screen.statusBarHeight),
            
            navBarView.topAnchor.constraint(equalTo: statusBarView.bottomAnchor, constant: C.navBarTop),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: C.navBarHeight),
            
            titleLabel.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: C.titleLabelTop),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: C.titleLabelLeading),
            
            cartTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: C.tableViewTop),
            cartTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartTableView.bottomAnchor.constraint(equalTo: totalResultView.topAnchor, constant: C.tableViewBottom),
            
            totalResultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalResultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalResultView.heightAnchor.constraint(equalToConstant: C.totalResultViewHeight),
            totalResultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
