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
    
    // MARK: 한 달
    func getMonthStepCount(completion: @escaping ([Double]?, Error?) -> Void) {
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
                completion(nil, error)
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
                completion(stepsDataList, nil)
            }
        }
        healthStore.execute(query)
    }
    
    func getAverageMonthStepCount(completion: @escaping (Double?, Error?) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let end = Calendar.current.startOfDay(for: Date() + 86400)
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: end)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate) { _, result, error in
            
            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil, error)
                return
            }
            
            let totalSteps = sum.doubleValue(for: HKUnit.count())
            let averageSteps = totalSteps / 30
            completion(averageSteps, nil)
        }
        healthStore.execute(query)
    }
    

    // MARK: 한 주
    func getWeekStepCount(completion: @escaping ([Double]?, Error?) -> Void) {
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
                completion(nil, error)
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
                completion(stepsDataList.dropLast(), nil)
            }
        }
        healthStore.execute(query)
    }
    
    func getAverageWeekStepCount(completion: @escaping (Double?, Error?) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let end = Calendar.current.startOfDay(for: Date() + 86400)
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: end)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate) { _, result, error in
            
            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil, error)
                return
            }
            
            let totalSteps = sum.doubleValue(for: HKUnit.count())
            let averageSteps = totalSteps / 7
            completion(averageSteps, nil)
        }
        healthStore.execute(query)
    }
    
    // MARK: 하루
    func getOneDayStepCount(today: Date, completion: @escaping (Double?, Error?) -> Void) {
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
                completion(nil, error)
                return
            }
            DispatchQueue.main.async {
                completion(sum.doubleValue(for: HKUnit.count()), nil)
            }
        }
        healthStore.execute(query)
    }
    
    func getOneDayHourlyStepCount(completion: @escaping ([Double]?, Error?) -> Void) {
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
                completion(nil, error)
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
                completion(stepsDataList.dropLast(), nil)
            }
        }
        healthStore.execute(query)
    }
}
