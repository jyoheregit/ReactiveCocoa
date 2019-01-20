import ReactiveCocoa
import ReactiveSwift
import Result

//Mapping

let (signal, observer) = Signal<String, NoError>.pipe()

signal
    .map { string in string.uppercased() }
    .observeValues { value in print(value) }

observer.send(value: "a")     // Prints A
observer.send(value: "b")     // Prints B
observer.send(value: "c")

//Filtering

let (signal1, observer1) = Signal<Int, NoError>.pipe()

signal1
    .filter { $0%2 == 0 }
    .observeValues { print($0) }

signal1
    .filter { $0%2 == 0 }
    .observeValues { print("Another Observer \($0)") }

observer1.send(value: 1)
observer1.send(value: 2)

//Aggregating

let (signal2, observer2) = Signal<Int, NoError>.pipe()

signal2
    .reduce(2) { $0 * $1 } //2 specified in argument is initial results
    .observeValues { value in print(value) }

observer2.send(value: 1)     // nothing printed
observer2.send(value: 2)     // nothing printed
observer2.send(value: 3)     // nothing printed
observer2.send(value: 4)
observer2.sendCompleted()   // prints 6

let (signal3, observer3) = Signal<Int, NoError>.pipe()

signal3
    .collect()
    .observeValues { value in print(value) }

observer3.send(value: 1)     // nothing printed
observer3.send(value: 2)     // nothing printed
observer3.send(value: 3)     // nothing printed
observer3.sendCompleted()   // prints [1, 2, 3]

//Combining Event Streams

let (numbersSignal, numbersObserver) = Signal<Int, NoError>.pipe()
let (lettersSignal, lettersObserver) = Signal<String, NoError>.pipe()

let signal4 = Signal.combineLatest(numbersSignal, lettersSignal)
signal4.observeValues { next in print("Next: \(next)") }
signal4.observeCompleted { print("Completed") }

numbersObserver.send(value: 0)      // nothing printed
numbersObserver.send(value: 1)      // nothing printed
lettersObserver.send(value: "A")    // prints (1, A)
numbersObserver.send(value: 2)      // prints (2, A)
numbersObserver.sendCompleted()  // nothing printed
lettersObserver.send(value: "B")    // prints (2, B)
lettersObserver.send(value: "C")    // prints (2, C)
lettersObserver.sendCompleted()  // prints "Completed" when both observers are sent completed

//Zipping

//The zip function joins values of two (or more) event streams pair-wise.
//The elements of any Nth tuple correspond to the Nth elements of the input streams.
//That means the Nth value of the output stream cannot be sent until each input has sent at least N values.

let (numbersSignal1, numbersObserver1) = Signal<Int, NoError>.pipe()
let (lettersSignal1, lettersObserver1) = Signal<String, NoError>.pipe()

let signal5 = Signal.zip(numbersSignal1, lettersSignal1)
signal5.observeValues { next in print("Next: \(next)") }
signal5.observeCompleted { print("Completed") }

numbersObserver1.send(value: 0)      // nothing printed
numbersObserver1.send(value: 1)      // nothing printed
lettersObserver1.send(value: "A")    // prints (0, A)
numbersObserver1.send(value: 2)      // nothing printed
numbersObserver1.sendCompleted()  // nothing printed
lettersObserver1.send(value: "B")    // prints (1, B)
lettersObserver1.send(value: "C")    // prints (2, C) & "Completed"

//Merge
//The .merge strategy immediately forwards every value of the inner event streams to the outer event stream.
//Any failure sent on the outer event stream or any inner event stream is immediately sent on the flattened event stream and terminates it.

let (lettersSignal2, lettersObserver2) = Signal<String, NoError>.pipe()
let (numbersSignal2, numbersObserver2) = Signal<String, NoError>.pipe()
let (signal6, observer4) = Signal<Signal<String, NoError>, NoError>.pipe()

signal6.flatten(.merge).observeValues { print($0) }

observer4.send(value: lettersSignal2)
observer4.send(value: numbersSignal2)
observer4.sendCompleted()

lettersObserver2.send(value: "a")    // prints "a"
numbersObserver2.send(value: "1")    // prints "1"
lettersObserver2.send(value: "b")    // prints "b"
numbersObserver2.send(value: "2")    // prints "2"
lettersObserver2.send(value: "c")    // prints "c"
numbersObserver2.send(value: "3")    // prints "3"

print("------------------------------")

//Concat
//The .concat strategy is used to serialize events of the inner event streams.
//The outer event stream is started observed. Each subsequent event stream is not observed until the preceeding one has completed.
//Failures are immediately forwarded to the flattened event stream.

let (lettersSignal3, lettersObserver3) = Signal<String, NoError>.pipe()
let (numbersSignal3, numbersObserver3) = Signal<String, NoError>.pipe()
let (signal7, observer7) = Signal<Signal<String, NoError>, NoError>.pipe()

signal7.flatten(.concat).observeValues { print($0) }

observer7.send(value: lettersSignal3)
observer7.send(value: numbersSignal3)
observer7.sendCompleted()

numbersObserver3.send(value: "1")    // nothing printed
lettersObserver3.send(value: "a")    // prints "a"
lettersObserver3.send(value: "b")    // prints "b"
numbersObserver3.send(value: "2")    // nothing printed
lettersObserver3.send(value: "c")    // prints "c"
lettersObserver3.sendCompleted()     // nothing printed
numbersObserver3.send(value: "3")    // prints "3"
numbersObserver3.sendCompleted()     // nothing printed

print("***************")

//latest
// The .latest strategy forwards only values or a failure from the latest input event stream.

let (lettersSignal4, lettersObserver4) = Signal<String, NoError>.pipe()
let (numbersSignal4, numbersObserver4) = Signal<String, NoError>.pipe()
let (signal8, observer8) = Signal<Signal<String, NoError>, NoError>.pipe()

signal8.flatten(.latest).observeValues { print($0) }

observer8.send(value: lettersSignal4) // nothing printed
numbersObserver4.send(value: "1")    // nothing printed
lettersObserver4.send(value: "a")    // prints "a"
lettersObserver4.send(value: "b")    // prints "b"
numbersObserver4.send(value: "2")    // nothing printed
observer8.send(value: numbersSignal4) // nothing printed
lettersObserver4.send(value: "c")    // nothing printed
numbersObserver4.send(value: "3")    // prints "3"

