//
//  SelectSeatView.swift
//  Assignment
//
//  Created by Cameron on 11/5/2024.
//

import Foundation
import SwiftUI

struct BookingStep3View: View {
    let movie: Movie
    let selectedDate: Date
    let selectedTime: TimeSlot
    let adultSeats: Int
    let childSeats: Int
    let concessionSeats: Int
    let bedSeats: Int
    
    @EnvironmentObject var bookingHistory: BookingHistory
    @EnvironmentObject var navigationModel: NavigationModel
    
    @State private var selectedSeats: Set<Seat> = []
    
    var totalSeatsToSelect: Int {
        adultSeats + childSeats + concessionSeats + bedSeats
    }
    
    //Gets all seats based on existing seat selections within matching bookings
    var reservedSeats: Set<Seat> {
        let existingBookings = bookingHistory.bookings.filter { booking in
            booking.movie == movie &&
            Calendar.current.isDate(booking.date, inSameDayAs: selectedDate) &&
            booking.time == selectedTime
        }
        
        return Set(existingBookings.flatMap { $0.seats })
    }
    
    var body: some View {
        VStack() {
            //Label to show direction of seat facing
            Text("Front of Cinema")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.top)
            
            //Displays the seat selection UI view
            SeatSelectionView(selectedSeats: $selectedSeats, reservedSeats: reservedSeats, totalSeatsToSelect: totalSeatsToSelect)
                .padding(.horizontal)
            
            //VStack for displaying the information about the seat selection process
            VStack {
                Text("Selected: \(selectedSeats.count)/\(totalSeatsToSelect)")
                    .font(.headline)
                    .foregroundColor(.blue)
                                
                LegendView()
                
                Spacer()
            }
            .padding(.vertical)
            
            Spacer()
            
            //Existing booking sub view from previous views showing the current booking details as the user selects things
            BookingDetailsSubView(movie: movie, date: selectedDate, time: selectedTime.time, selectedSeats: selectedSeats)
                .padding(.horizontal)
            
            //Button for transferring to confirmation view
            Button(action: {
                if selectedSeats.count == totalSeatsToSelect {
                    //If all seats have been selected, a booking is created and saved.
                    let newBooking = Booking(movie: movie,
                                             date: selectedDate,
                                             time: selectedTime,
                                             seats: Array(selectedSeats),
                                             active: true)
                    bookingHistory.addBooking(newBooking)
                    
                    navigationModel.path.append(BookingStep.confirmation)
                }
            }) {
                Text("Confirm")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedSeats.count == totalSeatsToSelect ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            //Disabled until the user selects all the required seats
            .disabled(selectedSeats.count != totalSeatsToSelect)
            .padding()
        }
        .navigationBarTitle("Book Tickets", displayMode: .inline)
    }
}

struct SeatSelectionView: View {
    @Binding var selectedSeats: Set<Seat>
    let reservedSeats: Set<Seat>
    let totalSeatsToSelect: Int
    
    let rows = ["A", "B", "C", "D", "E", "F"]
    let columns = Array(1...9)
    
    var body: some View {
        //VStack for handling the contents of the complete view
        VStack(alignment: .center, spacing: 8) {
            //VStack for handling the seat selection UI
            VStack(spacing: 8) {
                ForEach(rows, id: \.self) { row in
                    HStack(spacing: 8) {
                        Text(row)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        
                        ForEach(columns, id: \.self) { column in
                            SeatToggleView(seat: Seat(row: row, number: column),
                                           isSelected: selectedSeats.contains(Seat(row: row, number: column)),
                                           isReserved: reservedSeats.contains(Seat(row: row, number: column)))
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                toggleSeat(Seat(row: row, number: column))
                            }
                        }
                    }
                }
            }
            //Add labels to the bottom of the UI for columns
            HStack(spacing: 8) {
                Spacer()
                Spacer()
                Spacer()
                ForEach(columns, id: \.self) { column in
                    Text("\(column)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .frame(width: 30)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    //Function for handling seat presses
    private func toggleSeat(_ seat: Seat) {
        if selectedSeats.contains(seat) {
            selectedSeats.remove(seat)
        } else if selectedSeats.count < totalSeatsToSelect && !reservedSeats.contains(seat) {
            selectedSeats.insert(seat)
        }
    }
}

//Object to represent each individual seat
//Subject to change in favor of a seat icon with different colors rather than boxes
struct SeatToggleView: View {
    let seat: Seat
    let isSelected: Bool
    let isReserved: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(isReserved ? Color.red : isSelected ? Color.green : Color.gray.opacity(0.5))
    }
}

//Legend view to display information about each seat availability type
struct LegendView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.green)
                    .frame(width: 20, height: 20)
                Text("Available")
                    .font(.subheadline)
            }
            
            HStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.red)
                    .frame(width: 20, height: 20)
                Text("Reserved")
                    .font(.subheadline)
            }
        }
    }
}
