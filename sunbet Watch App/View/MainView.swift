//
//  MainView.swift
//  sunbet Watch App
//
//  Created by Evelyn Santoso on 24/05/24.
//


import SwiftUI
import HealthKit
import UserNotifications

func calculateProgress(timeInDaylight: Double, targetMinutes: Double) -> Double {
    
    if timeInDaylight > 60 {
            return 60 * 0.01 // Ensure progress does not exceed 1.0 (100%)
        }
    
    return timeInDaylight * 0.01 // Ensure progress does not exceed 1.0 (100%)
}

func calculateTimeInDaylightValue(timeInDaylight: Double, targetMinutes: Double) -> Double {
    return min(timeInDaylight / targetMinutes, 1.0) // Ensure progress does not exceed 1.0 (100%)
}


struct MainView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var healthKitManager: HealthKitManager
    @State private var progress: Double = 0.0
    @State private var timeindaylightvalue: Double = 0.0
    
    // MARK: - BODY
    var body: some View {
        // MARK: - MAIN WRAPPER (VSTACK)
        VStack(spacing: 3) {
            HStack {
                if timeindaylightvalue != 0 {
                    Text("\(Int(timeindaylightvalue)) min")
                        .font(.caption)
                    
                }
            }

            // MARK: - WRAPPER (ZSTACK)
            ZStack {
                Circle()
                    .trim(from: 0.0, to: 0.60)
                    .stroke(Color("sunYellow2"), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .opacity(0.3)
                    .rotationEffect(Angle(degrees: 162))
                    .frame(width: 115, height: 115)
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(Color("sunYellow"), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .rotationEffect(Angle(degrees: 162))
                    .frame(width:  115, height:  115)
                
                Image("sunicon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
            } // MARK: - WRAPPER (ZSTACK)
            
            // MARK: - WRAPPER (VSTACK)
            VStack {
                Text("\(Int((1.0 - timeindaylightvalue) * 60)) min remaining")
                    .font(Font.custom("SF Pro", size: 20))
                    .fontWeight(.thin)
                    .frame(width: 150, height: 40)
                
                if timeindaylightvalue < 60 {
                    Text("Go Outdoor!!")
                        .font(.system(size: 24))
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color("yellowText"), Color("orangeText")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                        .onTapGesture {
                                self.scheduleNotification()
                        }
                        .frame(width: 160, height: 45)
                } else {
                    NavigationLink(destination: ContentView()) {
                        Text("Excellent")
                            .font(.custom("SFCompactRounded-Bold", size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(40)
                            .frame(width: 160, height: 45)
                        }
                }
            } // MARK: - WRAPPER (VSTACK)
            .padding(.top, -30.0)
        
        .onAppear {
            healthKitManager.requestAuthorization { success in
                if success {
                    healthKitManager.fetchtimeindaylight { daylightMinutes in
                        self.progress = calculateProgress(timeInDaylight: daylightMinutes, targetMinutes: 60)
                        self.timeindaylightvalue = calculateTimeInDaylightValue(timeInDaylight: daylightMinutes, targetMinutes: 60)
                        if daylightMinutes < 60 {
                            self.scheduleNotification()
                        }
                    }
                }
            }
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if !granted {
                    print("User notification permission not granted: \(error?.localizedDescription ?? "unknown error")")
                }
            }
        }
    }
       // MARK: - MAIN WRAPPER (VSTACK)
    } // MARK: - BODY
       
    
    func scheduleNotification() {
        
        
//        let content = UNMutableNotificationContent()
//                content.title = "Sunbet"
//                content.subtitle = "LET'S GO OUTDOOR!!"
//                content.body = "Boost your energy by maintaining sun exposure."
//                content.sound = .default
//                
//                // Schedule the notification to trigger in 10 seconds (or any desired interval)
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//                
//                let request = UNNotificationRequest(identifier: "sunbath", content: content, trigger: trigger)
//                
//                UNUserNotificationCenter.current().add(request) { error in
//                    if let error = error {
//                        print("Notification scheduling failed: \(error.localizedDescription)")
//                    }
//                }
        
        let now = Date()
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: now)
                
                // Check if the current time is before 4 PM
                if hour < 16  {
                    let content = UNMutableNotificationContent()
                    content.title = "Sunbet"
                    content.subtitle = "Let's GO OUTDOOR!!"
                    content.body = "Supports your healthy immune system by maintaining sun exposure."
                    content.sound = .default
                    
//                     Schedule the notification to trigger in 10 seconds (or any desired interval)
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 90, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: "sunbath", content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Notification scheduling failed: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Current time is after 5 PM. Notification will not be scheduled.")
                }
    }
}

#Preview {
    MainView().environmentObject(HealthKitManager())
}
