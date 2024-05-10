//
//  SelectSeatAmountView.swift
//  Assignment
//
//  Created by Nicolas Chang Sing on 11/5/2024.
//

import Foundation
import SwiftUI

struct BookingStep3View: View {
   let movie: Movie
    let totalSeats: Int
    @EnvironmentObject var navigationModel: NavigationModel
    @State private var selectedSeatsAmount: Int = 0
    var selectedSeats: [Seat] = []

    var body: some View {

        VStack{
            createBedRow()
        }

        VStack{
            Button(action: {
                if selectedSeatsAmount == totalSeats {
                    navigationModel.path.append(BookingStep.confirmation)
                }
            }) {Text("Confirm Booking")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedSeatsAmount != totalSeats ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(selectedSeatsAmount != totalSeats)
            .padding()
        }
            .navigationBarTitle("Books Tickets", displayMode: .inline)
    }

    func createBedRow() -> some View {

            let rows: Int = 1
            let numbersPerRow: Int = 5

            return

                VStack {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack{
                            if var selectedSeats = selectedSeats as? [Seat]{
                                ForEach(0..<numbersPerRow, id: \.self){ number in
                                    SeatView(seat: Seat(id: UUID(), row: "A", number: number + 1) , onSelect: { seat in
                                        selectedSeats.append(seat)
                                        selectedSeatsAmount = selectedSeatsAmount + 1
                                    }, onDeselect: { seat in
                                        selectedSeats.removeAll(where: {$0.id == seat.id})
                                        selectedSeatsAmount = selectedSeatsAmount - 1
                                    })
                                }
                            }
                        }
                    }
            }
        }
}


struct SeatView: View {
    var seatColor : Color = .blue
    @State private var isSelected = false
    var seat: Seat
    var isSelectable = true
    var onSelect: ((Seat)->()) = { in }
    var onDeselect: ((Seat)->()) = { in }

    var body: some View{
        Rectangle()
            .frame(width: 30, height: 30)
            .foregroundColor(isSelectable ? isSelected ? seatColor : Color.gray.opacity(0.5) : seatColor)
            .cornerRadius(10)
            .onTapGesture {
                if self.isSelectable{
                    self.isSelected.toggle()
                    if self.isSelected{
                        self.onSelect(self.seat)
                    } else {
                        self.onDeselect(self.seat)
                    }
                }
            }
    }
}