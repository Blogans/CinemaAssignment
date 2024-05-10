//
//  SelectSeatAmountView.swift
//  Assignment
//
//  Created by Cameron on 9/5/2024.
//

import Foundation
import SwiftUI

struct BookingStep2View: View {
    let movie: Movie
    @EnvironmentObject var navigationModel: NavigationModel
    
    @State private var adultSeats: Int = 0
    @State private var childSeats: Int = 0
    @State private var concessionSeats: Int = 0
    @State private var bedSeats: Int = 0
    let selectedDate: Date
    let selectedTime: TimeSlot
    
    var totalSeats: Int {
        adultSeats + childSeats + concessionSeats + bedSeats
    }
    
    var body: some View {
        VStack {
            SeatInfoView()
            
            SeatSelectionView(adultSeats: $adultSeats,
                              childSeats: $childSeats,
                              concessionSeats: $concessionSeats,
                              bedSeats: $bedSeats)
            
            Spacer()
            
            BookingDetailsSubView(movie: movie, date: selectedDate, time: selectedTime.time)
                .padding(.horizontal)
            
            Button(action: {
                if totalSeats > 0 {
                    navigationModel.path.append(BookingStep.step3(totalSeats))
                }
            }) {
                Text("Next Step")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(totalSeats == 0 ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(totalSeats == 0)
            .padding()
        }
        .navigationBarTitle("Book Tickets", displayMode: .inline)
    }
}

struct SeatInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Seat Type Information")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Adult Seats")
                            .font(.headline)
                    }
                    Text("Seats for adults aged 18 and above.")
                        .font(.subheadline)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Child Seats")
                            .font(.headline)
                    }
                    Text("Seats for children aged 3 to 17.")
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Concession Seats")
                            .font(.headline)
                    }
                    Text("For seniors 66 and above or students with valid ID.")
                        .font(.subheadline)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Bed Seats")
                            .font(.headline)
                    }
                    Text("Luxury seats with a bed-like design.")
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct SeatSelectionView: View {
    @Binding var adultSeats: Int
    @Binding var childSeats: Int
    @Binding var concessionSeats: Int
    @Binding var bedSeats: Int
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Select Seats")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                SeatTypeRow(seatType: "Adult", seatCount: $adultSeats)
                SeatTypeRow(seatType: "Child", seatCount: $childSeats)
                SeatTypeRow(seatType: "Concession", seatCount: $concessionSeats)
                SeatTypeRow(seatType: "Bed", seatCount: $bedSeats)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct SeatTypeRow: View {
    let seatType: String
    @Binding var seatCount: Int
    
    var body: some View {
        HStack {            
            Text(seatType)
                .font(.headline)
            
            Spacer()
            
            HStack {
                Button(action: {
                    if seatCount > 0 {
                        seatCount -= 1
                    }
                }) {
                    Image(systemName: "minus.circle")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                Text("\(seatCount)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, seatCount < 10 ? 12 : 8)
                
                Button(action: {
                    seatCount += 1
                }) {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

