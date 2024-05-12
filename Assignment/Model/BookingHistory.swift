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
    var id = UUID()
    let movie: Movie
    let date: Date
    let time: TimeSlot
    let seats: [Seat]
    var active: Bool
}

class BookingHistory: ObservableObject {
    @Published var bookings: [Booking] = []
    private let saveKey = "BookingHistory"
    var movieData: MovieData
    
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
            Booking(movie: movies[0], date: dateFormatter.date(from: "2024-05-13")!, time: availableTimeslots[1], seats: [Seat(row: "A", number: 1), Seat(row: "A", number: 2)], active: true),
            Booking(movie: movies[1], date: dateFormatter.date(from: "2024-05-14")!, time: availableTimeslots[2], seats: [Seat(row: "B", number: 3), Seat(row: "B", number: 4)], active: true),
            Booking(movie: movies[2], date: dateFormatter.date(from: "2024-05-15")!, time: availableTimeslots[3], seats: [Seat(row: "C", number: 5), Seat(row: "C", number: 6)], active: true),
            Booking(movie: movies[3], date: dateFormatter.date(from: "2024-05-16")!, time: availableTimeslots[0], seats: [Seat(row: "D", number: 7), Seat(row: "D", number: 8)], active: true),
            Booking(movie: movies[4], date: dateFormatter.date(from: "2024-05-17")!, time: availableTimeslots[1], seats: [Seat(row: "E", number: 4), Seat(row: "E", number: 5)], active: true),
            
            Booking(movie: movies[5], date: dateFormatter.date(from: "2024-05-18")!, time: availableTimeslots[2], seats: [Seat(row: "F", number: 1), Seat(row: "F", number: 2)], active: true),
            Booking(movie: movies[6], date: dateFormatter.date(from: "2024-05-19")!, time: availableTimeslots[3], seats: [Seat(row: "A", number: 3), Seat(row: "A", number: 4)], active: true),
            Booking(movie: movies[7], date: dateFormatter.date(from: "2024-05-20")!, time: availableTimeslots[0], seats: [Seat(row: "B", number: 5), Seat(row: "B", number: 6)], active: true),
            Booking(movie: movies[8], date: dateFormatter.date(from: "2024-05-21")!, time: availableTimeslots[1], seats: [Seat(row: "C", number: 7), Seat(row: "C", number: 8)], active: true),
            Booking(movie: movies[9], date: dateFormatter.date(from: "2024-05-22")!, time: availableTimeslots[2], seats: [Seat(row: "D", number: 1), Seat(row: "D", number: 2)], active: true),
            
            Booking(movie: movies[10], date: dateFormatter.date(from: "2024-05-23")!, time: availableTimeslots[3], seats: [Seat(row: "E", number: 3), Seat(row: "E", number: 4)], active: true),
            Booking(movie: movies[11], date: dateFormatter.date(from: "2024-05-13")!, time: availableTimeslots[0], seats: [Seat(row: "F", number: 5), Seat(row: "F", number: 6)], active: true),
            Booking(movie: movies[12], date: dateFormatter.date(from: "2024-05-14")!, time: availableTimeslots[1], seats: [Seat(row: "A", number: 7), Seat(row: "A", number: 8)], active: true),
            Booking(movie: movies[13], date: dateFormatter.date(from: "2024-05-15")!, time: availableTimeslots[2], seats: [Seat(row: "B", number: 1), Seat(row: "B", number: 2)], active: true),
            Booking(movie: movies[14], date: dateFormatter.date(from: "2024-05-16")!, time: availableTimeslots[3], seats: [Seat(row: "C", number: 3), Seat(row: "C", number: 4)], active: true)
        ]
        
        bookings.append(contentsOf: sampleBookings)
        saveBookings()
    }
}
