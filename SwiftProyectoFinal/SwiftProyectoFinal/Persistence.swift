//
//  Persistence.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 19/02/26.
//

import CoreData

struct PersistenceController {
    // Un singleton para acceder a la base de datos desde cualquier lado si es necesario
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // IMPORTANTE: Este nombre debe ser idéntico al de tu archivo .xcdatamodeld
        container = NSPersistentContainer(name: "GrammarGameModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // En una app de producción manejaríamos esto diferente,
                // pero para tu proyecto final este fatalError nos ayuda a detectar si algo falló.
                fatalError("Error no resuelto al cargar Core Data: \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
