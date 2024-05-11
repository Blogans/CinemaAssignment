//
//  HomeView.swift
//  Assignment
//
//  Created by Cameron on 8/5/2024.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var bookingHistory: BookingHistory
    @EnvironmentObject var movieData: MovieData
    
    var upcomingBookings: [Booking] {
        bookingHistory.bookings.filter { booking in
            booking.active && booking.date >= Date()
        }
    }
    
    var body: some View {
        VStack {
                // Title
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            if !upcomingBookings.isEmpty {
                    // Upcoming Tickets
                VStack {
                    Text("Upcoming Tickets")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(upcomingBookings) { booking in
                                NavigationLink(value: booking) {
                                    UpcomingTicketView(booking: booking)
                                }.environmentObject(bookingHistory)
                            }
                        }
                        .padding()
                    }
                }
            } else {
                    // Placeholder for Upcoming Tickets
                VStack(spacing: 16) {
                    Text("No Upcoming Tickets")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    Text("You don't have any upcoming movie bookings. Book your tickets now!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer() // Add a spacer to push the placeholder content to the top
                }
            }
            
            Spacer()
            
            BookingTipsView()
        }
    }
}
