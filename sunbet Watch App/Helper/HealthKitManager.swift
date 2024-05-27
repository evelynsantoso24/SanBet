////
////  HealthKitManager.swift
////  sunbet Watch App
////
////  Created by Evelyn Santoso on 24/05/24.
////
//
//import Foundation
//import HealthKit
//
//extension Date {
//    static var startOfDay: Date {
//        Calendar.current.startOfDay(for: Date())
//    }
//}
//
//class HealthKitManager: NSObject, ObservableObject {
//    
//    //Storing Variable for Health Metric, Session, and Workout
//    let healthStore = HKHealthStore()
////    @Published var timeInDaylight: HKQuantitySample?
//    @Published var stepCount: Double = 0.0
//    @Published var error: Error?
//    @Published var timeInDaylight: Double = 0.0
//    
//    
//    func requestAuthorization(completion: @escaping (Bool) -> Void) {
//            guard HKHealthStore.isHealthDataAvailable() else {
//                return // HealthKit is not available on this device
//            }
//
//            let typesToRead: Set<HKObjectType> = [
//                HKObjectType.quantityType(forIdentifier: .timeInDaylight)!,
//            ]
//
//            healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
//                if success {
//                    DispatchQueue.main.async {
//                        print("success")
//                    }
//                } else if let error = error {
//                    print("Failed to request authorization for health data: \(error.localizedDescription)")
//                }
//            }
//    
//    }
//    
//    
//    // fetch data in day light
//    func fetchtimeindaylight(completion: @escaping (Double) -> Void) {
////        let timeindaylight = HKQuantityType(.timeInDaylight)
////        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
////        let query = HKStatisticsQuery(quantityType: timeindaylight, quantitySamplePredicate: predicate){ _, result, error in
////            guard let quantity = result?.sumQuantity(), error == nil else {
////                print("error fetching todays step data")
////                return
////            }
////            
////            let timeindaylightcount = quantity.doubleValue(for: HKUnit.minute())
////            print(timeindaylightcount.formattedString())
////            print("masuk")
////        }
////        healthStore.execute(query)
//    }
//    
//    
//    
//}
//
//
//extension Double {
//    func formattedString() -> String {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        numberFormatter.maximumFractionDigits = 0
//        
//        return numberFormatter.string(from: NSNumber(value: self))!
//    }
//    
//}

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

class HealthKitManager: NSObject, ObservableObject {
    
    // Storing Variable for Health Metric, Session, and Workout
    let healthStore = HKHealthStore()
    @Published var timeInDaylight: Double = 0.0
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return // HealthKit is not available on this device
        }

        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .timeInDaylight)!,
        ]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    print("HealthKit authorization succeeded.")
                    completion(true)
                } else {
                    print("Failed to request authorization for health data: \(error?.localizedDescription ?? "unknown error")")
                    completion(false)
                }
            }
        }
    }
    
    func fetchtimeindaylight(completion: @escaping (Double) -> Void) {
        guard let timeInDaylightType = HKQuantityType.quantityType(forIdentifier: .timeInDaylight) else {
            completion(0.0)
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: Date.startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: timeInDaylightType, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching today's daylight data: \(error?.localizedDescription ?? "unknown error")")
                completion(0.0)
                return
            }
            
            let timeInDaylightMinutes = quantity.doubleValue(for: HKUnit.minute())
            DispatchQueue.main.async {
                self.timeInDaylight = timeInDaylightMinutes
                completion(timeInDaylightMinutes)
            }
        }
        healthStore.execute(query)
    }
}
