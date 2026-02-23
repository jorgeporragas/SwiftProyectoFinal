//
//  GameViewModel.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 18/02/26.
//

import SwiftUI
import Combine
import CoreData

// 1. Modelo: Qué es un usuario
struct User: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var highScore: Int = 0
}

// 2. ViewModel: El cerebro que maneja los datos
class GameViewModel: ObservableObject {
    // 1. El contenedor de nuestra base de datos
    let container = NSPersistentContainer(name: "GrammarGameModel")
    
    // 2. Nuestra lista publicada ahora usa UserEntity de Core Data
    @Published var users: [UserEntity] = []
    
    init() {
        // 3. Cargamos la base de datos al iniciar el ViewModel
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error al cargar Core Data: \(error.localizedDescription)")
            }
        }
        // Obtenemos los usuarios guardados
        fetchUsers()
    }
    
    // --- OPERACIONES CRUD (Create, Read, Update, Delete) ---
    
    func fetchUsers() {
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        
        do {
            users = try container.viewContext.fetch(request)
        } catch {
            print("Error al obtener usuarios: \(error)")
        }
    }
    
    func addUser(name: String) {
        if users.count < 5 {
            // Creamos un nuevo objeto en el contexto de Core Data
            let newUser = UserEntity(context: container.viewContext)
            newUser.id = UUID()
            newUser.name = name
            newUser.highScore = 0
            
            saveData()
        }
    }
    
    func deleteUser(_ user: UserEntity) {
        // Le decimos a Core Data que elimine el objeto
        container.viewContext.delete(user)
        saveData()
    }
    
    // Función centralizada para guardar y refrescar la vista
    private func saveData() {
        do {
            try container.viewContext.save()
            fetchUsers() // Refrescamos el arreglo @Published para que la UI se actualice
        } catch {
            print("Error al guardar datos: \(error)")
        }
    }
}
