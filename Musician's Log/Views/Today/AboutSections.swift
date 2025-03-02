//
//  AboutSections.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 3/1/25.
//

import SwiftUI
import SwiftTuner

struct AboutMe: View {
    var body: some View {
        ScrollView {
            Text("About Me")
                .font(.title)
            Text("Hi! My name is Bryce, and I am a High School Student and musician. ")
            Text("This will be my first published app, I hope you enjoy it!")
            Text("I someday aspire to be a Software Engineer, these kinds of apps help pave the way forward, (if you have any good ideas contact me!)")
        }
        .padding()
    }
}

struct AboutTheProject: View {
    var body: some View {
        ScrollView {
            Text("Senior Project")
                .font(.title)
            Text("Musican's Log is a music practicing and tracking app created as my senior project, combinding my duel-pathway interests in music and technology.")
            Text("I spent over 80+ hours developing this app, my presentations, and my final product")
            Text("The app was originally developed for myself and my peers in our Instrumental Music department to help keep track of our practice hours and to allow us to record our practice sessions. I hope this can be useful to all musicians!")
            Text("Although I am finished with the project, I hope to keep updating this app as I learn more about SwiftUI and ios development. If you have any issues or feature requests, please contact me!")
                .padding(.bottom)
            Text("First published in March of 2025")
                .font(.caption)
//It allows you to record your practice sessions, keep track of your practicing hours, create todos, and much more!
        }
        .padding()
    }
}

struct Acknowledgements: View {
    var body: some View {
        ScrollView {
            Text("Attributions: ")
                .font(.title)
            Text("Thank you to Matt Pfeiffer (Matt54) for their open-source SwiftTuner framework! You can find their project at: https://github.com/Matt54/SwiftTuner.")
                .padding(.bottom)
            
            Text("Special Thanks to My friends, family, and mentors for all of their help and support! ")
                .font(.headline)
        }
        .padding()
    }
}


#Preview {
    NavigationView {
        Settings()
            .environment(TunerConductor())
    }
}
