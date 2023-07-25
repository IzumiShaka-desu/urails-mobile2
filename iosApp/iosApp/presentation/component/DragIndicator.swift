//
//  DragIndicator.swift
//  iosApp
//
//  Created by Akashaka on 03/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct DragIndicator: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .foregroundColor(Color.gray.opacity(0.6))
    }
}

struct DragIndicator_Previews: PreviewProvider {
    static var previews: some View {
        DragIndicator()
    }
}
