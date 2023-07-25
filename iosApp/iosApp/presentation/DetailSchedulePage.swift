//
//  DetailSchedulePage.swift
//  iosApp
//
//  Created by Akashaka on 02/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import shared
import SwiftUI

struct DetailSchedulePage: View {
    @ObservedObject var viewModel = HomeObservableObject.shared
    var body: some View {
        ZStack {
            // Tampilkan loading dialog jika dalam keadaan loading
            if viewModel.detailScheduleState is AppStateLoading<DetailScheduleRaw> {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            if let detailSchedule = viewModel.detailScheduleState.data {
                DetailScheduleView(schedule: detailSchedule)
            }
            if viewModel.detailScheduleState is AppStateError<DetailScheduleRaw>, let errorMessage = viewModel.scheduleState.message {
                VStack {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Button(action: {
                                // Handle back button action
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.blue)
                            }

                            Text("Detail")
                                .font(.headline)

                            Spacer()
                        }
                    }.padding()
                    Spacer()
                    Text(errorMessage)
//                     .foregroundColor(.red)
                    Spacer()
                }
            }
        }
    }
}

struct DetailSchedulePage_Previews: PreviewProvider {
    static var previews: some View {
        DetailSchedulePage()
    }
}
