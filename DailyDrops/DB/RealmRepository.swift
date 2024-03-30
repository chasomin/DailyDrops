//
//  RealmRepository.swift
//  DailyDrops
//
//  Created by 차소민 on 3/11/24.
//

import Foundation
import RealmSwift

final class RealmRepository<T: Object> {
    private let realm = try! Realm()
    
    // MARK: - Create
    func createItem(_ item: T, completion: (() -> Void)?) {
        do {
            print(realm.configuration.fileURL)
            try realm.write {
                realm.add(item)
                completion?()
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Read    
    func readSupplementLog() -> Results<RealmSupplementLog> {
        return realm.objects(RealmSupplementLog.self)
    }
    
    func readWaterByDate(date: Date) -> Float {
        let result = realm.objects(RealmWater.self).map{ $0.toEntity() }.filter{ $0.date.dateFormat() == date.dateFormat()}
        var total: Float = 0
        result.forEach{
            total += $0.drinkWater
        }
        return total
    }
    
    func readFirstGoal() -> Goal {
        let goal = realm.objects(RealmGoal.self).map { $0.toEntity() }
        guard let firstGoal = goal.sorted(by: {$0.regDate < $1.regDate}).first else { return Goal(id: "", waterCup: 0, steps: 0, regDate: Date())}
        return firstGoal
    }
    
    func readGoalCups(date: Date) -> Float {
        let goal = realm.objects(RealmGoal.self).map { $0.toEntity() }
        return goal.filter{$0.regDate.dateWithMidnight() <= date}.sorted(by: {$0.regDate < $1.regDate}).last?.waterCup ?? 0
    }
    
    func readGoalSteps(date: Date) -> Int {
        let goal = realm.objects(RealmGoal.self).map { $0.toEntity() }
        return goal.filter { $0.regDate.dateWithMidnight() <= date }.sorted(by: {$0.regDate < $1.regDate}).last?.steps ?? 0
    }
    
    func readSupplement() -> Results<RealmSupplement> {
        realm.objects(RealmSupplement.self)
            //.where({$0.regDate <= date})
    }
    
    func readSupplement() -> [MySupplement] {
        realm.objects(RealmSupplement.self).map{ $0.toEntity() }
    }
    
    /// 특정 날짜에 복용할 약 배열을 리턴하는 메서드
    func readSupplementByDate(date: Date) -> [MySupplement] {
        let supplements = realm.objects(RealmSupplement.self)
        let filterContainToday = supplements.where{$0.days.contains(date.dateFilterDay())}
        return filterContainToday.map{ $0.toEntity() }.filter{ $0.regDate.dateWithMidnight() <= date && $0.deleteDate?.dateWithMidnight() ?? Date() > date }
    }
    
    /// 해당 시간 대에 복용할 약 배열을 리턴하는 메서드
    func readSupplementForTime(_ time: String, date: Date) -> [MySupplement] {
//        let today = Date()
//        let supplements = realm.objects(RealmSupplement.self)
//        let filterContainToday = supplements.where{$0.days.contains(date.dateFilterDay())}.map{ $0.toEntity() }
        return readSupplementByDate(date: date).filter { $0.times.map { $0.dateFilterTime() }.contains(time) }
//        return filterContainToday.filter{ $0.times.map{ $0.dateFilterTime() }.contains(time) }
    }
    
    /// 특정 날짜에 복용할 약의 시간대를 리턴하는 메서드
    func readSupplementTimeForDate(_ date: Date) -> [String] {
        let todaySupplement = readSupplementByDate(date: date)
        
        var times: [String] = []
        todaySupplement.forEach {
            $0.times.forEach {
                times.append($0.dateFilterTime())
            }
        }
        return Set(times).sorted()
    }
    
    func readSupplementLogForDate(date: Date) -> [RealmSupplementLog] {
        let SupplementID = readSupplementByDate(date: date).map { $0.id }
        let result: [RealmSupplementLog] = readSupplementLog().filter { log in
            log.regDate.dateFormat() == date.dateFormat() && SupplementID.contains(log.supplementFK)
        }
        return result
    }

        
    // MARK: Delete
    
    /// 영양제 복용 체크 버튼 선택 시 사용하는 메서드
    func deleteSupplementLog(date: String, fk: UUID, time: String) {
        do {
            try realm.write {
                let result = readSupplementLog().filter({$0.supplementFK == fk && $0.supplementTime == time && $0.regDate.dateFormat() == date})
                realm.delete(result)
            }
        } catch {
            print(error)
        }
    }    
    
    // 영양제 삭제 시 deleteDate에 현재 날짜 추가
    func deleteSupplement(id: UUID, completion: @escaping () -> Void) {
        do {
            try realm.write {
                let supplements: Results<RealmSupplement> = readSupplement()
                let resultSupplement = supplements.where({$0.id == id})
                resultSupplement.first?.deleteDate = Date()
                completion()
            }
        } catch {
            print(error)
        }
    }
    
    
    ///FK 를 빈값으로 추가한다면, //(00000000-0000-0000-0000-000000000000)으로 들어옴
    ///FK 빈값인 것 중에, '해당 이름이 영양제에 존재하면서, 해당 supplementTime을 가지고 있는 영양제가 있다면' 해당 영양제의 ID를 넣기
    /// 그 이후에도 FK가 0이라면 삭제
    func updateInvalidLog() {
        let updateLog = readSupplementLog().filter { $0.supplementFK.uuidString.split(separator: "-").map { Int($0) ?? 1 }.reduce(0, +) == 0 }
        let supplements: Results<RealmSupplement> = readSupplement()
        
        guard !updateLog.isEmpty else {
            return
        }
        
        updateLog.forEach { log in
            let sameSupplement = supplements.filter({ $0.name == log.supplementName && $0.times.map{$0.dateFilterTime()}.contains(log.supplementTime)})
            
            if !sameSupplement.isEmpty {
                do {
                    try realm.write {
                        log.supplementFK = sameSupplement.first!.id
                    }
                } catch {
                    print(error)
                }
            } else {
                do {
                    try realm.write {
                        realm.delete(log)
                    }
                } catch {
                    print(error)
                }
            }
        }
        
    }
}
/// 동일 이름 약 등록 못하게 하는 경우
/// -> FK가 필요 없다
/// 1 기존 삭제된 데이터 log도 날려주기
/// 2 isDelete false 중에 같은 이름인 영양제가 존재하는데, 그 영양제의 regDate보다 log의 regDate가 더 이전이면 log 삭제
/// 3 약 등록할 때 이름 중복을 false 끼리만 비교
/// 4 영양제 먹은 기록 보여줄 때, false 상태인 애들이
/// 5 과거 영양제 기록 보여줄 때는 false, true 값을 전부 보여줘야할텐데 이름이 같다면???
///
/// 오늘 A영양제를 복용했는데 삭제 -> A영양제를 다시 등록 => 영양제에 A true, A false 존재. / 로그에는 A와 A존재. 뭐가 삭제한 A인지 알 수 없음.regDate로 난리쳐야함 XXXXX
///
/// FK 추가하고, 동일 이름 가능한 경우
/// 이미 이전에 이름 같은 영양제를 저장했다면???
/// 비타민A, 비타민A 존재.  로그의 FK에 어떤 ID를 저장해줄 수 있을까?
/// => 해당 supplementTime이 존재하는 영양제의 ID를 저장해주기
/// 1. 기존 삭제된 데이터 날리기
/// 2. FK가 같고
///
/// 영양제 추가 추가 하고 로그로그 찍은 경우
/// A, A
/// 영양제 추가 로그 삭제 추가 로그 한 경우
///

///---------------------------------
/// FK 추가 -> FK에 '해당 이름과 동일하면서, 해당 supplementTime을 가지고 있는 영양제' 의 ID 넣기
/// -> 이미 이전에 삭제된 영양제라면 FK가 빈 값으로 되어있을 거임, -> FK가 빈 값인 로그들 삭제                   => migration 할 때 이렇게 따로 값 못 넣어줄듯
///-----
///FK 를 빈값으로 추가한다면, //(00000000-0000-0000-0000-000000000000)으로 들어옴
///FK 빈값인 것 중에, '해당 이름이 영양제에 존재하면서, 해당 supplementTime을 가지고 있는 영양제가 있다면' 해당 영양제의 ID를 넣기
/// 그 이후에도 FK가 0이라면 삭제
///
///
/// 영양제가 삭제되어도 해당 영양제의 기록이 존재하다면, 기록에는 해당 영양제가 존재해야함.
/// 오늘 약을 안 먹엇는데 약을 삭제한다면 해당 기록은 안보여줘도됨.
/// 오늘 00시00분 / 삭제한날짜는 오늘 13:00,
///  => 삭제한 날짜도 00시로 변환해서 오늘 안 먹었는데 오늘 삭제됐다면
///  영양제의 deleteDate.midnight가 오늘00시보다 작으면 supplement 안가져옴.
///  같다면, 해당 id를 가진 log가 찍혔다면 가져오고, 안찍혔다면 안가져옴
///
///
///
/// 삭제되었다고 값이 변해도 기록이 나타나야됨.
/// -> ❓언제 삭제된 지 모르는데 어떻게 화면 그리지?
///     영양제B를 어제 먹었어야했는데, 안 먹어서 log 안찍힘, 근데 오늘 그 영양제를 삭제해서 true로 값 변화. 어제 날짜로 선택하면 그 영양제가 어제 존재했는지 알 수 없음.......
///     => isDelete를 Date? 타입의 deleteDate로 저장해서 안지웠으면 nil 값, 지웠으면 삭제한 날짜 저장
///     => deleteDate가 선택 날짜보다 미래라면 그 약은 선택 날짜에 먹었어야함, 근데 로그 안찍혀있다면 체크 안되어있는 상태로 보여주기
///     만약 나중에 미래에서 과거의 기록을 변경하고 싶다면????
///     regDate를 그 과거 날짜로 하고, FK를 저장하면 보여줄 수 있을듯??
