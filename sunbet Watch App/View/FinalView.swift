////
////  FinalView.swift
////  sunbet Watch App
////
////  Created by Evelyn Santoso on 26/05/24.
////
//
//import SwiftUI
//import HealthKit
//
//struct FinalView: View {
//    @EnvironmentObject var healthKitManager: HealthKitManager
//    @State private var timeindaylightvalue: Double = 0.0
//    
//    // MARK: - BODY
//    var body: some View {
//        // MARK: - MAIN WRAPPER (VSTACK)
//        VStack {
//            Text("\(Int(timeindaylightvalue/60)*100)% of your goal")
//            
//            // MARK: - WRAPPER (ZSTACK)
//            ZStack {
//                Circle()
//                    .trim(from: 0.0, to: 0.60)
//                    .stroke(Color("sunYellow2"), style: StrokeStyle(lineWidth: 15, lineCap: .round))
//                    .opacity(0.3)
//                    .rotationEffect(Angle(degrees: 162))
//                    .frame(width: 115, height: 115)
//                Circle()
//                    .trim(from: 0.0, to: 0.60)
//                    .stroke(Color("sunYellow"), style: StrokeStyle(lineWidth: 15, lineCap: .round))
//                    .rotationEffect(Angle(degrees: 162))
//                    .frame(width:  115, height:  115)
//                
//                Image("sunicon")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 70, height: 70)
//            } // MARK: - WRAPPER (ZSTACK)
//            
//            // MARK: - WRAPPER (VSTACK)
//            VStack {
//                Text("\(Int((1.0 - timeindaylightvalue) * 60)) min remaining")
//                    .font(Font.custom("SF Pro", size: 20))
//                    .fontWeight(.thin)
//                    .frame(width: 150, height: 40)
//                
//                }
//            } // MARK: - WRAPPER (VSTACK)
//            .padding(.top, -30.0)
//        
//
//    }
//       // MARK: - MAIN WRAPPER (VSTACK)
//    } // MARK: - BODY
////}
//
//#Preview {
//    FinalView()
//}
