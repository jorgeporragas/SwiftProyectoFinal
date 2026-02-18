//
//  UserSelectionView.swift
//  SwiftProyectoFinal
//
//  Created by Jorge Porragas on 18/02/26.
//

import SwiftUI
import Combine

struct UserSelectionView: View {
    @StateObject var viewModel = GameViewModel() // Instanciamos el cerebro
    @State private var showingAddUserAlert = false
    @State private var newUserName = ""
    
    // Variables para controlar la alerta de borrado
    @State private var showingDeleteConfirmation = false
    @State private var userToDelete: User?
    
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
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)
                            Text("Puntaje: \(user.highScore)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
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
