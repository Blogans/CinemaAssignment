//
//  BookingModel.swift
//  Assignment
//
//  Created by Cameron on 8/5/2024.
//

import Foundation
import SwiftUI

struct Seat: Codable, Hashable {
    let row: String
    let number: Int
}

struct Booking: Identifiable, Codable, Hashable {
    let id: UUID
    let movie: Movie
    let date: Date
    let seats: [Seat]
    var active: Bool
    
    init(movie: Movie, date: Date, seats: [Seat], active: Bool) {
        self.id = UUID()
        self.movie = movie
        self.date = date
        self.seats = seats
        self.active = active
    }
}

class BookingHistory: ObservableObject {
    @Published var bookings: [Booking] = []
    private let saveKey = "BookingHistory"
    private let movieData: MovieData
    
    init(movieData: MovieData) {
        self.movieData = movieData
        clearBookings()
        loadBookings()
        if bookings.isEmpty {
            createSampleBookings()
        }
    }
    
    func addBooking(_ booking: Booking) {
        bookings.append(booking)
        saveBookings()
    }
    
    func cancelBooking(_ booking: Booking) {
        if let index = bookings.firstIndex(where: { $0.id == booking.id }) {
            bookings[index].active = false
            saveBookings()
        }
    }
    
    private func saveBookings() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(bookings) {
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        }
    }
    
    private func loadBookings() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            let decoder = JSONDecoder()
            if let decodedBookings = try? decoder.decode([Booking].self, from: data) {
                bookings = decodedBookings
            }
        }
    }
    
    func clearBookings() {
        bookings.removeAll()
        UserDefaults.standard.removeObject(forKey: saveKey)
    }
    
    private func createSampleBookings() {
        let movies = movieData.movies
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let sampleBookings = [
            Booking(movie: movies[0], date: dateFormatter.date(from: "2024-05-08")!, seats: [Seat(row: "A", number: 1), Seat(row: "A", number: 2)], active: true),
            Booking(movie: movies[1], date: dateFormatter.date(from: "2024-05-09")!, seats: [Seat(row: "B", number: 3), Seat(row: "B", number: 4)], active: true),
            Booking(movie: movies[2], date: dateFormatter.date(from: "2024-05-10")!, seats: [Seat(row: "C", number: 5), Seat(row: "C", number: 6)], active: true),
            Booking(movie: movies[3], date: dateFormatter.date(from: "2024-05-11")!, seats: [Seat(row: "D", number: 7), Seat(row: "D", number: 8)], active: true),
            Booking(movie: movies[4], date: dateFormatter.date(from: "2024-05-12")!, seats: [Seat(row: "E", number: 9), Seat(row: "E", number: 10)], active: true)
        ]
        
        bookings.append(contentsOf: sampleBookings)
        saveBookings()
    }
}
