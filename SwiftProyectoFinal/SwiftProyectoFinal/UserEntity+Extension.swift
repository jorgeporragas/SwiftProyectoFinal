//
//  UserEntity+Extension.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 23/02/26.
//

import Foundation

// Extendemos tu entidad de Core Data para calcular el nivel y el progreso en tiempo real
extension UserEntity {
    
    // Nivel actual basado en fórmula exponencial
    var currentLevel: Int {
        // Fórmula: Nivel = 1 + raíz cuadrada(XP / 50)
        // Nivel 1: 0 XP
        // Nivel 2: 50 XP
        // Nivel 3: 200 XP
        // Nivel 4: 450 XP
        // Cada nivel cuesta progresivamente más.
        return 1 + Int(sqrt(Double(self.highScore) / 50.0))
    }
    
    // Calcula qué porcentaje de la barra de progreso debe llenarse (de 0.0 a 1.0)
    var progressToNextLevel: Double {
        let currentXP = Double(self.highScore)
        
        // Cuánta XP total se necesitaba para llegar al nivel actual
        let xpForCurrentLevel = 50.0 * pow(Double(currentLevel - 1), 2)
        // Cuánta XP total se necesita para el siguiente nivel
        let xpForNextLevel = 50.0 * pow(Double(currentLevel), 2)
        
        // Progreso dentro del nivel actual
        let xpEarnedInThisLevel = currentXP - xpForCurrentLevel
        let xpRequiredForThisLevel = xpForNextLevel - xpForCurrentLevel
        
        return xpEarnedInThisLevel / xpRequiredForThisLevel
    }
}
