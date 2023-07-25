//
//  MapsImageView.swift
//  iosApp
//
//  Created by Akashaka on 07/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI

struct MapsImageView: View {
    @State private var imageSize: CGSize = .zero

    var body: some View {
        GeometryReader { proxy in
            WebImage(
                url: URL(string: "https://raw.githubusercontent.com/IzumiShaka-desu/gif_host/main/ce5f644e204ee3c8f90cae078a9fb7e1.png"
                )
            )
            .resizable()
            .onSuccess(perform: { _, _, _ in
                DispatchQueue.main.async {
                    self.imageSize = CGSize(
                        width: proxy.size.width,
                        height: proxy.size.height
                    )
                }
            })
            .indicator(.activity)
            .scaledToFit()
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipShape(Rectangle())
            .modifier(ImageModifier(contentSize: imageSize))
        }
    }
}

struct MapsImageView_Previews: PreviewProvider {
    static var previews: some View {
        MapsImageView()
    }
}
