//
//  ContentView.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 18/02/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isAppActive = false
    
    var body: some View {
        if isAppActive {
            UserSelectionView()
                // Esto hace que la nueva pantalla entre suavemente
                .transition(.opacity.animation(.easeInOut(duration: 1.0)))
        } else {
            SplashScreenView(isActive: $isAppActive)
        }
    }
}

#Preview {
    ContentView()
}
