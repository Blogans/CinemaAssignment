//
//  BookingProcess.swift
//  Assignment
//
//  Created by Cameron on 8/5/2024.
//

import Foundation
import SwiftUI

struct BookingProcessView: View {
    let movie: Movie
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var bookingHistory: BookingHistory

    var body: some View {
        VStack {
            BookingStep1View(movie: movie)
        }
        .navigationDestination(for: BookingStep.self) { step in
            switch step {
                case .step1:
                    BookingStep1View(movie: movie).environmentObject(bookingHistory)
                case .step2(let date, let time):
                    BookingStep2View(movie: movie, selectedDate: date, selectedTime: time).environmentObject(bookingHistory)
                case .step3(let date, let time, let adultSeats, let childSeats, let concessionSeats, let bedSeats):
                    BookingStep3View(movie: movie,
                                     selectedDate: date,
                                     selectedTime: time,
                                     adultSeats: adultSeats,
                                     childSeats: childSeats,
                                     concessionSeats: concessionSeats,
                                     bedSeats: bedSeats).environmentObject(bookingHistory)
                case .confirmation(let date, let time, let seats):
                BookingConfirmationView(movie: movie, selectedDate: date, selectedTime: time, selectedSeats: seats).environmentObject(bookingHistory)
            }
        }
    }
}

enum BookingStep: Hashable {
    case step1, step2(Date, TimeSlot), step3(Date, TimeSlot, Int, Int, Int, Int), confirmation(Date, TimeSlot, Set<Seat>)
}
