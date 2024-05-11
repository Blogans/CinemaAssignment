//
//  BookingDetailsView.swift
//  Assignment
//
//  Created by Cameron on 8/5/2024.
//

import Foundation
import SwiftUI

struct BookingDetailsView: View {
    @State private var booking: Booking
    @EnvironmentObject var bookingHistory: BookingHistory
    @State private var showCancelConfirmation = false
    
    init(booking: Booking) {
        _booking = State(initialValue: booking)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                    // Movie Poster
                Image(booking.movie.poster)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top)
                
                    // Movie Name
                Text(booking.movie.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                    // Booking Details
                VStack(spacing: 10) {
                        // Booking Date and Time
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        Text(booking.date, style: .date)
                            .font(.headline)
                        
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text(booking.time.time)
                            .font(.headline)
                    }
                    
                        // Booked Seats
                    HStack {
                        Image(systemName: "ticket")
                            .foregroundColor(.gray)
                        Text("Seats:")
                            .font(.headline)
                        
                        ForEach(booking.seats, id: \.self) { seat in
                            Text("\(seat.row)\(seat.number)")
                                .font(.subheadline)
                                .padding(5)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                
                if booking.active {
                        // Barcode for Active Booking
                    Image(systemName: "barcode")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                } else {
                        // Cancellation Message for Inactive Booking
                    Text("Cancelled")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                
                    // Cancel Button for Future Active Bookings
                if booking.date > Date() && booking.active {
                    Button(action: {
                        showCancelConfirmation = true
                    }) {
                        Text("Cancel Booking")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $showCancelConfirmation) {
                        Alert(
                            title: Text("Cancel Booking"),
                            message: Text("Are you sure you want to cancel this booking?"),
                            primaryButton: .destructive(Text("Cancel Booking")) {
                                bookingHistory.cancelBooking(booking)
                                updateBooking()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .navigationBarTitle("Booking Details", displayMode: .inline)
        .onAppear {
            updateBooking()
        }
    }
    
    private func updateBooking() {
        if let updatedBooking = bookingHistory.bookings.first(where: { $0.id == booking.id }) {
            booking = updatedBooking
        }
    }
}
