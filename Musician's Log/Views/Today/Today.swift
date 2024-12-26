//
//  Today.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/18/24.
//

import SwiftUI

struct Today: View {
    
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
                Button {
                    
                } label: {
                    TodoWidget()
                    
                }
                
                
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

extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}
#Preview {
    Today()
}
