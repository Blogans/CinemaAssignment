//
//  UpcomingTicketView.swift
//  Assignment
//
//  Created by Cameron on 8/5/2024.
//

import Foundation
import SwiftUI

struct UpcomingTicketView: View {
    let booking: Booking
    
    var body: some View {
        VStack {
            Image(booking.movie.poster)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 180)
                .cornerRadius(10)
            
            Text(booking.movie.name)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 120)
            
            Text(booking.date, style: .date)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
