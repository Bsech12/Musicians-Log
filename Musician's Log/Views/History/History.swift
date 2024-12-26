//
//  History.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/14/24.
//

import SwiftUI
import SwiftData

struct History: View {
    
    @State var dateFocused = Date()
    @State var isThisMonth: CalTileStyle = .today
    @State var selected: String = "\(Date().dayInt)"
    
    
    @Query(sort: \MusicLogStorage.startTime) var logs: [MusicLogStorage]
    
    let calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.listGrey
                    .edgesIgnoringSafeArea(.all)
                MeshGradient(width: 3, height: 3, points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [ 0.8, 0.5], [1.0, 1],
                    [0.0, 0.8], [0.5, 0.8], [0.8, 0.8]
                ], colors: [
                    .blue,  .blue, .purple,
                     .purple, .blue, .listGrey,
                    .listGrey, .listGrey, .listGrey
                ])
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    LazyVGrid(columns: [GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0)], spacing: 5) {
                        if(dateFocused.firstDayOfTheMonth.weekday != 1) {
                            ForEach(1...(dateFocused.firstDayOfTheMonth.weekday - 1), id: \.self) { i in
                                CalendarDateTile(number: "", borderWidth: 0, calTileStle: .constant(.grey), selected: $selected)
                                    .frame(height: 60)
                            }
                        }
                        
                        ForEach(1...calendar.range(of: .day, in: .month, for: dateFocused)!.count, id: \.self) { i in
                            CalendarDateTile(number: "\(i)", borderWidth: 1, calTileStle: $isThisMonth, selected: $selected)
                                .frame(height: 60)
                        }
                        
                        
                    }
                    .swipe(left: {
                        moveRight()
                    }, right: {
                        moveLeft()
                    })
                    .padding(.top, 5)
                    Spacer()
                    
                    ScrollView {
                        ForEach(logs) {i in
                            CalendarHistoryItem(color: .red, name: i.title, time1: i.startTime.formatted(date: .omitted, time: .standard), time2: i.endTime?.formatted(date: .omitted, time: .standard) ?? "xx:xx")
                        }
                    }
                    .background(Material.bar)
                    
                    
                    
                    
                }
                
                
                
            }
//            .navigationTitle(Date().monthString + ": " + Date().yearString)
            .safeAreaInset(edge:.top) {
                VStack {
                    Group {
                        Text(dateFocused.monthString).bold() + Text(" " + dateFocused.yearString)
                    }
                        .font(.largeTitle)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("S")
                            .frame(maxWidth: .infinity)
                        Text("M")
                            .frame(maxWidth: .infinity)
                        Text("T")
                            .frame(maxWidth: .infinity)
                        Text("W")
                            .frame(maxWidth: .infinity)
                        Text("T")
                            .frame(maxWidth: .infinity)
                        Text("F")
                            .frame(maxWidth: .infinity)
                        Text("S")
                            .frame(maxWidth: .infinity)
                    }
                }
                .font(.footnote)
                .frame(maxWidth: .infinity)
                .background(.bar)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        //TODO:
                        moveLeft()
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        //TODO:
                        moveRight()
                    } label: {
                        Image(systemName: "arrow.right")
                    }
                }
            }
            
            
            
        }
    }
    func moveLeft() {
        let dateComponents = DateComponents(year: dateFocused.yearInt, month: (dateFocused.monthInt - 1))
        withAnimation {
            dateFocused = calendar.date(from: dateComponents)!
            if(Date().yearString == dateFocused.yearString && Date().monthString == dateFocused.monthString) {
                isThisMonth = .today
            } else {
                isThisMonth = .normal
            }
            selected = "1"
        }
    }
    func moveRight() {
        let dateComponents = DateComponents(year: dateFocused.yearInt, month: (dateFocused.monthInt + 1))
        withAnimation {
            dateFocused = calendar.date(from: dateComponents)!
            if(Date().yearString == dateFocused.yearString && Date().monthString == dateFocused.monthString) {
                isThisMonth = .today
            } else {
                isThisMonth = .normal
            }
            selected = "1"
        }
    }
}

#Preview {
    History()
}
