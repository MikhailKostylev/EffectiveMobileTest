//
//  LocationService.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 08.12.2022.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func bindLocation(with listener: @escaping (String?) -> Void)
}

final class LocationService: NSObject, LocationServiceProtocol {
    
    // MARK: - Properties
    
    private var locationManager: CLLocationManager?
    private var geocoder: CLGeocoder?
    
    private var locationListener: ((String?) -> Void)?
    private var currentLocation: String? {
        didSet {
            locationListener?(currentLocation)
        }
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
        setup()
        start()
    }
}

// MARK: - Public

extension LocationService {
    public func bindLocation(with listener: @escaping (String?) -> Void) {
        locationListener = listener
        listener(currentLocation)
    }
}

// MARK: - Private

private extension LocationService {
    func setup() {
        locationManager = CLLocationManager()
        geocoder = CLGeocoder()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func start() {
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func convert(location: CLLocation) {
        geocoder?.reverseGeocodeLocation(location) { place, _ in
            guard let city = place?.first?.locality else { return }
            self.currentLocation = city
        }
    }
}

// MARK: - Location Manager Delegate

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        convert(location: location)
        locationManager?.stopUpdatingLocation()
    }
}
