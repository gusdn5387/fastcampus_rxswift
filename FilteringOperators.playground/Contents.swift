import RxSwift

let disposeBag = DisposeBag()

print("---ignoreElements---")
let 취침모드 = PublishSubject<String>()

취침모드
    .ignoreElements()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

취침모드.onNext("🔊")
취침모드.onNext("🔊")
취침모드.onNext("🔊")
// ignoreElements는 onNext 무시함

취침모드.onCompleted()

print("---elementAt---")
let 두번울면깨는사람 = PublishSubject<String>()

두번울면깨는사람
    .element(at: 2) // 2번째 index만 처리
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

두번울면깨는사람.onNext("🔊") // index 0
두번울면깨는사람.onNext("🔊") // index 1
두번울면깨는사람.onNext("😀") // index 2
두번울면깨는사람.onNext("🔊") // index 3

print("---filter---")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .filter { $0 % 2 == 0 } // filter에 해당하는 값만 처리될 수 있도록
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---skip---")
Observable.of(1, 2, 3, 4, 5, 6)
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---skipWhile---")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .skip(while: {
        $0 != 7
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---skipUntil---")
let 손님 = PublishSubject<String>()
let 문여는시간 = PublishSubject<String>()

손님
    .skip(until: 문여는시간)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손님.onNext("1")
손님.onNext("2")

문여는시간.onNext("이랏샤이마세 ~~")
손님.onNext("3")

print("---take---") // skip에 반대. takeWhile과 takeUntil 존재
Observable.of(1, 2, 3, 4, 5)
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---enumerated---")
Observable.of("A", "B", "C", "D", "E")
    .enumerated() //tuple 생성
    .take(while: {
        $0.index < 3
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---distinctUntilChanged---")
Observable.of("저는", "저는", "앵무새", "앵무새", "앵무새", "앵무새", "입니다", "입니다", "입니다", "저는", "앵무새", "일까요?", "일까요?")
    .distinctUntilChanged() // 연달아 같은 값이 나올 경우 중복 방지해줌
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
