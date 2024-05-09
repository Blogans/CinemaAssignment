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
            Text("Booking Process")
            NavigationLink(value: BookingStep.step1) {
                Text("Proceed to Step 1")
            }
        }
        .navigationDestination(for: BookingStep.self) { step in
            switch step {
                case .step1:
                    BookingStep1View(movie: movie)
                case .step2:
                    BookingStep2View(movie: movie)
                case .step3:
                    BookingStep3View(movie: movie)
                case .confirmation:
                    BookingConfirmationView(movie: movie)
            }
        }
    }
}

enum BookingStep {
    case step1, step2, step3, confirmation
}

struct BookingStep1View: View {
    let movie: Movie
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        VStack {
            Text("Booking Step 1")
            Button("Proceed to Step 2") {
                navigationModel.path.append(BookingStep.step2)
            }
        }
    }
}

struct BookingStep2View: View {
    let movie: Movie
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        VStack {
            Text("Booking Step 2")
            Button("Proceed to Step 3") {
                navigationModel.path.append(BookingStep.step3)
            }
        }
    }
}

struct BookingStep3View: View {
    let movie: Movie
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        VStack {
            Text("Booking Step 3")
            Button("Confirm Booking") {
                navigationModel.path.append(BookingStep.confirmation)
            }
        }
    }
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
