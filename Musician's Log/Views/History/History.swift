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
    @State var selected: Int = Date().dayInt
    @State var weeksWorthOfDays: [Int] = []
    
    @State var selectedDateText: String = ""
    
    @Query(sort: \MusicLogStorage.startTime) var logs: [MusicLogStorage]
    
    @State var fullScreen: Bool = false
    
    @State var newPresented: Bool = false
    
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
                    VStack {
                        LazyVGrid(columns: [GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0)], spacing: 0) {
                            if !fullScreen {
                                if(dateFocused.firstDayOfTheMonth.weekday != 1) {
                                    ForEach(1...(dateFocused.firstDayOfTheMonth.weekday - 1), id: \.self) { i in
                                        CalendarDateTile(number: 0, borderWidth: 0, calTileStle: .constant(.grey), selected: $selected, colors: .constant([]))
                                    }
                                }
                                
                                ForEach(1...calendar.range(of: .day, in: .month, for: dateFocused)!.count, id: \.self) { i in
                                    
                                    CalendarDateTile(number: i, borderWidth: 1, calTileStle: $isThisMonth, selected: $selected, colors: .constant(colorsForDay(i)))
                                }
                                
                            } else {
                                
                                ForEach(weeksWorthOfDays, id: \.self) { i in
                                    
                                    CalendarDateTile(number: i, borderWidth: 1, calTileStle: $isThisMonth, selected: $selected, colors: .constant(colorsForDay(i)))
                                }
                            }
                        }
                        .swipe(left: {
                            moveRight()
                        }, right: {
                            moveLeft()
                        })
                        
                    }
                    
                    
                    
                    VStack {
                        VStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.secondary)
                                .frame(width: 40, height: 5)
                                .padding(4)
                            
                            Text(fullScreen ? "" : selectedDateText)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .onChange(of: selected, initial: true) {
                                    updateDate()
                                }
                                .onChange(of: dateFocused, initial: true) {
                                    selectedDateText = dateFocused.formatted(date: .abbreviated, time: .omitted)
                                    updateWeek()
                                }
                        }
                        .frame(maxWidth: .infinity)

                        ScrollView {
                            
                            
                            ForEach(logs) { i in
                                NavigationLink(destination:  CalendarItemDetail(isNew: .constant(false), calendarItem: i)) {
                                    if(i.startTime.basicallyTheSameAs(dateFocused)) {
                                        CalendarHistoryItem(color: .red, name: i.title, time1: i.startTime.formatted(date: .omitted, time: .standard), time2: i.endTime?.formatted(date: .omitted, time: .standard) ?? "xx:xx")
                                    }
                                    
                                }
                                
                            }
                        }
                        .scrollDisabled(!fullScreen) //TODO: Test later...
                        
                    }
                    .swipe(up: {
                        withAnimation {
                            fullScreen = true
                        }
                    }, down: {
                        withAnimation {
                            fullScreen = false
                        }
                    })
                    .background(RoundedRectangle(cornerRadius: 10).fill(Material.bar))
                }
                
                
                
                
                
                
                
                
            }
            .safeAreaInset(edge:.top) {
                VStack {
                    Group {
                        if fullScreen {
                            Text(selectedDateText).bold()
                        } else {
                            Text(dateFocused.monthString).bold() + Text(" " + dateFocused.yearString)
                        }
                    }
                    .font(.largeTitle)
                    .padding([.leading])
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Button {
                            moveLeft()
                        } label: {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .frame(width: 20, height: 15)
                        }
                        Spacer()
                        Button {
                            moveRight()
                        } label: {
                            Image(systemName: "arrow.right")
                                .resizable()
                                .frame(width: 20, height: 15)
                        }
                        
                    }
                    .frame(height: 0)
                    .padding([.bottom, .leading , .trailing])
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
                    .font(.footnote)
                    .frame(maxWidth: .infinity)
                    
                    
                }
                .background(.bar)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        newPresented = true
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .popover(isPresented: $newPresented) {
                CalendarItemDetail(isNew: $newPresented, calendarItem: MusicLogStorage(title: "New Thing"))
            }
            
            
            
        }
        
    }
    
    func updateDate() {


        if selected != dateFocused.dayInt {
            if fullScreen {
                updateWeek()
                let interval = Double(weeksWorthOfDays.firstIndex(of: selected)! - weeksWorthOfDays.firstIndex(of: dateFocused.dayInt)!)
                
                dateFocused = dateFocused.addingTimeInterval(interval * 24 * 60 * 60)
            } else {
                let interval = Double(selected - dateFocused.dayInt)
                
                dateFocused = dateFocused.addingTimeInterval(interval * 24 * 60 * 60)
            }
        }
    }
    func updateWeek() {
        weeksWorthOfDays = []
        weeksWorthOfDays.append(dateFocused.firstDayOfTheWeek.dayInt)
        for i in 1..<7 {
            weeksWorthOfDays.append( dateFocused.firstDayOfTheWeek.addingTimeInterval(60*60*24*Double(i)).dayInt)
        }
        
        
    }
    func moveLeft() {
        let dateComponents = DateComponents(year: dateFocused.yearInt, month: (fullScreen ? dateFocused.monthInt : dateFocused.monthInt - 1), day: fullScreen ? dateFocused.dayInt - 7 : 1)
        withAnimation {
            dateFocused = calendar.date(from: dateComponents)!
            if(Date().yearString == dateFocused.yearString && Date().monthString == dateFocused.monthString) {
                isThisMonth = .today
            } else {
                isThisMonth = .normal
            }
            selected = fullScreen ? dateFocused.firstDayOfTheWeek.dayInt : dateFocused.dayInt
        }
    }
    func moveRight() {
        let dateComponents = DateComponents(year: dateFocused.yearInt, month: (fullScreen ? dateFocused.monthInt : dateFocused.monthInt + 1), day: fullScreen ? dateFocused.dayInt + 7 : 1)
        withAnimation {
            dateFocused = calendar.date(from: dateComponents)!
            if(Date().yearString == dateFocused.yearString && Date().monthString == dateFocused.monthString) {
                isThisMonth = .today
            } else {
                isThisMonth = .normal
            }
            selected = fullScreen ? dateFocused.firstDayOfTheWeek.dayInt : dateFocused.dayInt
        }
    }
    func colorsForDay(_ day: Int) -> [Color] {
        var colors: [Color] = []
        
        for log in logs where log.startTime.dayInt == day && log.startTime.monthInt == dateFocused.monthInt && log.startTime.yearInt == dateFocused.yearInt{
            for tag in log.tags {
                if colors.contains(tag.getColor()) { continue }
                colors.append(tag.getColor())
            }
        }
        
        return colors
    }
}

#Preview {
    History()
}
