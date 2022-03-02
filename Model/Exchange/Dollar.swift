//
//  Dollar.swift
//  Baluchon
//
//  Created by Mohammad Olwan on 01/02/2022.
//

import Foundation

struct Dollar: Decodable {
    var base: String
    var date: String
    var rates: [String: Double]
}
