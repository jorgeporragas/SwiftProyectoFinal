//
//  SplashScreenView.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 18/02/26.
//

import SwiftUI
import Combine


struct SplashScreenView: View {
    // Binding nos permite comunicar hacia afuera que el splash terminó
    @Binding var isActive: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Logo (Usamos un icono del sistema por ahora como placeholder)
            Image(systemName: "text.book.closed.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            // Descripción
            Text("Este juego tiene como propósito enseñar gramática y ortografía en español")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.gray)
        }
        .onAppear {
            // Lógica para que desaparezca después de 2 segundos
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}
