//
//  Station+Extensions.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/12/23.
//

import Foundation
import GoogleMaps
import RealmSwift

extension StationItem {
    var asMarker: GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
        marker.title = self.displayName
        marker.snippet = self.address
        let color = UIColor.init(hexString: customer?.markerColor ?? "#ffffff")
        if let _imageView = MarkerViewManager.shared.stationImage(withIdentifier: "station_\(self.number ?? "")") {
            _imageView.set(price: self.actualPriceInfo)
            _imageView.set(name: "№" + (self.number ?? "-"))
            _imageView.set(
                url: .init(string: self.customer?.iconUrl ?? ""),
                placeholder: UIImage(named: "icon_gas_station"), backgroundColor: color
            )
            marker.iconView = _imageView
            marker.iconView?.frame.size = .init(width: 64, height: 48)
        }
        
        marker.station = self
        return marker
    }
}

extension GMSMarker: Identifiable {
    public var id: String {
        "\(self.position.latitude)-\(self.position.longitude)"
    }
    
    var station: StationItem? {
        set(station) {
            self.userData = station
        }
        
        get {
            self.userData as? StationItem
        }
    }
    
    var hasStation: Bool {
        station != nil
    }
}

extension StationItem {
    var trustedDiscountPrice: Float {
        self.discountPrice ?? 0
    }
    
    public var priceUpdateDate: Date? {
        guard let priceUpdated = self.priceUpdated else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = Date.serverFormat
        return formatter.date(from: priceUpdated)
    }
    
    public var priceUpdateInfo: String {
        guard let date = priceUpdateDate else { return "" }
        return date.toString(format: "MM/dd/yyyy HH:mm:ss")
    }
}


extension StationItem {
    var clLocation: CLLocation {
        .init(latitude: lat, longitude: lng)
    }
}
