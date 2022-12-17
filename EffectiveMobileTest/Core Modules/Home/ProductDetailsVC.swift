//
//  ProductDetailsVC.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 15.12.2022.
//

import UIKit

protocol ProductDetailsVCProtocol: AnyObject {
    func receiveData(for viewModel: ProductDetailsModel?)
}

final class ProductDetailsVC: UIViewController {
    
    public var presenter: ProductDetailsPresenterProtocol!
    private var viewModel: ProductDetailsModel! {
        didSet {
            imageBannerCollectionView.setupSubviews(with: viewModel)
            detailsView.setupSubviews(with: viewModel)
        }
    }
    
    // MARK: - Subviews
    
    private let statusBarView = UIView()
    private let navBarView = NavBarView()
    private let imageBannerCollectionView = ImageBannerCollectionView()
    private let detailsView = DetailsView()
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        toggleTabBarAppearance()
    }
}

// MARK: - Setups

private extension ProductDetailsVC {
    func setupVC() {
        view.backgroundColor = R.Color.background
        statusBarView.backgroundColor = R.Color.background
        addGesture()
    }
    
    func addSubviews() {
        [
            statusBarView,
            navBarView,
            imageBannerCollectionView,
            detailsView
        ].forEach { view.addSubview($0) }
    }
    
    func setupSubviews() {
        navBarView.delegate = self
        imageBannerCollectionView.delegate = self
        detailsView.delegate = self
    }
    
    func hideNavBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func toggleTabBarAppearance() {
        presenter.toggleTabBarAppearance()
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeViewsWhenTapAround))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Actions

extension ProductDetailsVC: ProductDetailsVCProtocol {
    @objc func closeViewsWhenTapAround(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func receiveData(for viewModel: ProductDetailsModel?) {
        self.viewModel = viewModel
    }
}

// MARK: - Nav Bar Delegate

extension ProductDetailsVC: NavBarViewProtocol {
    func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapBasket() {
        print(#function)
    }
}

// MARK: - ImageBanner Collection Delegate

extension ProductDetailsVC: ImageBannerCollectionViewProtocol {
    func imageBannerRequest(for indexPath: IndexPath) -> String {
        presenter.imageBannerRequest(for: indexPath)
    }
    
    func getImageBannerCount() -> Int {
        presenter.getImageBannerCount()
    }
}

// MARK: - Details View Delegate

extension ProductDetailsVC: DetailsViewProtocol {
    func colorRequest(for indexPath: IndexPath) -> String {
        presenter.colorRequest(for: indexPath)
    }
    
    func getColorCount() -> Int {
        presenter.getColorCount()
    }
    
    func capacityRequest(for indexPath: IndexPath) -> String {
        presenter.capacityRequest(for: indexPath)
    }
    
    func getCapacityCount() -> Int {
        presenter.getCapacityCount()
    }
    
    func didTapFavorite() {
        viewModel.isFavorites = !viewModel.isFavorites
    }
}

// MARK: - Constants

private extension ProductDetailsVC {
    typealias C = Constants
    
    enum Constants {
        static let navBarTop: CGFloat = 35
        static let navBarHeight: CGFloat = 37
        static let imageBannerTop: CGFloat = 14
        static let imageBannerBottom: CGFloat = -14
        static let detailsViewHeight: CGFloat = 449
    }
}

// MARK: - Layout

private extension ProductDetailsVC {
    func setupLayout() {
        [
            statusBarView,
            navBarView,
            imageBannerCollectionView,
            detailsView
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
            
            imageBannerCollectionView.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: C.imageBannerTop),
            imageBannerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageBannerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageBannerCollectionView.bottomAnchor.constraint(equalTo: detailsView.topAnchor, constant: C.imageBannerBottom),
            
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsView.heightAnchor.constraint(equalToConstant: C.detailsViewHeight),
            detailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
