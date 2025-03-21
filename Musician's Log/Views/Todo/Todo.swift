//
//  Todo.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/22/24.
//

import SwiftUI
import SwiftData

struct Todo: View {
    
    @Query(sort: \ToDoStorage.dateCreated) var toDos: [ToDoStorage]
    
    @State var newIsPresented: Bool = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                Color.listGrey
                    .edgesIgnoringSafeArea(.all)
                MeshGradient(width: 3, height: 3, points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [0.8, 0.5], [1.0, 1],
                    [0.0, 0.8], [0.5, 0.8], [0.8, 0.8]
                ], colors: [
                    .red, .red, .blue,
                     .blue, .red, .listGrey,
                    .listGrey, .listGrey, .listGrey
                ])
                .edgesIgnoringSafeArea(.all)
                
                List {
                    ForEach(toDos){ todo in
                        TodoItem(item: todo)
                    }
//                    Section("Tomorrow") {
//                        TodoItem(name: "Practice piano", checked: false)
//                        TodoItem(name: "Practice cello", checked: false)
//                        
//                    }
//                    Section("This Week") {
//                        TodoItem(name: "Practice piano", checked: false)
//                        TodoItem(name: "Practice cello", checked: false)
//                        
//                    }
//                    Section("Next Week") {
//                        TodoItem(name: "Practice piano", checked: false)
//                        TodoItem(name: "Practice cello", checked: false)
//                        
//                    }
//                    Section("This Month") {
//                        TodoItem(name: "Practice piano", checked: false)
//                        TodoItem(name: "Practice cello", checked: false)
//                        
//                    }
//                    Section("This Year") {
//                        TodoItem(name: "Practice piano", checked: false)
//                        TodoItem(name: "Practice cello", checked: false)
//                        
//                    }
                    
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("To do")
                
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            newIsPresented = true
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    }
                }
                

                

            }
            .popover(isPresented: $newIsPresented) {
                AddTodoPopup(showPopup: $newIsPresented)
            }
            
            
            
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
    Todo()
}
