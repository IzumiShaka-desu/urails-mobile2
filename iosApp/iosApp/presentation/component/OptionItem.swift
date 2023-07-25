//
//  OptionItem.swift
//  iosApp
//
//  Created by Akashaka on 11/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct OptionItem: View {
    var titleKey: String
    var isSelected: Bool
    var onTapGesture: (String) -> Void
    var body: some View {
        HStack(spacing: 4) {
//          Image.init(systemName: systemImage).font(.body)
            Text(titleKey).font(.body).lineLimit(1)
        }
        .padding(.vertical, 4)
        .padding(.leading, 4)
        .padding(.trailing, 10)
        .foregroundColor(isSelected ? .white : .blue)
        .background(isSelected ? Color.blue : Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 1.5)

        ).onTapGesture {
            onTapGesture(titleKey)
        }
    }
}

struct OptionItem_Previews: PreviewProvider {
    static var previews: some View {
        OptionItem(titleKey: "title", isSelected: true, onTapGesture: { _ in

        })
    }
}
