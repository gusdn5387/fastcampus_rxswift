import RxSwift
import Foundation
 
let disposeBag = DisposeBag()

print("---toArray---")
Observable.of("A", "B", "C", "D")
    .toArray() // element들을 하나의 배열로
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---map---")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---flatMap---")
protocol 선수 {
    var 점수: BehaviorSubject<Int> { get }
}

struct 양궁선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 한국국대 = 양궁선수(점수: BehaviorSubject<Int>(value: 10))
let 일본국대 = 양궁선수(점수: BehaviorSubject<Int>(value: 0))

let 올림픽경기 = PublishSubject<선수>()

올림픽경기
    .flatMap { 선수 in
        선수.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

올림픽경기.onNext(한국국대)
한국국대.점수.onNext(10)

올림픽경기.onNext(일본국대)
일본국대.점수.onNext(0)

print("---flatMapLatest---")
struct 높이뛰기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 서울시대표 = 높이뛰기선수(점수: BehaviorSubject<Int>(value: 10))
let 제주시대표 = 높이뛰기선수(점수: BehaviorSubject<Int>(value: 9))

let 전국체전 = PublishSubject<선수>()

전국체전
    .flatMapLatest { 선수 in
        선수.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

전국체전.onNext(서울시대표)
서울시대표.점수.onNext(9)

전국체전.onNext(제주시대표)
서울시대표.점수.onNext(10) // 새로운 시퀀스 발생 시 기존 시퀀스 처리 안함
제주시대표.점수.onNext(8)

print("---materialize and dematerialize---")
enum 반칙: Error {
    case 부정출발
}

struct 달리기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 김토끼 = 달리기선수(점수: BehaviorSubject<Int>(value: 0))
let 박치타 = 달리기선수(점수: BehaviorSubject<Int>(value: 1))

let 달리기100M = BehaviorSubject<선수>(value: 김토끼)

달리기100M
    .flatMapLatest { 선수 in
        선수.점수
            .materialize() // 이벤트감싸서
    }
    .filter {
        guard let error = $0.error else {
            return true
        }
        print(error)
        return false
    }
    .dematerialize() // 이벤트감싼거 해제
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

김토끼.점수.onNext(1)
김토끼.점수.onError(반칙.부정출발)
김토끼.점수.onNext(2)

달리기100M.onNext(박치타)

print("---전화번호 11자리---")
let input = PublishSubject<Int?>()

let list: [Int] = [1]

input
    .flatMap {
        $0 == nil ? Observable.empty() : Observable.just($0)
    }
    .map { $0! }
    .skip(while: { $0 != 0 })
    .take(11)
    .toArray()
    .asObservable()
    .map {
        $0.map { "\($0)" }
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3)
        numberList.insert("-", at: 8)
        let number = numberList.reduce(" ", +)
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(5)
input.onNext(4)
input.onNext(nil)
input.onNext(5)
input.onNext(6)
input.onNext(5)
input.onNext(3)
input.onNext(8)
input.onNext(7)
