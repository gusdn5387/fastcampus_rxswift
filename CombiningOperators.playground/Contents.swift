import RxSwift

let disposeBag = DisposeBag()

print("---startwith---")
let 노랑반 = Observable<String>.of("A" ,"B", "C")

노랑반
    .enumerated()
    .map { index, element in
        element + " 어린이 " + "\(index)"
    }
    .startWith("선생님")
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---concat---")
let 노랑반어린이들 = Observable<String>.of("A", "B", "C")
let 선생님 = Observable<String>.of("선생님")

let 줄서서걷기 = Observable
    .concat([선생님, 노랑반어린이들])

줄서서걷기
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---concat1---")
선생님
    .concat(노랑반어린이들)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---concatMap---")
let 어린이집: [String: Observable<String>] = [
    "하늘반": Observable.of("A", "B", "C"),
    "우주반": Observable.of("D", "E", "F")
]

Observable.of("하늘반", "우주반")
    .concatMap { 반 in
        어린이집[반] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---merge---")
let 강북 = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let 강남 = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

let t = Observable.of(강북, 강남)
    .merge()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---merge2---")
Observable.of(강북, 강남)
    .merge(maxConcurrent: 1) // 첫번째 Observable이 끝날때까지 다음 꺼 실행 ㄴㄴ
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---combineLatest1---")
let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()

let 성명 = Observable
    .combineLatest(성, 이름) { 성, 이름 in
        성 + 이름
    }

성명
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

성.onNext("박")
이름.onNext("현우")
이름.onNext("철수")
이름.onNext("나영")
성.onNext("김")
성.onNext("이")
성.onNext("조")

print("---combineLatest2---")
let 날짜표시형식 = Observable<DateFormatter.Style>.of(.short, .long)
let 현재날짜 = Observable<Date>.of(Date())

let 현재날짜표시 = Observable
    .combineLatest(날짜표시형식, 현재날짜) { 형식, 날짜 -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = 형식
        return dateFormatter.string(from: 날짜)
    }

현재날짜표시
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---combineLatest3---")
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fullName = Observable
    .combineLatest([firstName, lastName]) { name in
        name.joined(separator: " ")
    }

fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("Park")
firstName.onNext("HyeonWoo")
firstName.onNext("NaYoung")
firstName.onNext("GilDong")

print("---zip---")

enum 승패 {
    case 승
    case 패
}

let 승부 = Observable<승패>.of(.승, .승, .패, .승, .패)
let 선수 = Observable<String>.of("대한민국", "미국", "일본", "포르투갈", "브라질", "영국")

// 승부 또는 선수의 Observable 하나만 끝나면 멈춤. 고로 영국은 나오지 않음
let 시합결과 = Observable
    .zip(승부, 선수) { 결과, 대표선수 in
        return 대표선수 + "선수" + " \(결과)"
    }

시합결과
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---withLatestFrom1---")
let 빵야 = PublishSubject<Void>()
let 달리기선수 = PublishSubject<String>()

빵야
    .withLatestFrom(달리기선수)
//    .distinctUntilChanged() //이걸 추가하면 sample처럼 같이 사용가능
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

달리기선수.onNext("🏃")
달리기선수.onNext("🏃‍♀️")
달리기선수.onNext("🏃‍♂️")
빵야.onNext(Void()) //달리기선수의 가장 최신 값만 나옴
빵야.onNext(Void())

print("---sample---")
let 출발 = PublishSubject<Void>()
let F1선수 = PublishSubject<String>()

F1선수
    .sample(출발)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

F1선수.onNext("부앙")
F1선수.onNext("부아아아앙")
F1선수.onNext("부르으으응")
출발.onNext(Void())
출발.onNext(Void())
출발.onNext(Void())

print("---amb---")
let 버스1 = PublishSubject<String>()
let 버스2 = PublishSubject<String>()

let 버스정류장 = 버스1.amb(버스2)

버스정류장
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

버스2.onNext("버스2-승객0") // 먼저 onNext 하는거만 구독. 그래서 버스2에 대한거만 구독됨
버스1.onNext("버스1-승객0")
버스2.onNext("버스2-승객1")
버스1.onNext("버스1-승객1")
버스1.onNext("버스1-승객2")
버스2.onNext("버스2-승객2")
버스1.onNext("버스1-승객3")

print("---switchLatest---")
let 학생1 = PublishSubject<String>()
let 학생2 = PublishSubject<String>()
let 학생3 = PublishSubject<String>()

let 손들기 = PublishSubject<Observable<String>>()

let 손든사람만말할수있는교실 = 손들기.switchLatest() // 가장 최근에 구독한 것만 처리

손든사람만말할수있는교실
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손들기.onNext(학생1)
학생1.onNext("학생1: 안녕하세요. 학생 1 입..")
학생2.onNext("학생2: 저요저요")

손들기.onNext(학생2)
학생2.onNext("학생2: 저는 학생2 입니다 ~~~")
학생1.onNext("학생1: 말 끊지마셈")

손들기.onNext(학생3)
학생2.onNext("학생2: 저저저저저저저저요")
학생1.onNext("학생1: 조용히 좀 해라")
학생3.onNext("학생3: ㅎㅇ")

손들기.onNext(학생1)
학생1.onNext("학생1: (샷건)")
학생2.onNext("학생2: (화들짝)")
학생3.onNext("학생3: 왜 샷건침?")
학생2.onNext("학생2: ㅜㅜ")

print("---reduce---") // 결과값만 보여줌
Observable.from((1...10))
//    .reduce(0, accumulator: { summary, newValue in
//        return summary + newValue
//    })
//    .reduce(0) { summary, newValue in
//        return summary + newValue
//    }
    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---scan---") // 매번 계산할때마다 값보여줌
Observable.from((1...10))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
