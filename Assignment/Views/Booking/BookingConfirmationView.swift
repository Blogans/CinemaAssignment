//
//  BookingConfirmationView.swift
//  Assignment
//
//  Created by Nicolas Chang Sing on 12/5/2024.
//

import SwiftUI

struct BookingConfirmationView: View {
    let movie: Movie
    let selectedDate: Date
    let selectedTime: TimeSlot
    let selectedSeats: Set<Seat>
    @EnvironmentObject var navigationModel: NavigationModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var bookingHistory: BookingHistory
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                    // Movie Poster
                Image(movie.poster)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top)
                
                    // Movie Name
                Text(movie.name)
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
                        Text(selectedDate, style: .date)
                            .font(.headline)
                        
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text(selectedTime.time)
                            .font(.headline)
                    }
                    
                        // Booked Seats
                    HStack {
                        Image(systemName: "ticket")
                            .foregroundColor(.gray)
                        Text("Seats:")
                            .font(.headline)
                        
                        ForEach(Array(selectedSeats), id: \.self) { seat in
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
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                    // Continue Button
                
                    Button(action: {
                        // adds new booking
                        let newBooking = Booking(movie: movie,
                                                 date: selectedDate,
                                                 time: selectedTime,
                                                 seats: Array(selectedSeats),
                                                 active: true)
                        bookingHistory.addBooking(newBooking)
                        
                        navigationModel.path = NavigationPath()
                    }) {
                        Text("Confirm Booking")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .navigationBarTitle("Book Tickets", displayMode: .inline)
    }
}

