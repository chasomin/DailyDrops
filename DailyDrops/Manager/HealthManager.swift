//
//  HealthManager.swift
//  DailyDrops
//
//  Created by 차소민 on 3/7/24.
//

import Foundation
import HealthKit


class HealthManager {
    static let shared = HealthManager()
    
    private let healthStore = HKHealthStore()
    private init() { }
    
    let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
    
    func requestAuthoriaztion() {
        healthStore.requestAuthorization(toShare: nil, read: read) { (success, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                if success {
                    print("권한 허락!")
                    //TODO: Toast
                } else {
                    print("권한이 아직 없어요")
                }
            }
        }
    }
    
    func getMonthStepCount(completion: @escaping ([Double]) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let end = Calendar.current.startOfDay(for: Date() + 86400)
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: end)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: end, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(day: 1))
        
        query.initialResultsHandler = { query, results, error in
            
            if let error {
                //TODO: Toast
                print("걸음 수 쿼리 실패: \(error.localizedDescription)")
            } else {
                guard let results = results else {
                    return
                }
                var stepsDataList: [Double] = []
                results.enumerateStatistics(from: startDate, to: end) { statistics, _ in
                    if let sum = statistics.sumQuantity() {
                        let steps = sum.doubleValue(for: HKUnit.count())
                        stepsDataList.append(steps)
                    } else {
                        stepsDataList.append(0)
                    }
                }
                completion(stepsDataList)
            }
        }
        healthStore.execute(query)
    }

    
    func getWeekStepCount(completion: @escaping ([Double]) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let end = Calendar.current.startOfDay(for: Date() + 86400)
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: end)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: end, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(day: 1))
        
        query.initialResultsHandler = { query, results, error in
            
            if let error {
                //TODO: Toast
                print("걸음 수 쿼리 실패: \(error.localizedDescription)")
            } else {
                guard let results = results else {
                    return
                }
                var stepsDataList: [Double] = []
                results.enumerateStatistics(from: startDate, to: end) { statistics, _ in
                    if let sum = statistics.sumQuantity() {
                        let steps = sum.doubleValue(for: HKUnit.count())
                        stepsDataList.append(steps)
                    } else {
                        stepsDataList.append(0)
                    }
                }
                completion(stepsDataList)
            }
        }
        healthStore.execute(query)
    }
    
    func getOneDayStepCount(today: Date, completion: @escaping (Double) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let end = Calendar.current.startOfDay(for: today + 86400)
        let startDate = Calendar.current.startOfDay(for: today)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: end, options: .strictStartDate)
                
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print(error.debugDescription)
                print("fail")
                // TODO: Toast
                return
            }
            DispatchQueue.main.async {
                completion(sum.doubleValue(for: HKUnit.count()))
            }
        }
        healthStore.execute(query)
    }
    
    func getOneDayHourlyStepCount(completion: @escaping ([Double]) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let end = Calendar.current.startOfDay(for: Date() + 86400)
        let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: end)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: end, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(hour: 1))
        
        query.initialResultsHandler = { query, results, error in
            
            if let error {
                //TODO: Toast
                print("걸음 수 쿼리 실패: \(error.localizedDescription)")
            } else {
                guard let results = results else {
                    return
                }
                var stepsDataList: [Double] = []
                results.enumerateStatistics(from: startDate, to: end) { statistics, _ in
                    if let sum = statistics.sumQuantity() {
                        
                        let steps = sum.doubleValue(for: HKUnit.count())
                        stepsDataList.append(steps)
                    } else {
                        stepsDataList.append(0)
                    }
                }
                completion(stepsDataList)
            }
        }
        healthStore.execute(query)
    }
}
