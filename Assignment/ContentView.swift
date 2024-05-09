import SwiftUI

class NavigationModel: ObservableObject {
    @Published var path = NavigationPath()
}

struct ContentView: View {
    @StateObject private var navigationModel = NavigationModel()
    @StateObject private var bookingHistory: BookingHistory
    @StateObject private var movieData = MovieData()
    
    init() {
        _bookingHistory = StateObject(wrappedValue: BookingHistory(movieData: MovieData()))
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                MoviesView()
                    .tabItem {
                        Image(systemName: "film")
                        Text("Movies")
                    }
                
                HistoryView()
                    .tabItem {
                        Image(systemName: "clock")
                        Text("History")
                    }
            }
            .navigationDestination(for: Movie.self) { movie in
                BookingProcessView(movie: movie)
            }
            .navigationDestination(for: Booking.self) { booking in
                BookingDetailsView(booking: booking)
            }
        }
        .environmentObject(movieData)
        .environmentObject(navigationModel)
        .environmentObject(bookingHistory)
    }
}
