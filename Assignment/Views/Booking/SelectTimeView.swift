//
//  SelectTimeView.swift
//  Assignment
//
//  Created by Cameron on 9/5/2024.
//

import Foundation
import SwiftUI

struct TimeSlot: Identifiable, Equatable, Hashable, Encodable, Decodable {
    var id = UUID()
    let time: String
}

let availableTimeslots: [TimeSlot] = [
    TimeSlot(time: "10:00 AM"),
    TimeSlot(time: "12:30 PM"),
    TimeSlot(time: "3:00 PM"),
    TimeSlot(time: "6:30 PM"),
    TimeSlot(time: "9:00 PM")
]


struct BookingStep1View: View {
    let movie: Movie
    @EnvironmentObject var navigationModel: NavigationModel
    
    @State private var selectedDate = Date()
    @State private var selectedTime: TimeSlot? = nil
    @State private var countdownTime: TimeInterval = 10000 // 10 minutes in seconds
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var isNextButtonDisabled: Bool {
        selectedTime == nil || Calendar.current.startOfDay(for: selectedDate) < Calendar.current.startOfDay(for: Date())
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 15) {
                    DateSelectionView(selectedDate: $selectedDate)
                    TimeSelectionView(selectedTime: $selectedTime, availableTimeslots: availableTimeslots)
                }
                .padding(.horizontal)
            }
            
            BookingDetailsSubView(movie: movie, date: selectedDate, time: selectedTime?.time, selectedSeats: [])
                .padding(.horizontal)
            
            Button(action: {
                if let selectedTime = selectedTime {
                    navigationModel.path.append(BookingStep.step2(selectedDate, selectedTime))
                }
            }) {
                Text("Next Step")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isNextButtonDisabled ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(isNextButtonDisabled)
            .padding()
        }
        .navigationBarTitle("Book Tickets", displayMode: .inline)
    }
}

struct DateSelectionView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            Text("Select Date")
                .font(.headline)
                .fontWeight(.semibold)
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .accentColor(.blue)
                .labelsHidden() // Hide the default date labels
                .padding(.horizontal)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
        }
    }
}

struct TimeSelectionView: View {
    @Binding var selectedTime: TimeSlot?
    let availableTimeslots: [TimeSlot]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Time")
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .center) // Center the text
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(availableTimeslots) { timeslot in
                        Button(action: {
                            selectedTime = timeslot
                        }) {
                            Text(timeslot.time)
                                .font(.subheadline)
                                .foregroundColor(selectedTime == timeslot ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedTime == timeslot ? Color.blue : Color(.secondarySystemBackground))
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
}


struct BookingDetailsSubView: View {
    let movie: Movie
    let date: Date?
    let time: String?
    let selectedSeats: Set<Seat>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 20) {
                Image(movie.poster)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 110)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Booking Details")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    if let date = date, let time = time {
                        Text("Date: \(date, style: .date)")
                        Text("Time: \(time)")
                    } else {
                        Text("No date and time selected")
                    }
                    
                    Text("Movie: \(movie.name)")
                    
                    SelectedSeatsView(selectedSeats: selectedSeats)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct SelectedSeatsView: View {
    let selectedSeats: Set<Seat>
    
    var body: some View {
        if !selectedSeats.isEmpty {
            HStack {
                ForEach(selectedSeats.sorted(by: { $0.row < $1.row || ($0.row == $1.row && $0.number < $1.number) }), id: \.self) { seat in
                    Text("\(seat.row)\(seat.number)")
                        .font(.subheadline)
                        .padding(4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                }
            }
        }
    }
}


struct BookingStep1View_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BookingStep1View(movie: Movie(name: "Shrek 2", poster: "shrek2", genres: ["Comedy", "Animation", "Family"]))
                .environmentObject(NavigationModel())
        }
    }
}

