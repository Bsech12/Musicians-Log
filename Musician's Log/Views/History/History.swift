//
//  History.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/14/24.
//

import SwiftUI
import SwiftData

struct History: View {
    
    @Binding var tabSelected: Int
    
    @State var dateFocused = Date()
    @State var isThisMonth: CalTileStyle = .today
    @State var selected: Int = Date().dayInt
    @State var weeksWorthOfDays: [Int] = []
    
    @State var selectedDateText: String = ""
    
    @Query(sort: \MusicLogStorage.startTime) var logs: [MusicLogStorage]
    
    @State var fullscreen: PresentationDetent = .fraction(0.37)
    @State var isPresented: Bool = true
    
    @State var newPresented: Bool = false
    @State var newItem: MusicLogStorage? = nil
    
    @State var navigationPresented: Bool = false
    @State var navigationPresentedItem: MusicLogStorage? = nil
    
    let calendar = Calendar.current
    
    var body: some View {
        NavigationStack {
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
                GeometryReader { geo in
                    VStack {
                        VStack {
                            LazyVGrid(columns: [GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0)], spacing: 0) {
                                if !fullscreen.isLarge() {
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
                        
                        Spacer()
                        
                        
                    }
                    .sheet(isPresented: $isPresented) {
                        VStack {
                            VStack {
                                HStack {
                                    Text(fullscreen.isLarge() ? "" : selectedDateText)
                                        .font(.headline)
                                    
                                        .onChange(of: selected, initial: true) {
                                            updateDate()
                                        }
                                        .onChange(of: dateFocused, initial: true) {
                                            selectedDateText = dateFocused.formatted(date: .abbreviated, time: .omitted)
                                            updateWeek()
                                        }
                                    if !fullscreen.isLarge() {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.secondary)
                                            .frame(width: 3, height: 10)
                                            .padding(4)
                                    }
                                    Text("Total Hours for day: \(totalHoursForToday().rounded(2))")
                                }
                                .padding()
                            }
                            .frame(maxWidth: .infinity)
                            
                            ScrollView {
                                //                                NavigationLink("hi", destination: Text("hi"))
                                
                                
                                ForEach(logs) { i in
                                    Button() {
                                        navigationPresentedItem = i
                                        isPresented = false
                                        navigationPresented = true
                                        print("set the values?")
                                        print(navigationPresentedItem!.title)
                                    } label: {
                                        if(i.startTime.basicallyTheSameAs(dateFocused)) {
                                            CalendarHistoryItem(colors: i.getColors(), name: i.title, time1: i.startTime.formatted(date: .omitted, time: .standard), time2: i.endTime?.formatted(date: .omitted, time: .standard) ?? "--:--")
                                                .padding([.leading,.trailing], 5)
                                        }
                                        
                                    }
                                                                        .buttonStyle(PlainButtonStyle())
                                    
                                }
                            }
                            .scrollBounceBehavior(.basedOnSize)
                            
                        }
                        .interactiveDismissDisabled()
                        .presentationBackgroundInteraction(.enabled)
                        .presentationBackground(.thinMaterial)
                        .presentationDetents([.height((geo.size.height -  getSubtractedHeight()).clamped(to: 50...(10000))), .newLarge(height: geo.size.height - 80)], selection: $fullscreen ) //.fraction(0.3), .fraction(0.7),
                        .bottomMaskForSheet()
                        
                    }
                }
                
            }
            .navigationDestination(isPresented: $navigationPresented) {
                if navigationPresentedItem != nil{
                    CalendarItemDetail(isNew: .constant(false), calendarItem: navigationPresentedItem ?? MusicLogStorage(title: "New Event", startTime: dateFocused))
//                        .onDisappear {
//                            isPresented = true
//                        }
                }
                
            }
            .onChange(of: tabSelected) {
                isPresented = (tabSelected == 0) && !(newPresented || navigationPresented)
            }
            .safeAreaInset(edge:.top) {
                VStack {
                    Group {
                        if fullscreen.isLarge() {
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
                        newItem = MusicLogStorage(title: "New Event", startTime: dateFocused)
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .popover(isPresented: $newPresented) {
                CalendarItemDetail(isNew: $newPresented, calendarItem: newItem ?? MusicLogStorage(title: "New Event", startTime: dateFocused))
            }
            .onChange(of: newPresented) {
                isPresented = !(newPresented || navigationPresented)
            }
            .onAppear() {
                isPresented = !(newPresented || navigationPresented)
            }

            
            
        }
        
    }
    func getSubtractedHeight() -> CGFloat{
        let weeks = CGFloat(Double(calendar.range(of: .weekOfMonth, in: .month, for: dateFocused)!.count).rounded(.up))
        
        return 70 + (weeks * 60)
    }
    
    func updateDate() {


        if selected != dateFocused.dayInt {
            if fullscreen.isLarge() {
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
        let dateComponents = DateComponents(year: dateFocused.yearInt, month: (fullscreen.isLarge() ? dateFocused.monthInt : dateFocused.monthInt - 1), day: fullscreen.isLarge() ? dateFocused.dayInt - 7 : 1)
        withAnimation {
            dateFocused = calendar.date(from: dateComponents)!
            if(Date().yearString == dateFocused.yearString && Date().monthString == dateFocused.monthString) {
                isThisMonth = .today
            } else {
                isThisMonth = .normal
            }
            selected = fullscreen.isLarge() ? dateFocused.firstDayOfTheWeek.dayInt : dateFocused.dayInt
        }
    }
    func moveRight() {
        let dateComponents = DateComponents(year: dateFocused.yearInt, month: (fullscreen.isLarge() ? dateFocused.monthInt : dateFocused.monthInt + 1), day: fullscreen.isLarge() ? dateFocused.dayInt + 7 : 1)
        withAnimation {
            dateFocused = calendar.date(from: dateComponents)!
            if(Date().yearString == dateFocused.yearString && Date().monthString == dateFocused.monthString) {
                isThisMonth = .today
            } else {
                isThisMonth = .normal
            }
            selected = fullscreen.isLarge() ? dateFocused.firstDayOfTheWeek.dayInt : dateFocused.dayInt
        }
    }
    func totalHoursForToday() -> Double {
        var seconds: Double = 0
        
        for log in logs where log.startTime.dayInt == dateFocused.dayInt && log.startTime.monthInt == dateFocused.monthInt && log.startTime.yearInt == dateFocused.yearInt{
            if let endTime = log.endTime {
                
                let diffs = Calendar.current.dateComponents([.second], from: log.startTime, to: endTime)
                seconds += Double(diffs.second ?? 0)
            }
            
        }
        return seconds/60/60
    }
    func colorsForDay(_ day: Int) -> [Color] {
        var colors: [Color] = []
        var wasFound: Bool = false
        for log in logs where log.startTime.dayInt == day && log.startTime.monthInt == dateFocused.monthInt && log.startTime.yearInt == dateFocused.yearInt{
            wasFound = true
            for tag in log.tags {
                if colors.contains(tag.getColor()) { continue }
                colors.append(tag.getColor())
            }
        }
        if colors.isEmpty && wasFound { colors.append(Color.gray) }
        
        return colors
    }
}

#Preview {
    @Previewable @State var tabSelected: Int = 0
    ContentView(tabSelected: tabSelected)
}
