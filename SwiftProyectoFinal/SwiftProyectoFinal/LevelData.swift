//
//  LevelData.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 19/02/26.
//

import Foundation

struct LevelData {
    // Usamos un arreglo estático para poder acceder a los niveles desde cualquier parte de la app
    static let allLevels: [GameLevel] = [
        
        // --- NIVEL 1: HOMÓFONOS ---
        GameLevel(
            title: "Homófonos",
            description: "Palabras que suenan igual pero se escriben distinto.",
            questions: [
                Question(textPart1: "Espero que te", textPart2: "muy bien en el examen.", correctAnswer: "vaya", options: ["vaya", "valla", "baya"]),
                Question(textPart1: "Tengo que", textPart2: "la tarea de programación.", correctAnswer: "hacer", options: ["hacer", "a ser"]),
                Question(textPart1: "¡", textPart2: "Me lastimé el pie!", correctAnswer: "Ay", options: ["Hay", "Ahí", "Ay"]),
                Question(textPart1: "Siempre", textPart2: "la basura en su lugar.", correctAnswer: "echo", options: ["hecho", "echo"]),
                Question(textPart1: "Voy", textPart2: "qué película está en el cine.", correctAnswer: "a ver", options: ["a ver", "haber"])
            ]
        ),
        
        // --- NIVEL 2: LOS PORQUÉS ---
        GameLevel(
            title: "Los Porqués",
            description: "Aprende a diferenciar porque, por qué y porqué.",
            questions: [
                Question(textPart1: "¿", textPart2: "no viniste a clases ayer?", correctAnswer: "Por qué", options: ["Por qué", "Porque", "Porqué"]),
                Question(textPart1: "No fui", textPart2: "estaba enfermo.", correctAnswer: "porque", options: ["por qué", "porque", "porqué"]),
                Question(textPart1: "Aún no entiendo el", textPart2: "de su decisión.", correctAnswer: "porqué", options: ["por qué", "porque", "porqué"]),
                Question(textPart1: "Me pregunto", textPart2: "el código no compila.", correctAnswer: "por qué", options: ["por qué", "porque", "porqué"])
            ]
        ),
        
        // --- NIVEL 3: TILDES DIACRÍTICAS ---
        GameLevel(
            title: "Tildes Diacríticas",
            description: "Acentos que cambian el significado de la palabra.",
            questions: [
                Question(textPart1: "A", textPart2: "me gusta mucho programar en Swift.", correctAnswer: "mí", options: ["mí", "mi"]),
                Question(textPart1: "¿Quieres una taza de", textPart2: "?", correctAnswer: "té", options: ["té", "te"]),
                Question(textPart1: "El profesor dijo que", textPart2: "pasaste la materia.", correctAnswer: "sí", options: ["sí", "si"]),
                Question(textPart1: "Préstame", textPart2: "coche, por favor.", correctAnswer: "tu", options: ["tú", "tu"]),
                Question(textPart1: "Es", textPart2: "quien tiene el récord de puntos.", correctAnswer: "él", options: ["él", "el"])
            ]
        )
    ]
}
