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
    
    var body: some View {
        VStack {
            BookingStep1View(movie: movie)
        }
        .navigationDestination(for: BookingStep.self) { step in
            switch step {
                case .step1:
                    BookingStep1View(movie: movie)
                case .step2(let date, let time):
                    BookingStep2View(movie: movie, selectedDate: date, selectedTime: time)
                case .step3(let int):
                    BookingStep3View(movie: movie, totalSeats: int)
                case .confirmation:
                    BookingConfirmationView(movie: movie)
            }
        }
    }
}

enum BookingStep: Hashable {
    case step1, step2(Date, TimeSlot), step3(Int), confirmation
}


struct BookingConfirmationView: View {
    let movie: Movie
    @EnvironmentObject var navigationModel: NavigationModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Booking Confirmation")
            Button("Go Home") {
                navigationModel.path = NavigationPath()
            }
        }
    }
}
