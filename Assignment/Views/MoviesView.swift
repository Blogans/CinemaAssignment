//
//  MoviesView.swift
//  Assignment
//
//  Created by Cameron on 8/5/2024.
//

import Foundation
import SwiftUI

struct MoviesView: View {
    @EnvironmentObject var movieData: MovieData
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(movieData.movies) { movie in
                    Button(action: {
                        navigationModel.path.append(movie)
                    }) {
                        VStack {
                            Image(movie.poster)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                            Text(movie.name)
                        }
                    }
                }
            }
        }
    }
}
