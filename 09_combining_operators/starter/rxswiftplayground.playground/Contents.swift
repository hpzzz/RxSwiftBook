import Foundation
import RxSwift
import PlaygroundSupport

// Start coding here!
example(of: "startWith") {
  // 1
  let numbers = Observable.of(2, 3, 4)

  // 2
  let observable = numbers.startWith(1)
  _ = observable.subscribe(onNext: { value in
    print(value)
  })
}

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

example(of: "startWith") {
    let numbers = Observable.of(2, 3, 4)
    
    let observable = numbers.startWith(1)
        .subscribe(onNext: { value in
            print(value)
        })
}

example(of: "Observable.concat") {
    
    let first = Observable.of(1, 2, 3)
    let second = Observable.of(4, 5, 6)
    
    let observable = Observable.concat([first, second])
        .subscribe(onNext: {
            print($0)
        })
}

example(of: "concat") {
    let germanCities = Observable.of("Berlin", "Munich", "Dortmund")
    let polishCities = Observable.of("Warsaw", "Cracow", "Nisko")
    
    let observable = germanCities.concat(polishCities)
        .subscribe(onNext: {
            print($0)
        })
}

example(of: "concatMap") {
    let sequences = [
        "German cities": Observable.of("Berlin", "Munich", "Frankfurt"),
        "Spanish cities": Observable.of("Madrid", "Barcelona", "Valencia")]
    
    let observable = Observable.of("German cities", "Spanish cities")
        .concatMap { country in sequences[country] ?? .empty() }
    
    _ = observable.subscribe(onNext: {
        print($0)
    })
}

example(of: "merge") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    let source = Observable.of(left.asObservable(), right.asObservable())
    
    let observable = source.merge()
    let disposable = observable.subscribe(onNext: {
        print($0)
    })
    
    var leftValues = ["Berlin", "Munich", "Dortmund"]
    var rightValues = ["Warsaw", "Cracow", "Nisko"]
    
    // randomly push values to either observable
    repeat {
        switch Bool.random() {
        case true where !leftValues.isEmpty:
            left.onNext("Left: " + leftValues.removeFirst())
        case false where !rightValues.isEmpty:
            right.onNext("Right: " + rightValues.removeFirst())
        default:
            break
        }
        
    } while !leftValues.isEmpty || !rightValues.isEmpty
    
    left.onCompleted()
    right.onCompleted()
}

example(of: "combineLatest") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    let observable = Observable.combineLatest(left, right) {
        lastLeft, lastRight in
        "\(lastLeft) \(lastRight)"
    }
    
    let disposable = observable.subscribe(onNext: {
        print($0)
    })
    
    print("> Sending a value to Left")
    left.onNext("Hello, ")
    
    print("> Sending a value to Right")
    right.onNext("world")
    
    print("> Sending another value to Right")
    right.onNext("RxSwift")
    
    print("> Sending another value to Left")
    left.onNext("Have a good day")
    
    left.onCompleted()
    right.onCompleted()
}

example(of: "combine user choice and value") {
    let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long, .full)
    let dates = Observable.of(Date(), Date(timeIntervalSinceNow: 100000), Date(timeIntervalSinceNow: 100000000))
    
    let observable = Observable.combineLatest(choice, dates) {
        format, when -> String in
        let formatter = DateFormatter()
        formatter.dateStyle = format
        return formatter.string(from: when)
    }
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "zip") {
    enum Weather {
        case cloudy
        case sunny
    }
    enum myError: Error {
        case anError
    }
    
    let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
    let right = Observable.of("Lisbon", "London", "Warsaw", "San Jose")
    
    let observable = Observable.zip(left, right) { weather, city in
        return "It's \(weather) in \(city)"
    }
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}
// withLatestFrom takes observable as a parameter
example(of: "withLatestFrom") {
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()
    
    let observable = button.withLatestFrom(textField)
    _ = observable.subscribe(onNext: {
        print($0)
    })
    textField.onNext("Par")
    button.onNext(())
    textField.onNext("Pari")
    textField.onNext("Paris")
    
    button.onNext(())
    button.onNext(())
    button.onNext(())
    button.onNext(())
}
// sample takes the trigger as a parameter

example(of: "sample") {
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()
    
    let observable = textField.sample(button)
    _ = observable.subscribe(onNext: {
        print($0)
    })
    textField.onNext("Par")
    button.onNext(())
    textField.onNext("Pari")
    textField.onNext("Paris")
    
    button.onNext(())
    button.onNext(())
    button.onNext(())
    button.onNext(())
}

example(of: "amb") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    let observable = left.amb(right)
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })
    

    right.onNext("Copenhagen")
    left.onNext("Lisbon")
    left.onNext("London")
    left.onNext("Madrid")
    right.onNext("Vienna")
    
    left.onCompleted()
    right.onCompleted()
    
}

example(of: "switchLatest") {
    let one = PublishSubject<String>()
    let two = PublishSubject<String>()
    let three = PublishSubject<String>()
    
    let source = PublishSubject<Observable<String>>()
    
    let observable = source.switchLatest()
    let disposable = observable.subscribe(onNext: {
        print($0)
    })
    
    one.onNext("1")
    two.onNext("2")
    
    source.onNext(two)
    
    one.onNext("1")
    two.onNext("2")
    
    source.onNext(three)
    
    one.onNext("1")
    two.onNext("2")
    three.onNext("3")
    
    disposable.dispose()
}

// reduce produces its summary value only when source observable completes
example(of: "reduce") {
    let source = Observable.of(1, 3, 5, 7, 9)
    
    let observable = source.reduce(0) { summary, newValue in
        return summary + newValue
    }
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "scan") {
    let source = Observable.of(1, 3, 5, 7, 9)
    
    let observable = source.scan(0, accumulator: +)
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

