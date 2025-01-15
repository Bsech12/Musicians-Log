//
//  Today.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/18/24.
//

import SwiftUI
import SwiftData

struct Today: View {
    
    @Query(sort: \ToDoStorage.dateCreated) var toDos: [ToDoStorage]
    
    @State var newToDoPresented: Bool = false
    
    var body: some View {
        NavigationView {
            
            List {
                Section {
                    RecordWidget()
                }
                Section("Tools") {
                    HStack {
                        Button {
                            
                        } label: {
                            MetronomeWidget()
                        }
                        
                        Button {
                            
                        } label: {
                            TunerWidget()
                        }
                    }
                }
                Section("Todos") {
                    ForEach(toDos){ todo in
                        TodoItem(item: todo)
                    }
                    Button() {
                        newToDoPresented = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("New ToDo")
                        }
                    }

                }
                
                
            }
            .popover(isPresented: $newToDoPresented) {
                AddTodoPopup(showPopup: $newToDoPresented)
            }
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        Settings()
                    } label: {
                        Image(systemName: "gear")
                            .resizable()
                            .imageScale(.large)
                    }
                }
            }
            .background {
                Color.listGrey
                    .edgesIgnoringSafeArea(.all)
                MeshGradient(width: 3, height: 3, points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [ 0.8, 0.5], [1.0, 1],
                    [0.0, 0.8], [0.5, 0.8], [0.8, 0.8]
                ], colors: [
                    .purple,  .purple, .red,
                     .red, .purple, .listGrey,
                    .listGrey, .listGrey, .listGrey
                ])
                .edgesIgnoringSafeArea(.all)
            }
            .navigationTitle("Today")
            
        }

        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            UINavigationBar.appearance().standardAppearance = appearance
            
            let exposedAppearance = UINavigationBarAppearance()
            exposedAppearance.backgroundEffect = .none
            exposedAppearance.shadowColor = .clear
            UINavigationBar.appearance().scrollEdgeAppearance = exposedAppearance
        }
    }
}

#Preview {
    Today()
}
