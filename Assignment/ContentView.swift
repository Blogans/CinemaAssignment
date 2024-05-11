import SwiftUI

class NavigationModel: ObservableObject {
    @Published var path = NavigationPath()
}

struct ContentView: View {
    @StateObject private var navigationModel = NavigationModel()
    @StateObject private var movieData = MovieData()
    @StateObject private var bookingHistory: BookingHistory
    
    init() {
        let movieDataInstance = MovieData()
        _movieData = StateObject(wrappedValue: movieDataInstance)
        _bookingHistory = StateObject(wrappedValue: BookingHistory(movieData: movieDataInstance))
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .environmentObject(bookingHistory)
                
                MoviesView()
                    .tabItem {
                        Image(systemName: "film")
                        Text("Movies")
                    }
                    .environmentObject(movieData)
                
                HistoryView()
                    .tabItem {
                        Image(systemName: "clock")
                        Text("History")
                    }
                    .environmentObject(bookingHistory)
            }
            .navigationDestination(for: Movie.self) { movie in
                BookingProcessView(movie: movie).environmentObject(bookingHistory)
            }
            .navigationDestination(for: Booking.self) { booking in
                BookingDetailsView(booking: booking).environmentObject(bookingHistory)
            }
        }
        .environmentObject(navigationModel)
    }
}
