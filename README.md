<img src="https://github.com/chasomin/DailyDrops/assets/114223423/e6442189-65a2-401c-9b2b-102f9d3771f8" width=100, height=100>

# DailyDrops - 하루 건강 관리

물 마시기, 걸음 수, 영양제 목표를 설정하고 지켜나갈 수 있도록 관리해주는 앱입니다.

### **iOS 1인 개발**

### **기간**

24.3.7 ~ 24.3.24 (2주)

업데이트 진행 중

### **최소버전**

iOS 15


### **스크린샷**

<img src="https://github.com/chasomin/DailyDrops/assets/114223423/23bb47e7-d5bb-4e7c-a389-7dc30fedfeb9" width=124, height=268>
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

## 기능 소개

- 캘린더 기능
    - 매일매일 기록되는 나의 습관들을 모아볼 수 있습니다.
- 알림 기능
    - 영양제를 등록하면 해당 시간에 복용 알림을 받아볼 수 있습니다.
- 검색 기능
    - 내 영양제를 검색하면 알맞은 섭취량과 횟수를 안내합니다. 이 안내에 따라 영양제 복용 알림을 설정할 수 있습니다.
- 차트 기능
    - 1일 시간별 걸음 수 차트와 1주, 1개월 하루 걸음 수 차트를 제공하여 시각적으로 나의 걸음 수를 파악할 수 있습니다.
- 애니메이션
    - 마신 물 양에 따라 화면에 물결 애니메이션을 표시하고, 목표에 달성하면 축하 애니메이션이 화면에 나타납니다.

## **기술**

UIKit / MVVM / Decodable / Compositional Layout / DiffableDataSource / Singleton / Repository / CodeBaseUI / Local Notification

HealthKit / Alamofire / Realm / Firebase - Crashlytics, Analytics / SnapKit / FSCalendar / Toast / DGCharts

## **기술 설명**

**Realm List**를 사용하여 1대다 관계(to many relationship)를 구현했습니다.

**Realm Filter**를 사용하여 해당 날짜에 복용해야 하는 영양제 결과 도출했습니다.

**Realm Repository**를 사용하여 CRUD를 구현했습니다.

**Compositional Layout**을 통해 Section 별 다양한 Cell을 구성하였고, 영양제 복용 시간 별로 Section을 나눠서 구현했습니다.

Network와 HealthKit, Notification 권한 조회 등 Manager 클래스에 **Singleton 패턴**을 사용하여 불필요한 코드를 줄이고 메모리 낭비를 방지했습니다.

**BaseView**를 통해 코드 반복을 개선했습니다.

**CustomView**를 통해 재사용성을 높였습니다.

**MVVM CustomObservable**을 구현하여 ViewController의 역할을 최소화했습니다.

**Local Notification**에 여러 영양제를 설정하더라도 복용 시간이 같다면 동일한 Identifier를 사용하도록 설정하여 Identifier 갯수를 최소화 했습니다.

**Firebase Crashlytics, Analytics**를 사용하여 사용자 이탈지점과 충돌 데이터를 수집하여 앱의 안정성을 높였습니다.

**Final** 키워드와 **접근제어자**를 사용하여 컴파일 최적화 달성하려고 노력했습니다.

## 트러블슈팅

**1️⃣ Local Notification Identifier**

영양제 알림 설정을 할 때 notification Identifier 를 모두 같게 처리하면 여러 시간대에 영양제 알림이 울려도 계속 덮어씌워지는 아쉬움이 있었고,
영양제마다 다 다른 Identifier 를 쓰자니 한 영양제를 일주일 내내, 하루에 3번씩 먹는다면 64개 제한에 금방 걸린다는 문제가 있었습니다.

영양제 복용 특성 상 여러 종류를 복용 하더라도 보통 같은 시간대에 함께 복용하기 때문에 ✅ Identifier를 요일+시간 으로 저장하여 다른 종류의 영양제더라도 복용 시간만 같으면 하나의 알림으로 처리했습니다.

또한, Notification Title에 복용하는 영양제들의 이름을 알려주고 싶어서 영양제를 추가할 때 Notification을 조회하여 같은 Identifier를 가진 알림이 있다면 해당 content.title에 영양제 이름을 덧붙여서 다시 저장하도록 구현했습니다.
~~이렇게 하더라도 아직 64개를 초과할 가능성이 있기 때문에 앞으로 개선을 계속 할 예정…~~

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

**2️⃣ Relam 데이터를 삭제하더라도 과거 기록에서는 남아있어야 하는 문제**

영양제 전체 목록 테이블과, 복용 여부 테이블이 나뉘어져 있는데
사용자가 영양제를 삭제하면 복용 여부 테이블에는 남아있는데 영양제 실체는 사라져서 ‘-1개 남았어요’ 이런 식으로 나타는 오류가 있었습니다.
그렇다고 영양제 복용 여부에서도 삭제해버리면 과거에 먹었던 것도 기록이 사라지는 문제가 있었습니다.

✅ 영양제목록 테이블에 기본값이 nil인 deleteDate컬럼을 추가해서 사용자가 삭제하면 현재 Date 값을 update 해주었습니다.

사용자가 캘린더 날짜를 클릭해서 그 날 먹어야했던 영양제를 조회할 때 영양제의 `deleteDate <= 선택한 날` 이면 삭제했다고 처리하고, `deleteData > 선택한 날 > regDate` 이면 영양제가 있다고 처리했습니다.

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

**3️⃣ Realm Schema 수정 및 Migration**

영양제를 기존에 있는 영양제와 중복되는 이름으로 저장 시, 영양제 복용 여부 테이블에서 데이터 분별력이 떨어지는 이슈가 있었습니다.
→ 해결1. 같은 이름의 영양제는 추가 되는 것을 막기, 해결2. 영양제 PK를 영양제 복용 여부 테이블에 FK로 저장하기 중에

2번 방법을 선택하여 FK 컬럼을 추가했습니다.

새로운 컬럼을 추가하면서 기존에 들어있던 데이터에도 적절한 FK를 추가해주기위해
FK가 기본값이라면 '해당 이름이 영양제목록 테이블에 존재하면서 && 해당 supplementTime을 가지고 있는 영양제가 있다면' 그것에 해당하는 영양제의 PK를 넣어줬습니다.

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

