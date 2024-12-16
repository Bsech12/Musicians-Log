//
//  Todo.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/22/24.
//

import SwiftUI

struct Todo: View {
    
    @State var isAnimating = false
    
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                Color.listGrey
                    .edgesIgnoringSafeArea(.all)
                MeshGradient(width: 3, height: 3, points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [isAnimating ? 0.1 : 0.8, 0.5], [1.0, isAnimating ? 0.5 : 1],
                    [0.0, 0.8], [0.5, 0.8], [0.8, 0.8]
                ], colors: [
                    .red, isAnimating ? .blue : .red, .blue,
                    isAnimating ? .listGrey : .blue, .red, .listGrey,
                    .listGrey, .listGrey, .listGrey
                ])
                .edgesIgnoringSafeArea(.all)
                .onAppear() {
                    withAnimation(.easeInOut(duration: 12.0).repeatForever(autoreverses: true)) {
                        isAnimating.toggle()
                    }
                }
                
                List {
                    Section("Today") {
                        TodoItem(name: "Practice piano", checked: false)
                        TodoItem(name: "Practice cello", checked: false)
                        
                    }
                    Section("Tomorrow") {
                        TodoItem(name: "Practice piano", checked: false)
                        TodoItem(name: "Practice cello", checked: false)
                        
                    }
                    Section("This Week") {
                        TodoItem(name: "Practice piano", checked: false)
                        TodoItem(name: "Practice cello", checked: false)
                        
                    }
                    Section("Next Week") {
                        TodoItem(name: "Practice piano", checked: false)
                        TodoItem(name: "Practice cello", checked: false)
                        
                    }
                    Section("This Month") {
                        TodoItem(name: "Practice piano", checked: false)
                        TodoItem(name: "Practice cello", checked: false)
                        
                    }
                    Section("This Year") {
                        TodoItem(name: "Practice piano", checked: false)
                        TodoItem(name: "Practice cello", checked: false)
                        
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Todo")
                
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .frame(width: .infinity, height: .infinity, alignment: .bottomTrailing)
                    }
                }
                

                

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
