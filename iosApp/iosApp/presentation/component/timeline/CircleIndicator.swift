//
//  CircleIndicator.swift
//  iosApp
//
//  Created by Akashaka on 06/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct CircleIndicator: View {
    let status: TimelineStatus
    var body: some View {
        switch status {
        case .active:
            ZStack {
                Circle()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.blue)
                Circle()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                Circle()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.blue)
            }.frame(width: 24, height: 24)
        case .future:
            ZStack {
                Circle()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.blue)
                Circle()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                Circle()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
            }.frame(width: 24, height: 24)
        case .past:
            ZStack {
                Circle()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.blue)
                Circle()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.blue)
                Circle()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.blue)
            }.frame(width: 24, height: 24)
        }
    }
}

struct CircleIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CircleIndicator(status: .past)
            CircleIndicator(status: .active)
            CircleIndicator(status: .future)
        }
    }
}
