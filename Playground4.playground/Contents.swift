import ReactiveCocoa
import ReactiveSwift
import Result

//Error

//flatMapError
//The flatMapError operator catches any failure that may occur on the input event stream,
//then starts a new SignalProducer in its place.

let (signal, observer) = Signal<String, NSError>.pipe()
let producer = SignalProducer(signal)

producer
    .flatMapError{error in SignalProducer(value: error.userInfo["error"] as? String ?? "Default Error")}
    .startWithValues {print($0)}

observer.send(value: "Hi")
let error = NSError(domain: "domain", code: 500, userInfo: ["error": "Error Occurred"])
observer.send(error: error)

print("********")
//Retrying
//The retry operator will restart the original SignalProducer on failure up to count times.

var tries = 0
let limit = 2
let error1 = NSError(domain: "domain", code: 0, userInfo: nil)
let producer1 = SignalProducer<String, NSError> { (observer, _) in
    tries += 1
    if tries <= limit {
        print(tries)
        observer.send(error: error1)
    } else {
        observer.send(value: "Success")
        observer.sendCompleted()
    }
}

producer1
    .on(failed: {e in print("Failure")})    // prints "Failure" twice
    .retry(upTo: 2)
    .start { event in
        switch event {
        case let .value(next):
            print(next)                     // prints "Success"
        case let .failed(error):
            print("Failed: \(error)")
        case .completed:
            print("Completed")
        case .interrupted:
            print("Interrupted")
        }
    }

// Map Error
// The mapError operator transforms the error of any failure in an event stream into a new error.

enum CustomError: String, Error {
    case foo = "Foo Error"
    case bar = "Bar Error"
    case other = "Other Error"
}

let (signal1, observer1) = Signal<String, NSError>.pipe()

signal1
    .mapError { (error: NSError) -> CustomError in
        switch error.domain {
        case "com.example.foo":
            return .foo
        case "com.example.bar":
            return .bar
        default:
            return .other
        }
    }
    .observeFailed { error in
        print(error.rawValue)
}

observer1.send(error: NSError(domain: "com.example.bar", code: 42, userInfo: nil))    // prints "Foo Error"

//Promote Error
//The promoteError operator promotes an event stream that does not generate failures into one that can.
//The given stream will still not actually generate failures, but this is useful because some operators to combine streams require the inputs to have matching error types.

let (numbersSignal, numbersObserver) = Signal<Int, NoError>.pipe()
let (lettersSignal, lettersObserver) = Signal<String, NSError>.pipe()

numbersSignal
    .promoteError(NSError.self)
    .combineLatest(with: lettersSignal)





