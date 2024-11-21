//
//  Today.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/18/24.
//

import SwiftUI

struct Today: View {
    @State var isAnimating = false
    
    var body: some View {
        NavigationView {
            
            List {
                Section {
                    Button {
                        
                        //TODO: record button
                        
                    } label: {
                        RecordWidget()
                    }
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
                Button {
                    
                } label: {
                    TodoWidget()
                    
                }
                
                
            }
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem {
                    Button {
                        // TODO: Settings
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
                    [0.0, 0.5], [isAnimating ? 0.1 : 0.8, 0.5], [1.0, isAnimating ? 0.5 : 1],
                    [0.0, 0.8], [0.5, 0.8], [0.8, 0.8]
                ], colors: [
                    .purple, isAnimating ? .red : .purple, .red,
                    isAnimating ? .listGrey : .red, .purple, .listGrey,
                    .listGrey, .listGrey, .listGrey
                ])
                .edgesIgnoringSafeArea(.all)
                .onAppear() {
                    withAnimation(.easeInOut(duration: 12.0).repeatForever(autoreverses: true)) {
                        isAnimating.toggle()
                    }
                }
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
