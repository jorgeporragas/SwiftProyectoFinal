//
//  SplashScreenView.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 18/02/26.
//

import SwiftUI
import Combine

struct SplashScreenView: View {
    @Binding var isActive: Bool
    
    // Esta variable controla la invisibilidad inicial
    @State private var logoOpacity = 0.0
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "text.book.closed.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Este juego tiene como propósito enseñar gramática y ortografía en español")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.gray)
        }
        .opacity(logoOpacity) // Aplicamos la opacidad a todo el bloque
        .onAppear {
            // 1. FADE IN: Tarda 2.5 segundos en aparecer completamente
            withAnimation(.easeIn(duration: 2.5)) {
                logoOpacity = 1.0
            }
            
            // 2. FADE OUT: Espera 4 segundos en total, y hace la transición suave a la app
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                withAnimation(.easeOut(duration: 1.5)) {
                    self.isActive = true
                }
            }
        }
    }
}
