//
//  FeaturedMovieView.swift
//  Assignment
//
//  Created by Cameron on 8/5/2024.
//

import Foundation
import SwiftUI

struct FeaturedMovieView: View {
    let movie: Movie
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(movie.poster)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 200)
                .cornerRadius(20)
            
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(20)
            
            VStack(alignment: .leading) {
                Text(movie.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Book Now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
