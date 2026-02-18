//
//  GameModels.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 18/02/26.
//

import Foundation

struct Question: Identifiable {
    let id = UUID()
    let textPart1: String // "Espero que te "
    let textPart2: String // " bien en el viaje."
    let correctAnswer: String // "vaya"
    let options: [String] // ["vaya", "valla", "baya"]
    
    // Propiedad calculada para mostrar la oración completa
    var fullSentence: String {
        return textPart1 + " ____ " + textPart2
    }
}

struct GameLevel: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let questions: [Question]
}
