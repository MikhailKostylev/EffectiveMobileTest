//
//  Resources.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 04.12.2022.
//

import UIKit

typealias R = Resources

enum Resources {
    
    // MARK: - Color
    
    enum Color {
        static let peach = UIColor(named: "peach")
        static let night = UIColor(named: "night")
        static let gold = UIColor(named: "gold")
        static let wood = UIColor(named: "wood")
        static let text = UIColor(named: "text")
        static let grayIcon = UIColor(named: "grayIcon")
        static let grayText = UIColor(named: "grayText")
        static let grayBorder = UIColor(named: "grayBorder")!
        static let grayBackground = UIColor(named: "grayBackground")!
        static let tabButtonGray = UIColor(named: "tabButtonGray")!
        static let discountPrice = UIColor(named: "discountPrice")!
        static let placeholder = UIColor(named: "placeholder")!
        static let background = UIColor(named: "background")!
        static let categoryShadow = UIColor(named: "selectCategoryShadow")!
        static let searchFieldShadow = UIColor(named: "searchFieldShadow")!
        static let filtersViewShadow = UIColor(named: "filtersViewShadow")!
        static let bestSellerShadow = UIColor(named: "bestSellerShadow")!
        static let favoriteShadow = UIColor(named: "favoriteShadow")!
        static let imageBannerCellShadowRadius = UIColor(named: "imageBannerCellShadowRadius")!
        static let bigDivider = UIColor(named: "bigDivider")!
        static let divider = UIColor(named: "divider")!
        static let cartTableViewShadow = UIColor(named: "cartTableViewShadow")!
        static let cartCellBackground = UIColor(named: "cartCellBackground")!
    }
    
    // MARK: - Image
    
    enum Image {
        static let ellipse = UIImage(named: "ellipse")!
        static let mockImage = UIImage(systemName: "photo.stack.fill")!
        
        enum TabBar {
            static let explorer = UIImage(named: "explorer")!
            static let basket = UIImage(named: "basket")!
            static let favorite = UIImage(named: "favorite")!
            static let profile = UIImage(named: "profile")!
            static let selected = UIImage(named: "selected")!
        }
        
        enum Home {
            static let geoPin = UIImage(named: "geoPin")!
            static let downArrow = UIImage(named: "downArrow")!
            static let filter = UIImage(named: "filter")!
            static let phones = UIImage(named: "phones")!
            static let computer = UIImage(named: "computer")!
            static let health = UIImage(named: "health")!
            static let books = UIImage(named: "books")!
            static let products = UIImage(named: "products")!
            static let magnifier = UIImage(named: "magnifier")!
            static let qr = UIImage(named: "qr")!
            static let close = UIImage(named: "close")!
            static let downArrowBig = UIImage(named: "downArrowBig")!
            static let heart = UIImage(named: "heart")!
            static let heartFill = UIImage(named: "heart.fill")!
            
            static let leftArrow = UIImage(named: "leftArrow")!
            static let productBasket = UIImage(named: "productBasket")!
            static let productLike = UIImage(named: "productLike")!
            static let star = UIImage(named: "star")!
            static let cpu = UIImage(named: "cpu")!
            static let camera = UIImage(named: "camera")!
            static let memory = UIImage(named: "memory")!
            static let storage = UIImage(named: "storage")!
            static let like = UIImage(systemName: "heart")!
            static let likeFill = UIImage(systemName: "heart.fill")!
            static let check = UIImage(named: "check")!
            
            static let locationPin = UIImage(named: "locationPin")!
            static let trash = UIImage(named: "trash")!
        }
    }
    
    // MARK: - Text
    
    enum Text {
        enum Home {
            static let locationTitle = "Zihuatanejo, Gro"
            static let category = "Select Category"
            static let hotSales = "Hot Sales"
            static let bestSeller = "Best Seller"
            static let viewAll = "view all"
            static let seeMore = "see more"
            static let phones = "Phones"
            static let computer = "Computer"
            static let health = "Health"
            static let books = "Books"
            static let products = "Products"
            static let searchPlaceholder = "Search"
            static let explorer = "Explorer"
            static let done = "Done"
            static let filterOptions = "Filter options"
            static let brand = "Brand"
            static let price = "Price"
            static let size = "Size"
            static let newLabel = "New"
            static let buyNow = "Buy now!"
            
            static let productDetails = "Product Details"
            static let addToCart = "Add to Cart"
            static let shop = "Shop"
            static let details = "Details"
            static let features = "Features"
            static let selection = "Select color and capacity"
            
            static let addAddress = "Add address"
            static let myCart = "My Cart"
            static let total = "Total"
            static let delivery = "Delivery"
            static let checkout = "Checkout"
            static let minus = "-"
            static let plus = "+"
        }
        
        enum Basket {
            static let basket = "Basket"
            static let empty = "Your basket is empty"
        }
        
        enum Favorites {
            static let favorites = "Favorites"
            static let empty = "Your favorites are empty"
        }
        
        enum Profile {
            static let profile = "Profile"
        }
        
        enum Url {
            static let homeStoreProducts = "https://run.mocky.io/v3/654bd15e-b121-49ba-a588-960956b15175"
            static let productDetails = "https://run.mocky.io/v3/6c14c560-15c6-4248-b9d2-b4508df7d4f5"
            static let cart = "https://run.mocky.io/v3/53539a72-3c5f-4f30-bbb1-6ca10d42c149"
            static let profile = "https://github.com/MikhailKostylev"
        }
        
        enum NotificationKey {
            static let tabBarAppearance = "tabBarAppearance"
            static let tabBarGoHome = "tabBarGoHome"
            static let tabBarCounter = "tabBarCounter"
        }
    }
    
    // MARK: - Font
    
    enum Font {
        case light
        case regular
        case medium
        case bold
        
        static func markPro(type: Self, size: CGFloat) -> UIFont {
            var fontName = ""
            
            switch type {
            case .light:
                fontName = "DSLCLU+MarkPro-Light"
            case .regular:
                fontName = "MarkPro-Regular"
            case .medium:
                fontName = "MarkPro-Medium"
            case .bold:
                fontName = "MarkPro-Bold"
            }
            
            return UIFont(name: fontName, size: size)!
        }
    }
    
    enum Screen {
        static let size: CGRect = UIScreen.main.bounds
        static var statusBarHeight: CGFloat {
            UIApplication.shared.statusBarFrame.height
        }
    }
}
