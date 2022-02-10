//
//  Cafeteria.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 17.12.21.
//

import Foundation
import MapKit

struct Location: Decodable, Hashable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String

    var coordinate: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
}

struct Queue: Decodable, Hashable {
    let current: Int
    let percent: Float
}

struct Time: Decodable, Hashable{
    let hours: Int
    let minutes: Int
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        let parts = stringValue.components(separatedBy: ":")
        self.hours =  Int(parts[0]) ?? 0
        self.minutes =  Int(parts[1]) ?? 0
    }
}

struct OpenHoursDay: Decodable, Hashable{
    let start: Time
    let end: Time
}

struct OpenHoursWeek: Decodable, Hashable {
    let mon: OpenHoursDay
    let tue: OpenHoursDay
    let wed: OpenHoursDay
    let thu: OpenHoursDay
    let fri: OpenHoursDay
}

struct Cafeteria: Decodable, Hashable {
    /*
     "location": {
        "address": "Arcisstraße 17, München",
        "latitude": 48.147420,
        "longitude": 11.567220
     },
     "name": "Mensa Arcisstraße",
     "canteen_id": "mensa-arcisstr"
     },
 */
    let location: Location
    var name: String
    let id: String
    
    let queueStatusApi: String?
    var queue: Queue?

    var coordinate: CLLocationCoordinate2D { location.coordinate }
    var title: String? { name }
    
    let openHours: OpenHoursWeek?

    enum CodingKeys: String, CodingKey {
        case location
        case name
        case id = "canteen_id"
        case queueStatusApi = "queue_status"
        case queue
        case openHours = "open_hours"
    }
    
}

extension Array where Element == Cafeteria {
    mutating func sortByDistance(to location: CLLocation) {
        self.sort { (lhs,rhs) in
            let lhsDistance = lhs.coordinate.location.distance(from: location)
            let rhsDistance = rhs.coordinate.location.distance(from: location)
            return lhsDistance < rhsDistance
        }
    }
}
