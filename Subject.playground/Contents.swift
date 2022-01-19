import RxSwift

let disposeBag = DisposeBag()

print("---publishsubject--")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("1. 여러분 안녕하세요?")
    
let 구독자1 = publishSubject
    .subscribe(onNext: {
        print("첫번째 구독: ", $0)
    })

publishSubject.onNext("2. 들리세요?")
publishSubject.on(.next("3. 안들리세요?"))

구독자1.dispose()

let 구독자2 = publishSubject
    .subscribe(onNext: {
        print("두번째 구독: ", $0)
    })

publishSubject.onNext("4. 여보세요?")
publishSubject.onCompleted()

publishSubject.onNext("5. 끝났나요?")

구독자2.dispose()

publishSubject
    .subscribe {
        print("세번째 구독: ", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

publishSubject.onNext("6. 찍힐까요?")

print("---behaviorsubject---")

enum SubjectError: Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "초기값")

behaviorSubject.onNext("1. 첫번째값")
behaviorSubject.subscribe {
    print("첫번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

//behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe {
    print("두번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

let value = try? behaviorSubject.value()
print(value)

print("---ReplaySubject---")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("1. 여러분")
replaySubject.onNext("2. 힘내세요")
replaySubject.onNext("3. 화이팅")

replaySubject.subscribe {
    print("첫번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe {
    print("두번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("4. 끝나간다")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject.subscribe {
    print("세번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)
