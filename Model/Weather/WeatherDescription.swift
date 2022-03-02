//
//  WeatherDescription.swift
//  Baluchon
//
//  Created by Mohammad Olwan on 20/02/2022.
//

import Foundation

struct WeatherDescription {
    var title: String
    var details: String
}

extension WeatherDescription: Decodable {
    
    private enum Key: String, CodingKey {
        case title = "main"
        case details = "description"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.details = try container.decode(String.self, forKey: .details)
    }
}
