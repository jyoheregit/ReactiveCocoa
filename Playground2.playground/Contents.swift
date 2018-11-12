import ReactiveCocoa
import ReactiveSwift
import Result

let testScheduler = TestScheduler()

func getData() -> Signal<[String], NoError>{
    
    let array = ["joe", "ram"]
    
    let signal: Signal<[String], NoError> = Signal { observer, _ in
        testScheduler.schedule {
            observer.send(value: array)
            observer.sendCompleted()
        }
    }
    return signal
}

getData().observe { event in
    switch event {
    case let .value(array):
        print(array)
    case .completed:
        print("completed")
    default:
        print("interrupted")
    }
}

testScheduler.run()
