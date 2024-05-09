//
//  MovieData.swift
//  Assignment
//
//  Created by Cameron on 8/5/2024.
//

import Foundation

struct Movie: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let poster: String
    let genres: [String]
    
    init(name: String, poster: String, genres: [String]) {
        self.name = name
        self.poster = poster
        self.genres = genres
    }
}

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
            Movie(name: "Shrek 2", poster: "shrek2", genres: ["Comedy", "Animation", "Family"]),
            Movie(name: "Avengers Endgame", poster: "endgame", genres: ["Action", "Adventure", "Sci-Fi"]),
            Movie(name: "Barbie", poster: "barbie", genres: ["Comedy", "Family"]),
            Movie(name: "Spider-Man Across the Spider-Verse", poster: "spiderman", genres: ["Action", "Animation", "Adventure", "Sci-Fi"]),
            Movie(name: "Deadpool", poster: "deadpool", genres: ["Action", "Comedy", "Adventure"])
        ]
        
        movies.append(contentsOf: sampleMovies)
        saveMovies()
    }
}

