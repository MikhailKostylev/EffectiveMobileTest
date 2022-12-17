//
//  HomeStoreVC.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 02.12.2022.
//

import UIKit

protocol HomeStoreVCProtocol: AnyObject {
    func setLocation(with location: String)
    func updateCategories()
    func updateHotSales()
    func updateBestSeller()
    func toggleFilterViewAppearance()
}

final class HomeStoreVC: UIViewController {
    
    // MARK: - Properties
    
    public var presenter: HomeStorePresenter!
    
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(
            width: view.width,
            height: C.scrollContentHeight
        )
        return scrollView
    }()
    
    private let statusBarView = UIView()
    private let contentView = UIView()
    private let locationFilterView = LocationFilterView()
    private let categoryHeader = HeaderView(type: .selectCategory)
    private let categoryCollectionView = CategoryCollectionView()
    private let searchView = SearchView()
    private let hotSalesHeader = HeaderView(type: .hotSales)
    private let hotSalesCollectionView = HotSalesCollectionView()
    private let bestSellerHeader = HeaderView(type: .bestSeller)
    private let bestSellerCollectionView = BestSellerCollectionView()
    private let filterOptionsView = FilterOptionsView()
    
    private var filerOptionsViewHeightConstraint: NSLayoutConstraint!
    
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
    }
}

// MARK: - Setups

private extension HomeStoreVC {
    func setupVC() {
        view.backgroundColor = R.Color.background
        statusBarView.backgroundColor = R.Color.background
        addGesture()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            locationFilterView,
            categoryHeader,
            categoryCollectionView,
            searchView,
            hotSalesHeader,
            hotSalesCollectionView,
            bestSellerHeader,
            bestSellerCollectionView,
            filterOptionsView,
            statusBarView
            
        ].forEach { contentView.addSubview($0) }
    }
    
    func setupSubviews() {
        locationFilterView.delegate = self
        categoryHeader.delegate = self
        categoryCollectionView.delegate = self
        searchView.delegate = self
        hotSalesHeader.delegate = self
        hotSalesCollectionView.delegate = self
        bestSellerHeader.delegate = self
        bestSellerCollectionView.delegate = self
        filterOptionsView.delegate = self
    }
    
    func hideNavBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeViewsWhenTapAround))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Actions

extension HomeStoreVC: HomeStoreVCProtocol {
    @objc func closeViewsWhenTapAround(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        guard filerOptionsViewHeightConstraint.constant != .zero  else { return }
        if !contentView.layer.contains(sender.location(in: filterOptionsView)) {
            didTapClose()
        }
    }
    
    func setLocation(with location: String) {
        locationFilterView.setLocation(with: location)
    }
    
    func updateCategories() {
        categoryCollectionView.reloadData()
    }
    
    func updateHotSales() {
        hotSalesCollectionView.reloadData()
    }
    
    func updateBestSeller() {
        bestSellerCollectionView.reloadData()
    }
    
    func toggleFilterViewAppearance() {
        filerOptionsViewHeightConstraint.constant = filterOptionsView.height == .zero ?
        C.filterOptionsViewHeight : .zero
        
        contentView.subviews.forEach {
            if $0 != filterOptionsView {
                $0.isUserInteractionEnabled = !$0.isUserInteractionEnabled
            }
        }
        
        UIView.animate(
            withDuration: C.animationDuration,
            delay: .zero,
            usingSpringWithDamping: C.animationDamping,
            initialSpringVelocity: C.animationVelocity,
            options: .curveEaseOut
        ) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Location/Filter Delegate

extension HomeStoreVC: LocationFilterViewProtocol {
    func didTapLocation() {
        presenter.getLocation()
    }
    
    func didTapFilter() {
        presenter.toggleFilterOptionsAppearance()
        filterOptionsView.getFilterData()
    }
}

// MARK: - Headers Delegate

extension HomeStoreVC: HeaderViewProtocol {
    func didTapRightButton(with type: HeaderType) {
        switch type {
        case .selectCategory:
            print(type)
        case .hotSales:
            print(type)
        case .bestSeller:
            print(type)
        }
    }
}

// MARK: - Category Delegate

extension HomeStoreVC: CategoryCollectionViewProtocol {
    func categoryRequest(for indexPath: IndexPath) -> CategoryCellViewModelProtocol {
        presenter.categoryRequest(for: indexPath)
    }
    
    func getCategoryItemCount() -> Int {
        return presenter.categoryItemCount()
    }
    
    func didTapCell(with indexPath: IndexPath) {
        presenter.didTapCategoryCell(at: indexPath)
    }
}

// MARK: - SearchView Delegate

extension HomeStoreVC: SearchViewDelegate {
    func didTypeSearchField(with text: String) {
        print(text)
    }
    
    func didTapQRButton() {
        print(#function)
    }
}

// MARK: - Hot Sales Delegate

extension HomeStoreVC: HotSalesCollectionViewProtocol {
    func hotSalesRequest(for indexPath: IndexPath) -> HomeStore? {
        presenter.hotSalesRequest(for: indexPath)
    }
    
    func getHotSalesItemCount() -> Int {
        return presenter.hotSalesItemCount()
    }
}

// MARK: - Best Seller Delegate

extension HomeStoreVC: BestSellerCollectionViewProtocol {
    func bestSellerRequest(for indexPath: IndexPath) -> BestSeller? {
        presenter.bestSellerRequest(for: indexPath)
    }
    
    func getBestSellerItemCount() -> Int {
        presenter.bestSellerItemCount()
    }
    
    func didTapBestSeller(at itemID: Int) {
        let productDetailsVC = Assembly.configureProductDetailsModule(itemID: itemID)
        navigationController?.pushViewController(productDetailsVC, animated: true)
    }
}

// MARK: - FilterOptionsView Delegate

extension HomeStoreVC: FilterOptionsViewProtocol {
    func didTapClose() {
        presenter.toggleFilterOptionsAppearance()
    }
    
    func didTapDone() {
        presenter.toggleFilterOptionsAppearance()
    }
    
    func itemsRequest(for pickerType: PickerViewType) -> [String] {
        switch pickerType {
            
        case .brand:
            return presenter.getBrands()
        case .price:
            return presenter.getPrices()
        case .size:
            return presenter.getSizes()
        }
    }
}

// MARK: - Constants

private extension HomeStoreVC {
    typealias C = Constants
    
    enum Constants {
        static let animationDuration: Double = 0.5
        static let animationDamping: CGFloat = 0.7
        static let animationVelocity: CGFloat = 1
        static let scrollContentHeight: CGFloat = 1114
        static let locationFilterViewHeight: CGFloat = 19
        static let locationFilterViewTop: CGFloat = 20
        static let headerHeight: CGFloat = 32
        static let categoryHeaderTop: CGFloat = 18
        static let categoryCollectionTop: CGFloat = 4
        static let categoryCollectionHeight: CGFloat = 113
        static let searchViewTop: CGFloat = 15
        static let searchViewHeight: CGFloat = 74
        static let hotSalesHeaderTop: CGFloat = 4
        static let filterOptionsViewHeight: CGFloat = 375
        static let hotSalesCollectionTop: CGFloat = 8
        static let hotSalesCollectionHeight: CGFloat = 183
        static let bestSellerHeaderTop: CGFloat = 11
        static let bestSellerCollectionHeight: CGFloat = 504
    }
}

// MARK: - Layout

private extension HomeStoreVC {
    func setupLayout() {
        [
            statusBarView,
            scrollView,
            contentView,
            locationFilterView,
            categoryHeader,
            categoryCollectionView,
            searchView,
            hotSalesHeader,
            hotSalesCollectionView,
            bestSellerHeader,
            bestSellerCollectionView,
            filterOptionsView
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusBarView.widthAnchor.constraint(equalTo: view.widthAnchor),
            statusBarView.heightAnchor.constraint(equalToConstant: R.Screen.statusBarHeight),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: C.scrollContentHeight),

            locationFilterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: C.locationFilterViewTop),
            locationFilterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationFilterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            locationFilterView.heightAnchor.constraint(equalToConstant: C.locationFilterViewHeight),
            
            categoryHeader.topAnchor.constraint(equalTo: locationFilterView.bottomAnchor, constant: C.categoryHeaderTop),
            categoryHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryHeader.heightAnchor.constraint(equalToConstant: C.headerHeight),
            
            categoryCollectionView.topAnchor.constraint(equalTo: categoryHeader.bottomAnchor, constant: C.categoryCollectionTop),
            categoryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: C.categoryCollectionHeight),
            
            searchView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: C.searchViewTop),
            searchView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            searchView.heightAnchor.constraint(equalToConstant: C.searchViewHeight),
            
            hotSalesHeader.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: C.hotSalesHeaderTop),
            hotSalesHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hotSalesHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hotSalesHeader.heightAnchor.constraint(equalToConstant: C.headerHeight),
            
            hotSalesCollectionView.topAnchor.constraint(equalTo: hotSalesHeader.bottomAnchor, constant: C.hotSalesCollectionTop),
            hotSalesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hotSalesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hotSalesCollectionView.heightAnchor.constraint(equalToConstant: C.hotSalesCollectionHeight),
            
            bestSellerHeader.topAnchor.constraint(equalTo: hotSalesCollectionView.bottomAnchor, constant: C.bestSellerHeaderTop),
            bestSellerHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bestSellerHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bestSellerHeader.heightAnchor.constraint(equalToConstant: C.headerHeight),
            
            bestSellerCollectionView.topAnchor.constraint(equalTo: bestSellerHeader.bottomAnchor),
            bestSellerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bestSellerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bestSellerCollectionView.heightAnchor.constraint(equalToConstant: C.bestSellerCollectionHeight),
            
            filterOptionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filterOptionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            filterOptionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        filerOptionsViewHeightConstraint = filterOptionsView.heightAnchor.constraint(equalToConstant: .zero)
        filerOptionsViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate(constraints)
    }
}
