import shared
import SwiftUI

struct ContentView: View {
    // 	let greet = Greeting().greet()
    @Environment(\.colorScheme) var colorScheme
    @State var text: String = ""
    @ObservedObject var viewModel = HomeObservableObject.shared
    var body: some View {
        ZStack {
            NavigationView {
                TabView {
                    ZStack(alignment: .top) {
                        Color.flatDarkBackground.ignoresSafeArea()
                        RouteFinderView().padding(.bottom, 16)
//            TestTimelineJir().padding(.bottom,16)
                    }.tabItem {
                        Label("Navigation", systemImage: "location")
                    }
                    ZStack {
                        Color.flatDarkBackground.ignoresSafeArea()
                        ScheduleView()
                            .padding(.bottom, 16)
                    }.tabItem {
                        Image(systemName: "list.bullet")
                        Text("Schedule")
                    }.frame(maxWidth: .infinity)
                    ZStack {
                        Color.flatDarkBackground.ignoresSafeArea()
                        VStack {
                            MapTabView(graphState: $viewModel.graphState)
                        }.padding(.bottom, 16)
                    }.tabItem {
                        Image(systemName: "map")
                        Text("map")
                    }
                }
            }.accentColor(Color.flatWhiteBackground)
                .navigationTitle("URail")
                .navigationBarTitleDisplayMode(.inline)

                .toolbar {
                    //          ToolbarItem(placement: .navigationBarTrailing) {
                    //            NavigationLink(destination: AboutView(), label: {
                    //              HStack {
                    //                Image(systemName: "info.circle").imageScale(.medium)
                    //                Text("About")
                    //              }
                    //
                    //            }
                    //            ).navigationTitle("back")
                    //          }

                    //        }
                    //      }

                }.preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
