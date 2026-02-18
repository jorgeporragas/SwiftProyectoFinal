//
//  GameplayView.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 18/02/26.
//

import SwiftUI

struct GameplayView: View {
    let level: GameLevel
    @Environment(\.dismiss) var dismiss

    // --- ESTADO DEL JUEGO ---
    @State private var currentQuestionIndex = 0
    @State private var lives = 3
    @State private var isGameOver = false
    @State private var showPauseMenu = false
    
    // --- LÓGICA DE ARRASTRE MANUAL (NUEVO) ---
    @State private var selectedAnswer: String? = nil
    @State private var dropZoneFrame: CGRect = .zero // Coordenadas de la caja destino
    @State private var dragOffset: CGSize = .zero // Cuánto se ha movido el dedo
    @State private var draggedOption: String? = nil // Qué opción se está moviendo
    @State private var isOverDropZone = false // Feedback visual (Hover)
    
    // --- ESTADO DE RESPUESTA ---
    @State private var answerIsCorrect: Bool? = nil
    @State private var characterFace: String = "😐"

    var currentQuestion: Question {
        level.questions[currentQuestionIndex]
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                // 1. HUD (Pausa y Vidas)
                HStack {
                    Button(action: { showPauseMenu = true }) {
                        Image(systemName: "pause.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                    }
                    Spacer()
                    HStack {
                        ForEach(0..<3) { index in
                            Image(systemName: index < lives ? "heart.fill" : "xmark.circle")
                                .foregroundColor(index < lives ? .red : .gray)
                                .font(.title2)
                        }
                    }
                }
                .padding()

                // 2. PERSONAJE
                Spacer()
                Text(characterFace)
                    .font(.system(size: 80))
                    .padding()
                    .animation(.spring(), value: characterFace)
                
                // 3. ORACIÓN Y DROP ZONE
                VStack(spacing: 20) {
                    Text("Completa la oración:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack(alignment: .center) {
                        Text(currentQuestion.textPart1)
                            .font(.title2)
                            .multilineTextAlignment(.trailing)
                        
                        // --- DROP ZONE CON GEOMETRY READER ---
                        ZStack {
                            // Fondo de la caja
                            RoundedRectangle(cornerRadius: 10)
                                .fill(getDropZoneColor())
                                .frame(width: 140, height: 50)
                            
                            // Borde
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isOverDropZone ? Color.green : Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .frame(width: 140, height: 50)

                            // Texto (si ya se soltó una respuesta)
                            if let answer = selectedAnswer {
                                Text(answer)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            } else if draggedOption == nil {
                                Text("Arrastra aquí")
                                    .font(.caption)
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                        }
                        // Leemos la posición GLOBAL de la caja para saber cuándo soltamos encima
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        // Guardamos las coordenadas exactas en pantalla
                                        dropZoneFrame = geo.frame(in: .global)
                                    }
                                    .onChange(of: geo.frame(in: .global)) { newFrame in
                                        dropZoneFrame = newFrame
                                    }
                            }
                        )
                        
                        Text(currentQuestion.textPart2)
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .zIndex(1) // Aseguramos que la oración esté debajo de las fichas voladoras
                }
                
                Spacer()

                // 4. OPCIONES (AHORA CON DRAG GESTURE)
                HStack(spacing: 20) {
                    if answerIsCorrect == nil {
                        ForEach(currentQuestion.options, id: \.self) { option in
                            Text(option)
                                .font(.headline)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 20)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                // --- MAGIA DEL ARRASTRE INSTANTÁNEO ---
                                .offset(draggedOption == option ? dragOffset : .zero)
                                .zIndex(draggedOption == option ? 100 : 1) // Traer al frente si se mueve
                                .gesture(
                                    DragGesture(coordinateSpace: .global)
                                        .onChanged { value in
                                            // 1. Activamos el arrastre
                                            if draggedOption == nil { draggedOption = option }
                                            
                                            // 2. Movemos la ficha
                                            dragOffset = value.translation
                                            
                                            // 3. Detectamos si estamos sobre la caja (Hover)
                                            if dropZoneFrame.contains(value.location) {
                                                withAnimation(.easeOut(duration: 0.2)) {
                                                    isOverDropZone = true
                                                }
                                            } else {
                                                withAnimation(.easeOut(duration: 0.2)) {
                                                    isOverDropZone = false
                                                }
                                            }
                                        }
                                        .onEnded { value in
                                            // 4. Al soltar
                                            if dropZoneFrame.contains(value.location) {
                                                // ¡ÉXITO! Cayó dentro
                                                withAnimation(.spring()) {
                                                    selectedAnswer = option
                                                    draggedOption = nil
                                                    dragOffset = .zero
                                                    isOverDropZone = false
                                                }
                                            } else {
                                                // FALLO: Regresa a su lugar (Snap back)
                                                withAnimation(.spring()) {
                                                    dragOffset = .zero
                                                    draggedOption = nil
                                                    isOverDropZone = false
                                                }
                                            }
                                        }
                                )
                                .opacity(selectedAnswer == option ? 0 : 1) // Ocultar si ya se eligió
                        }
                    }
                }
                .padding(.bottom, 30)
                .frame(height: 80)
                .zIndex(100) // Asegurar que las fichas pasen por encima de todo
                
                // 5. BOTÓN DE ACCIÓN
                Button(action: handleButtonAction) {
                    Text(getButtonTitle())
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(getButtonColor())
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.bottom)
                .disabled(selectedAnswer == nil && answerIsCorrect == nil)
            }
            .blur(radius: showPauseMenu ? 5 : 0)
            
            // 6. MENÚ DE PAUSA
            if showPauseMenu {
                Color.black.opacity(0.4).ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Pausa").font(.largeTitle).bold().foregroundColor(.white)
                    Button("Reanudar") { showPauseMenu = false }
                        .padding().background(Color.white).cornerRadius(10)
                    Button("Salir al Menú") { dismiss() }
                        .padding().background(Color.red).foregroundColor(.white).cornerRadius(10)
                }
            }
        }
        .navigationBarHidden(true)
        .alert("¡Juego Terminado!", isPresented: $isGameOver) {
            Button("Salir") { dismiss() }
        } message: {
            Text("Te quedaste sin vidas.")
        }
    }
    
    // --- HELPERS VISUALES ---
    
    func getDropZoneColor() -> Color {
        if isOverDropZone { return Color.green.opacity(0.3) }
        if selectedAnswer != nil { return Color.blue.opacity(0.2) }
        return Color.gray.opacity(0.1)
    }
    
    func getButtonTitle() -> String {
        if answerIsCorrect == nil { return "Comprobar Respuesta" }
        return "Siguiente Pregunta"
    }
    
    func getButtonColor() -> Color {
        if let correct = answerIsCorrect { return correct ? .green : .red }
        return selectedAnswer == nil ? .gray : .blue
    }
    
    // --- LÓGICA DE JUEGO ---
    
    func handleButtonAction() {
        if answerIsCorrect == nil {
            guard let selected = selectedAnswer else { return }
            if selected == currentQuestion.correctAnswer {
                answerIsCorrect = true
                characterFace = "😎"
            } else {
                answerIsCorrect = false
                characterFace = "😢"
                lives -= 1
                if lives == 0 { isGameOver = true }
            }
        } else {
            nextQuestion()
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < level.questions.count - 1 {
            currentQuestionIndex += 1
            withAnimation {
                selectedAnswer = nil
                answerIsCorrect = nil
                characterFace = "😐"
            }
        } else {
            characterFace = "🏆"
            dismiss()
        }
    }
}
