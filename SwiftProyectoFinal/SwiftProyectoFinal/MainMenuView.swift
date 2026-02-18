//
//  MainMenuView.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 18/02/26.
//

import SwiftUI

struct MainMenuView: View {
    var user: User // Recibimos el usuario seleccionado
    
    // Esta variable nos permite "matar" esta vista y regresar a la anterior
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // --- CAPA 1: Contenido Central ---
            VStack(spacing: 50) {
                // Título Superior
                Text("TituloDelJuego")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .padding(.top, 50)
                
                Spacer()
                
                // Botones Centrales (Jugar y Ajustes)
                HStack(spacing: 60) {
                    // Botón Jugar
                    NavigationLink(destination: DifficultySelectionView()) {
                        VStack {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            Text("Jugar")
                                .font(.headline)
                        }
                    }
                    
                    // Botón Ajustes
                    NavigationLink(destination: SettingsView()) {
                        VStack {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            Text("Ajustes")
                                .font(.headline)
                        }
                    }
                }
                .foregroundColor(.blue) // Color general para los botones
                
                Spacer()
            }
            
            // --- CAPA 2: Botón Flotante (Regresar a Usuario) ---
            VStack {
                Spacer() // Empuja todo hacia abajo
                HStack {
                    Spacer() // Empuja todo a la derecha
                    
                    Button(action: {
                        // Acción: Regresar a la pantalla anterior
                        dismiss()
                    }) {
                        Image(systemName: "person.fill")
                            .font(.title)
                            .padding()
                            .background(Color.gray.opacity(0.2)) // Un fondo suave
                            .clipShape(Circle())
                            .foregroundColor(.primary)
                    }
                    .padding() // Margen con el borde de la pantalla
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Ocultamos el botón "Atrás" default de iOS
    }
}

// Pantalla de Ajustes (Vacía por ahora)
struct SettingsView: View {
    var body: some View {
        Text("Aquí irán los ajustes")
            .font(.title)
    }
}

// Pantalla de Selección de Dificultad
struct DifficultySelectionView: View {
    // Creamos un nivel de prueba "hardcodeado"
    let sampleLevel = GameLevel(
        title: "Homófonos",
        description: "Vaya vs Valla",
        questions: [
            Question(textPart1: "Espero que te", textPart2: "bien.", correctAnswer: "vaya", options: ["vaya", "valla"]),
            Question(textPart1: "Salta la", textPart2: "con cuidado.", correctAnswer: "valla", options: ["vaya", "valla"])
        ]
    )
    
    var body: some View {
        VStack {
            Text("Selecciona un Nivel")
                .font(.largeTitle)
            
            // Botón temporal para probar el juego
            NavigationLink(destination: GameplayView(level: sampleLevel)) {
                Text("Nivel 1: Vaya vs Valla")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
