import RxSwift

let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

print("---Single1---")
Single<String>.just("😀")
    .subscribe(onSuccess: {
        print($0)
    }, onFailure: {
        print("error: \($0)")
    }, onDisposed: {
        print("Disposed")
    })
    .disposed(by: disposeBag)

print("---Single2---")
Observable<String>
    .create { observer -> Disposable in
        observer.onError(TraitsError.single)
        return Disposables.create()
    }
    .asSingle()
    .subscribe(onSuccess: {
        print($0)
    }, onFailure: {
        print("error: \($0.localizedDescription)")
    }, onDisposed: {
        print("Disposed")
    })
    .disposed(by: disposeBag)

print("---Single3---")
struct SomeJSON: Decodable {
    let name: String
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name":"park"}
    """

let json2 = """
    {"my_name":"woo"}
    """

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data)
                  else {
                      observer(.failure(JSONError.decodingError))
                      return Disposables.create()
                  }
        
        observer(.success(json))
        return Disposables.create()
    }
}

decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

print("---Maybe1---")
Maybe<String>.just("😀")
    .subscribe(onSuccess: {
        print($0)
    }, onError: {
        print("error: \($0)")
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    })
    .disposed(by: disposeBag)

print("---Maybe2---")
let t = Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe(onSuccess: {
    print($0)
}, onError: {
    print("error: \($0)")
}, onCompleted: {
    print("Completed")
}, onDisposed: {
    print("Disposed")
})
.disposed(by: disposeBag)

print("---Completable1---")
Completable.create { observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(onCompleted: {
    print("Completed")
}, onError: {
    print("error: \($0)")
}, onDisposed: {
    print("Disposed")
})
.disposed(by: disposeBag)

print("---Completable2---")
Completable.create { observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)
