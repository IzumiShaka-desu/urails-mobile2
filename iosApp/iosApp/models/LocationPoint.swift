//
//  LocationPoint.swift
//  iosApp
//
//  Created by Akashaka on 09/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
struct LocationPoint: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    let placeName: String
}
