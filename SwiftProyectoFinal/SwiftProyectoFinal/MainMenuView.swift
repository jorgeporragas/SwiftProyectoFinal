//
//  MainMenuView.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 18/02/26.
//

import SwiftUI

struct MainMenuView: View {
    var user: UserEntity
    
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
                    NavigationLink(destination: DifficultySelectionView(user: user)) {
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
    let user: UserEntity
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            
            // Encabezado
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Spacer()
                Text("Selecciona un Nivel")
                    .font(.title)
                    .bold()
                Spacer()
                // Espaciador invisible para balancear el botón de regreso
                Image(systemName: "chevron.left").opacity(0)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // Lista de Niveles Dinámica
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(LevelData.allLevels) { level in
                        NavigationLink(destination: GameplayView(level: level, user: user)) {
                            // Tarjeta de Nivel
                            VStack(alignment: .leading, spacing: 10) {
                                Text(level.title)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Text(level.description)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

/*

    var body: some View {
        VStack {
            Text("Selecciona un Nivel")
                .font(.largeTitle)

            ForEach(LevelData.allLevels) { level in
                NavigationLink(destination: GameplayView(level: level)) {
                }
            }
        }
    }

*/
