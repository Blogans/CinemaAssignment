//
//  BookingTipsView.swift
//  Assignment
//
//  Created by Cameron on 9/5/2024.
//

import Foundation
import SwiftUI

struct BookingTipsView: View {
    @State private var tips: [TipItem] = [
        TipItem(title: "Book Early", description: "Book your tickets well in advance to get the best seats and avoid last minute rush."),
        TipItem(title: "Check Movie Times", description: "Always check the movie times carefully before booking to ensure you're selecting the correct date and time."),
        TipItem(title: "Arrive Early", description: "Arrive at the theater at least 15-20 minutes before the show to find your seats and get settled."),
        TipItem(title: "Snacks and Drinks", description: "You can bring your own snacks and drinks to the theater, or purchase them at the food stand."),
        TipItem(title: "Cancellations", description: "You can cancel your booking up to 2 hours before the movie time and receive a full refund.")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 16) {
                Text("Booking Tips")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                List {
                    ForEach(tips) { tip in
                        ExpandableTipView(tip: tip)
                            .listRowBackground(Color(.secondarySystemBackground))
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
            }
        }
    }
}

struct ExpandableTipView: View {
    @State private var isExpanded: Bool = false
    let tip: TipItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(tip.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 1)
            }
            
            if isExpanded {
                Text(tip.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading, 16)
                    .padding(.bottom, 8)
            }
        }
    }
}

struct TipItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

struct BookingTipsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingTipsView()
    }
}
