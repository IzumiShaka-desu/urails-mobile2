//
//  Step.swift
//  iosApp
//
//  Created by Akashaka on 11/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import SwiftUI
struct Step: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let time: String? = nil
    let color: Color
}
