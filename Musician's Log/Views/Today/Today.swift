//
//  Today.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/18/24.
//

import SwiftUI
import SwiftData
import AVFAudio
import SwiftTuner

struct Today: View {
    
    @Query(sort: \ToDoStorage.dateCreated) var toDos: [ToDoStorage]
    
    @State var conductor: TunerConductor = TunerConductor()
    
    @State var newToDoPresented: Bool = false
    @State var hasRecordPermission: Bool = false
    @AppStorage("hasAskedBefore") var hasAskedBefore: Bool = false
    @State var isTunerPopoverPresented: Bool = false
    
    var body: some View {
        NavigationView {
            
            List {
                Section {
                    RecordWidget()
                }
                Section("Tools") {
                        MetronomeWidget()
                    ZStack {
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    isTunerPopoverPresented = true
                                } label: {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            Spacer()
                        }
                       TunerWidget(hasPermission: $hasRecordPermission)
                            .environment(conductor)
                    }
                }
                Section("To do") {
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
                            .environment(conductor)
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
        .popover(isPresented: $isTunerPopoverPresented) {
            TunerPopover(tuner: $conductor)
        }
        .onAppear {
            switch AVAudioApplication.shared.recordPermission {
                case .granted:
                    hasRecordPermission = true
                case .denied:
                    hasRecordPermission = false
                case .undetermined:
           Task {
                    if await AVAudioApplication.requestRecordPermission() {
                        // The user grants access. Present recording interface.
                        hasRecordPermission = true

                    } else {
                        // The user denies access. Present a message that indicates
                        // that they can change their permission settings in the
                        // Privacy & Security section of the Settings app.
                        hasRecordPermission = false
                    }
                    hasAskedBefore = true
            }
            @unknown default:
                    print("Unknown case")
                }
            
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
