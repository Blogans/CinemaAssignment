//
//  HistoryView.swift
//  Assignment
//
//  Created by Cameron on 8/5/2024.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var bookingHistory: BookingHistory
    @EnvironmentObject var navigationModel: NavigationModel
    
    @State private var searchText = ""
    @State private var selectedDate = Date()
    
    var filteredBookings: [Booking] {
        if searchText.isEmpty {
            return bookingHistory.bookings.filter { booking in
                Calendar.current.isDate(booking.date, inSameDayAs: selectedDate)
            }
        } else {
            let searchedBookings = bookingHistory.bookings.filter { booking in
                booking.movie.name.localizedCaseInsensitiveContains(searchText)
            }
            
            return searchedBookings.filter { booking in
                Calendar.current.isDate(booking.date, inSameDayAs: selectedDate)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Previous Bookings")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search by movie name", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            DatePicker("Filter by date", selection: $selectedDate, displayedComponents: [.date])
                .padding(.horizontal)
            
            List(filteredBookings) { booking in
                Button(action: {
                    navigationModel.path.append(booking)
                }) {
                    BookingCell(booking: booking)
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Booking History")
    }
}

struct BookingCell: View {
    let booking: Booking
    
    var body: some View {
        HStack {
            Image(booking.movie.poster)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(booking.movie.name)
                    .font(.headline)
                
                Text(booking.date, style: .date)
                    .foregroundColor(.gray)
            }
        }
    }
}
