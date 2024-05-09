//
//  MovieData.swift
//  Assignment
//
//  Created by Cameron on 8/5/2024.
//

import Foundation

import Foundation

class MovieData: ObservableObject {
    @Published var movies: [Movie] = []
    
    private let saveKey = "MovieData"
    
    init() {
        clearMovies()
        loadMovies()
        if movies.isEmpty {
            createSampleMovies()
        }
    }
    
    func clearMovies() {
        movies.removeAll()
        UserDefaults.standard.removeObject(forKey: saveKey)
    }
    
    func addMovie(_ movie: Movie) {
        movies.append(movie)
        saveMovies()
    }
    
    func updateMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            saveMovies()
        }
    }
    
    func deleteMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies.remove(at: index)
            saveMovies()
        }
    }
    
    private func saveMovies() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(movies) {
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        }
    }
    
    private func loadMovies() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            let decoder = JSONDecoder()
            if let decodedMovies = try? decoder.decode([Movie].self, from: data) {
                movies = decodedMovies
            }
        }
    }
    
    private func createSampleMovies() {
        let sampleMovies = [
            Movie(name: "Shrek 2", poster: "shrek2"),
            Movie(name: "Avengers Endgame", poster: "endgame"),
            Movie(name: "Barbie", poster: "barbie"),
            Movie(name: "Spider-Man Across the Spider-Verse", poster: "spiderman"),
            Movie(name: "Deadpool", poster: "deadpool")
        ]
        
        movies.append(contentsOf: sampleMovies)
        saveMovies()
    }
}

