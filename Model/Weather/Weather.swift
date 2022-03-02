//
//  WeatherStruct.swift
//  Baluchon
//
//  Created by Mohammad Olwan on 07/02/2022.
//

import Foundation

struct Weather: Equatable {
    var title: String
    var description: String
    var pressure: Double?
    var humidity: Double?
    var temperature: Double?
}
