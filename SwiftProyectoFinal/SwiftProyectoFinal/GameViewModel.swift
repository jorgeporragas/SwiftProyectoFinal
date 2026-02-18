//
//  GameViewModel.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 18/02/26.
//

import SwiftUI
import Combine

// 1. Modelo: Qué es un usuario
struct User: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var highScore: Int = 0
}

// 2. ViewModel: El cerebro que maneja los datos
class GameViewModel: ObservableObject {
    // @Published avisa a la vista cuando los datos cambian para que se redibuje
    @Published var users: [User] = []
    
    // Función para agregar usuario
    func addUser(name: String) {
        // Validación de límite de 5 usuarios
        if users.count < 5 {
            let newUser = User(name: name)
            users.append(newUser)
            // Aquí podrías guardar en UserDefaults o CoreData
        }
    }
    
    // Función para borrar usuario
    func deleteUser(at offsets: IndexSet) {
        users.remove(atOffsets: offsets)
        // Aquí actualizarías el guardado
    }
    
    func deleteUser(_ user: User) {
        if let index = users.firstIndex(of: user) {
            users.remove(at: index)
        }
    }
}
