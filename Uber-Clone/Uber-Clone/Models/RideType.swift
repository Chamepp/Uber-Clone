//
//  RideType.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 3/11/23.
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable {
    case uber_x
    case uber_black
    case uber_xl
    
    var id: Int { return rawValue }
    
    var descirption: String {
        switch self {
            case .uber_x: return "UberX"
            case .uber_black: return "UberBlack"
            case .uber_xl: return "UberXL"
        }
    }
    
    var image_name: String {
        switch self {
            case .uber_x: return "uber-x"
            case .uber_black: return "uber-black"
            case .uber_xl: return "uber-x"
        }
    }
    
    var base_fare: Double {
        switch self {
            case .uber_x: return 5
            case .uber_black: return 20
            case .uber_xl: return 10
        }
    }
    
    
    func compute_price(for distance_in_meters: Double) -> Double {
        let distance_in_miles = distance_in_meters / 1600
        
        switch self {
            case .uber_x: return distance_in_miles * 1.5 + base_fare
            case .uber_black: return distance_in_miles * 2.0 + base_fare
            case .uber_xl: return distance_in_miles * 1.75 + base_fare
        }
    }
    
}
