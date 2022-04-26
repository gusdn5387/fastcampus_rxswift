import RxSwift
import RxCocoa
import UIKit
import PlaygroundSupport //Playground에서 UI 보기 위함

let disposeBag = DisposeBag()

print("---replay---")
let 인사말 = PublishSubject<String>()
let 반복무새 = 인사말.replay(2) // 자기가 구독하기 전에 이벤트들을 가져옴

반복무새.connect() // replay 쓸 때 connect 필수

인사말.onNext("1. 안녕")
인사말.onNext("2. 반가워")

반복무새
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

인사말.onNext("3. 안녕하세요")

print("---replayAll---")
let 닥터스트레인지 = PublishSubject<String>()
let 타임스톤 = 닥터스트레인지.replayAll()

타임스톤.connect()

닥터스트레인지.onNext("1트: 도르마무")
닥터스트레인지.onNext("1트: 거래를 하러왔다")
닥터스트레인지.onNext("2트: 도르마무")
닥터스트레인지.onNext("2트: 거래를 하러왔다")
닥터스트레인지.onNext("3트: 도르마무")
닥터스트레인지.onNext("3트: 거래를 하러왔다")

타임스톤
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("---buffer---")
//let source = PublishSubject<String>()
//
//var count = 0
//let timer = DispatchSource.makeTimerSource()
//
//timer.schedule(deadline: .now() + 2, repeating: .seconds(1))
//timer.setEventHandler {
//    count += 1
//    source.onNext("\(count)")
//}
//timer.resume()
//
//source
//    .buffer(timeSpan: .seconds(2), count: 2, scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("---window---")
//let 만들어낼최대Observable수 = 1
//let 만들시간 = RxTimeInterval.seconds(2)
//
//let window = PublishSubject<String>()
//
//var windowCount = 0
//let windowTimerSource = DispatchSource.makeTimerSource()
//windowTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//windowTimerSource.setEventHandler {
//    windowCount += 1
//    window.onNext("\(windowCount)")
//}
//windowTimerSource.resume()
//
//window
//    .window(timeSpan: 만들시간, count: 만들어낼최대Observable수, scheduler: MainScheduler.instance)
//    .flatMap { windowObservable -> Observable<(index: Int, element: String)> in
//        return windowObservable.enumerated()
//    }
//    .subscribe(onNext: {
//        print("\($0.index)번째 Observable의 요소: \($0.element)")
//    })
//    .disposed(by: disposeBag)

print("---delaySubscription---") // 구독 지연
//let delaySource = PublishSubject<String>()
//
//var delayCount = 0
//let delayTimeSource = DispatchSource.makeTimerSource()
//delayTimeSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//delayTimeSource.setEventHandler {
//    delayCount += 1
//    delaySource.onNext("\(delayCount)")
//}
//delayTimeSource.resume()
//
//delaySource
//    .delaySubscription(.seconds(5), scheduler: MainScheduler.instance) // 5초 지난 뒤 구독
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("---delay---")
//let delaySubject = PublishSubject<Int>()
//
//var delayCount = 0
//let delayTimeSource = DispatchSource.makeTimerSource()
//delayTimeSource.schedule(deadline: .now(), repeating: .seconds(1))
//delayTimeSource.setEventHandler {
//    delayCount += 1
//    delaySubject.onNext(delayCount)
//}
//delayTimeSource.resume()
//
//delaySubject
//    .delay(.seconds(5), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("---interval---")
//Observable<Int>
//    .interval(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("---timer---")
//Observable<Int>
//    .timer(.seconds(5), period: .seconds(2), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("---timeout---")
let 누르지않으면에러 = UIButton(type: .system)
누르지않으면에러.setTitle("눌러주세요!", for: .normal)
누르지않으면에러.sizeToFit()

PlaygroundPage.current.liveView = 누르지않으면에러

누르지않으면에러.rx.tap
    .do(onNext: {
        print("tap")
    })
    .timeout(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
