import Foundation
import RxSwift



/*:
 Copyright (c) 2019 Razeware LLC

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 distribute, sublicense, create a derivative work, and/or sell copies of the
 Software in any work that is designed, intended, or marketed for pedagogical or
 instructional purposes related to programming, coding, application development,
 or information technology.  Permission for such use, copying, modification,
 merger, publication, distribution, sublicensing, creation of derivative works,
 or sale is expressly withheld.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

example(of: "just, of, from") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable = Observable<Int>.just(one)
    let observable2 = Observable.of(one, two, three)
    let observable3 = Observable.of([one, two, three])
    let observable4 = Observable.from([one, two, three])
    
}

example(of: "subscribe") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable = Observable.of(one, two, three)
    
    observable.subscribe(onNext: { element in
        print(element)
    })
    
}

example(of: "empty") {
    let observable = Observable<Void>.empty()
    
    observable.subscribe(
        onNext: { element in
            print(element)
    },
        onCompleted: {
            print("Completed")
    })
}

example(of: "never") {
    let observable = Observable<Any>.never()
    
    observable.subscribe(
        onNext: { element in
            print(element)
    },
        onCompleted: {
            print("Completed")
    })
}

example(of: "range") {
    let observable = Observable<Int>.range(start: 1, count: 10)
    
    observable.subscribe(
        onNext: { i in
            let n = Double(i)
            let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
            print(fibonacci)
    },
        onCompleted: {
            print("Completed")
    })
}

example(of: "dispose") {
  // 1
    let observable = Observable.of("A", "B", "C")
// 2
    let subscription = observable.subscribe { event in // 3
    print(event)
  }
    subscription.dispose()
}

example(of: "DisposeBag") {
  // 1
  let disposeBag = DisposeBag()
// 2
    Observable.of("A", "B", "C")
        .subscribe { // 3
            print($0)
    }
        .disposed(by: disposeBag) // 4
}

example(of: "create") {
    let disposeBag = DisposeBag()
    
    enum MyError: Error {
        case anError
    }
    
    Observable<String>.create { observer in
        
        observer.onNext("1")
        
//        observer.onError(MyError.anError)
//
//        observer.onCompleted()
        
        observer.onNext("?")
        
        return Disposables.create()
    }
    .subscribe(
    onNext: { print($0) },
    onError: { print($0) },
    onCompleted: { print("Completed") },
    onDisposed: { print("Disposed") }
    )
    .disposed(by: disposeBag)
}


// observable factories that vend a new observable to each subscriber

example(of: "deferred") {
    let disposeBag = DisposeBag()

    var flip = false

    let factory: Observable<Int> = Observable.deferred {
        flip.toggle()

        if flip {
            return Observable.of(1, 2, 3)
        } else {
            return Observable.of(4, 5, 6)
        }
    }
    
    for _ in 0...3 {
        factory.subscribe(onNext: {
            print($0, terminator: "")
        })
            .disposed(by: disposeBag)
        
        print()
        
    }

}


example(of: "Single") {
    let disposeBag = DisposeBag()
    
    enum FileReadError: Error {
        case fileNotFound, unreadable, ecnodingFailed
    }
    
    func loadText(from name: String) -> Single<String> {
        // create must return a disposable
        return Single.create { single in
            
            let disposable = Disposables.create()
            
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.error(FileReadError.fileNotFound))
                return disposable
            }
            
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.error(FileReadError.unreadable))
                return disposable
            }
            
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.error(FileReadError.ecnodingFailed))
                return disposable
            }
            
            single(.success(contents))
            return disposable
        }
    }
    
    loadText(from: "Copyright")
        .subscribe {
            switch $0 {
            case .success(let string):
                print(string)
            case .error(let error):
                print(error)
            }
    }
.disposed(by: disposeBag)
}
