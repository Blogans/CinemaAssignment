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
    
    @State private var searchText = ""
    @State private var selectedGenres: Set<String> = []
    
    var filteredMovies: [Movie] {
        var filteredMovies = movieData.movies
        
        if !searchText.isEmpty {
            filteredMovies = filteredMovies.filter { movie in
                movie.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        if !selectedGenres.isEmpty {
            filteredMovies = filteredMovies.filter { movie in
                let movieGenresSet = Set(movie.genres)
                return !selectedGenres.isDisjoint(with: movieGenresSet)
            }
        }
        
        return filteredMovies
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    SearchBar(text: $searchText, placeholder: "Search movies")
                        .padding(.horizontal)
                    
                    GenreFilters(selectedGenres: $selectedGenres)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                        ForEach(filteredMovies) { movie in
                            NavigationLink(value: movie) {
                                MoviePosterView(movie: movie)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Movies")
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .foregroundColor(.primary)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct GenreFilters: View {
    @Binding var selectedGenres: Set<String>
    
    let genres = ["Action", "Comedy", "Drama", "Romance", "Sci-Fi"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button(action: {
                    selectedGenres.removeAll()
                }) {
                    Text("All")
                        .font(.subheadline)
                        .foregroundColor(selectedGenres.isEmpty ? .white : .primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedGenres.isEmpty ? Color.blue : Color(.secondarySystemBackground))
                        .cornerRadius(16)
                }
                
                ForEach(genres, id: \.self) { genre in
                    Button(action: {
                        if selectedGenres.contains(genre) {
                            selectedGenres.remove(genre)
                        } else {
                            selectedGenres.insert(genre)
                        }
                    }) {
                        Text(genre)
                            .font(.subheadline)
                            .foregroundColor(selectedGenres.contains(genre) ? .white : .primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedGenres.contains(genre) ? Color.blue : Color(.secondarySystemBackground))
                            .cornerRadius(16)
                    }
                }
            }
        }
    }
}

struct MoviePosterView: View {
    let movie: Movie
    
    var body: some View {
        VStack(spacing: 8) {
            Image(movie.poster)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 225)
                .clipped()
                .cornerRadius(12) // Add this line to apply rounded corners
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 4) {
                Spacer()
                
                Text(movie.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: 40)
                
                Spacer()
            }
            .padding(.horizontal, 8)
        }
    }
}
