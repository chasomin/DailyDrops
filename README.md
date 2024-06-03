<img src="https://github.com/chasomin/DailyDrops/assets/114223423/e6442189-65a2-401c-9b2b-102f9d3771f8" width=100, height=100>

# DailyDrops - 하루 건강 관리

물 마시기, 걸음 수, 영양제 목표를 설정하고 지켜나갈 수 있도록 관리해주는 앱

### **iOS 1인 개발**

### **기간**

24.03.07 ~ 24.03.24 (2주)

업데이트 진행 중

### **최소버전**

iOS 15.0

### 앱스토어 링크
[DailyDrops 앱스토어](https://apps.apple.com/kr/app/dailydrops-하루-건강-관리/id6479728669)

<br>


### **스크린샷**

<img src="https://github.com/chasomin/DailyDrops/assets/114223423/0426d158-bd43-4e8a-acc5-b089addabe58" width=124, height=268>
<img src="https://github.com/chasomin/DailyDrops/assets/114223423/46a92034-5891-495d-8ede-d47e4f5750b3" width="124" height="268">
<img src="https://github.com/chasomin/DailyDrops/assets/114223423/0effbaa1-2870-4bfe-908b-db039be7ca72" width=124, height=268>
<img src="https://github.com/chasomin/DailyDrops/assets/114223423/15c43d4e-2c0e-4e33-96e7-af0bb314b779" width=124, height=268>
<img src="https://github.com/chasomin/DailyDrops/assets/114223423/71a7670e-96e9-4a06-943e-fb25427b8bd5" width=124, height=268>
<img src="https://github.com/chasomin/DailyDrops/assets/114223423/dc33d294-8acc-413b-9c28-4293f91a30b8" width=124, height=268>
<br>

<img src="https://github.com/chasomin/DailyDrops/assets/114223423/c41f61a2-605b-469b-bd32-beb0ec08484f" width=124, height=268>
<img src="https://github.com/chasomin/DailyDrops/assets/114223423/ee33f622-997f-4d0a-ae73-9f36b1b88e01" width=124, height=268>
<img src="https://github.com/chasomin/DailyDrops/assets/114223423/dd4cc58b-4871-4859-9895-fef0cb63e2ff" width=124, height=268>
<img src="https://github.com/chasomin/DailyDrops/assets/114223423/cc543a62-8810-4790-afc5-438e9478352f" width=124, height=268>
<img src="https://github.com/chasomin/DailyDrops/assets/114223423/c2d7bb5e-4dab-4f14-9c53-aae95ea24da9" width=124, height=268>
<img src="https://github.com/chasomin/DailyDrops/assets/114223423/b29aba48-8d86-45fb-89a2-a4e69c3ea340" width=124, height=268>
<br>

### Widget
<img src="https://github.com/chasomin/DailyDrops/assets/114223423/1efefa56-23ba-4dee-bab5-02583e5e37c4" width="124" height="268">


## 기능 소개

- 캘린더 날짜별 목표 달성 기록 조회
- 영양제 등록 시 해당 시간에 알림 전달
- 영양제 검색을 통해 복용법 추천
- 차트를 통해 기간 별 걸음 수 조회
- 마신 물 양을 애니메이션 화면으로 제공
- Widget으로 하루 물 섭취량 관리

## **기술**

`UIKit` `MVVM` `Singleton` `Repository` `UserNotifications` `Decodable` `CodeBaseUI` `CompositionalLayout` `DiffableDataSource` `CocoaPods` `SPM` `Realm` `Alamofire` `SnapKit` `Kingfisher` `Toast` `FSCalendar` `DGCharts` `Firebase - Crashlytics, Analytics`


## **기술 고려 사항**
 ViewController의 복잡성을 줄이기 위해 MVVM 패턴을 채택
 
 복잡한 연산이 없는 상황이라 단순 입출력 속도가 가장 빠른 Realm을 DB로 사용
 
 보일러플레이트 코드를 줄여 네트워크 코드를 간결하게 작성하기 위해 Alamofire 사용
 

## **기술 설명**

 **MVVM Custom Observable**을 구현하여 비즈니스 로직 분리

 **DTO**를 통해 네트워크 모델과 도메인 모델을 분리하여 유지보수 용이한 코드 구현

 **final** 키워드와 **접근제어자**를 사용하여 컴파일 최적화

 **weak self** 키워드를 사용하여 메모리 누수 방지

 protocol 생성 시 **AnyObject** 채택을 통해 해당 protocol을 채택할 수 있는 객체의 타입을 제한하여 메모리 누수 방지

 **AppGroup**을 사용하여 Target 간 Realm 데이터 공유

 **Realm List**를 사용하여 1대다 관계(to many relationship)를 구현

 **Realm Repository**를 통해 유지보수성과 확장성 향상

 DGCharts 라이브러리 class를 상속받아 Custom Chart Mark를 구현하여 사용자 친화적인 UI 구성

 **Firebase Crashlytics, Analytics**를 통해 사용자 이탈지점과 충돌 데이터를 수집하여 앱의 안정성 향상

 
## 트러블슈팅

**1️⃣ Local Notification Identifier**

identifier를 모두 동일하게 처리할 겨우의 문제점: 같은 시간 영양제 모두 한꺼번에 처리, 이전 알림 안 읽어도 덮어씌우기

identifier를 영양제마다 전부 부여할 경우의 문제점: 64개 제한


✅ Identifier를 요일+시간 으로 저장하여 다른 종류의 영양제더라도 복용 시간만 같으면 하나의 알림으로 처리하고 그 시간대에 복용하는 영양제를 Notification Title에 표시


```swift
let id = day.description+time.dateFilterTime()
...
UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
let request = requests.filter { $0.identifier == id }
if request.isEmpty {
    content.title = "[\(time.dateFilterTime())] \(name)"
} else {
    request.forEach { content.title = "\($0.content.title), \(name)" }
...
}
```

<br>


**2️⃣ Relam 데이터를 삭제하더라도 과거 기록에서는 남아있어야 하는 문제**

사용자가 현재 영양제를 삭제할 경우, 과거에 먹었던 기록에도 영향을 미쳐서 수치가 변화함

✅ 영양제목록 테이블에 기본값이 nil인 deleteDate컬럼을 추가해서 사용자가 삭제하면 현재 Date 값을 update 

사용자가 캘린더 날짜를 클릭해서 그 날 먹어야했던 영양제를 조회할 때 영양제의 `deleteDate <= 선택한 날` 이면 삭제했다고 처리,
`deleteData > 선택한 날 > regDate` 이면 영양제가 있다고 처리

```swift
final class RealmSupplement: Object {
    @Persisted(primaryKey: true) var id: UUID   // PK
    @Persisted var regDate: Date                // 영양제 등록일
    @Persisted var name: String                 // 영양제 이름
    @Persisted var days: List<Int>              // 영양제 복용 요일
    @Persisted var times: List<Date>            // 영양제 복용 시간
    @Persisted var deleteDate: Date?            // 영양제 삭제일

    convenience init(name: String, days: List<Int>, times: List<Date>) {
        self.init()
        self.regDate = Date()
        self.name = name
        self.days = days
        self.times = times
        self.deleteDate = nil
    }
}
```

<br>

**3️⃣ Realm Schema 수정 및 Migration**

영양제를 기존에 있는 영양제와 중복되는 이름으로 저장 시, 영양제 복용 여부 테이블에서 데이터 분별력이 떨어지는 이슈

→ 방법1. 같은 이름의 영양제는 추가 되는 것을 막기

→ 방법2. 영양제 PK를 영양제 복용 여부 테이블에 FK로 저장하기 

중에 2번 방법을 선택하여 FK 컬럼을 추가.

새로운 컬럼을 추가하면서 기존에 들어있던 데이터에도 적절한 FK를 추가해주기위해
FK가 기본값이라면 '해당 이름이 영양제목록 테이블에 존재하면서 && 해당 supplementTime을 가지고 있는 영양제가 있다면' 그것에 해당하는 영양제의 PK를 대입

```swift
final class RealmSupplementLog: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var regDate: Date
    @Persisted var supplementName: String
    @Persisted var supplementTime: String
    @Persisted var supplementFK: UUID
...
}
```

```swift
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
        }
        ...
    }
}
```

