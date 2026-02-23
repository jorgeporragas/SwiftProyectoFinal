//
//  UserSelectionView.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 18/02/26.
//

import SwiftUI
import Combine
import CoreData

struct UserSelectionView: View {
    @StateObject var viewModel = GameViewModel() // Instanciamos el cerebro
    @State private var showingAddUserAlert = false
    @State private var newUserName = ""
    
    // Variables para controlar la alerta de borrado
    @State private var showingDeleteConfirmation = false
    @State private var userToDelete: UserEntity?
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.users.isEmpty {
                    // Estado vacío: Botón al centro
                    emptyStateView
                } else {
                    // Lista de usuarios
                    userListView
                    
                    // Botón para agregar más si no hemos llegado al límite
                    if viewModel.users.count < 5 {
                        Button(action: {
                            showingAddUserAlert = true
                        }) {
                            Label("Crear Usuario Nuevo", systemImage: "person.badge.plus")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("TituloDelJuego")
            // Alerta para crear usuario (Input de texto)
            .alert("Nuevo Usuario", isPresented: $showingAddUserAlert) {
                TextField("Nombre", text: $newUserName)
                Button("Cancelar", role: .cancel) { newUserName = "" }
                Button("Crear") {
                    if !newUserName.isEmpty {
                        viewModel.addUser(name: newUserName)
                        newUserName = ""
                    }
                }
            }
            // Alerta de confirmación para borrar
            .alert("¿Borrar perfil?", isPresented: $showingDeleteConfirmation) {
                Button("Cancelar", role: .cancel) {}
                Button("Borrar", role: .destructive) {
                    if let user = userToDelete {
                        viewModel.deleteUser(user)
                    }
                }
            } message: {
                Text("Esta acción no se puede deshacer.")
            }
        }
    }
    
    // Vista auxiliar para cuando no hay usuarios
    var emptyStateView: some View {
        VStack {
            Text("Bienvenido")
                .font(.largeTitle)
                .padding(.bottom)
            
            Button(action: {
                showingAddUserAlert = true
            }) {
                Text("Crear Usuario Nuevo")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    // Vista auxiliar de la lista
    var userListView: some View {
        List {
            ForEach(viewModel.users) { user in
                NavigationLink(destination: MainMenuView(user: user)) {
                    
                    // ZStack nos permite poner la barra de progreso de fondo
                    ZStack(alignment: .leading) {
                        
                        // --- BARRA DE PROGRESO INVISIBLE/FONDO ---
                        GeometryReader { geo in
                            Rectangle()
                                .fill(Color.blue.opacity(0.15)) // Color suave para la barra
                            // El ancho es el porcentaje de progreso multiplicado por el ancho total
                                .frame(width: geo.size.width * CGFloat(user.progressToNextLevel))
                        }
                        
                        // --- CONTENIDO DE LA FILA ---
                        HStack(spacing: 20) {
                            // Número del Nivel (En lugar del ícono)
                            Text("\(user.currentLevel)")
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                .foregroundColor(.blue)
                                .frame(width: 50) // Ancho fijo para que los nombres queden alineados
                            
                            VStack(alignment: .leading) {
                                Text(user.name ?? "Desconocido")
                                    .font(.headline)
                                Text("\(user.highScore) XP")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                            // En lugar de borrar directo, guardamos a quién queremos borrar y mostramos alerta
                        userToDelete = user
                        showingDeleteConfirmation = true
                    } label: {
                        Label("Borrar", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
        }
    }
}
