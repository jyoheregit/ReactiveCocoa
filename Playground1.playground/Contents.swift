import ReactiveCocoa
import ReactiveSwift
import Result

class Generic<S, I> {
    
    var firstVar : S
    var secondVar : I
    
    init(firstVar : S, secondVar : I) {
        self.firstVar = firstVar
        self.secondVar = secondVar
    }
}

var test : Generic<String, Int> = Generic(firstVar: "Ten", secondVar: 10)
test.firstVar
test.secondVar

//Similar to Signal in ReactiveSwift with multiple generic arguments

class AnotherGeneric<Value, ErrorType : Swift.Error> {
    
    var value : Value
    var error : ErrorType
    
    init(value : Value, error : ErrorType) {
        self.value = value
        self.error = error
    }
}

enum NetworkError : Swift.Error {
    
    case NoNetwork
    case ParsingError
    case NoError
}

var anotherVar = AnotherGeneric(value: "Check", error: NetworkError.NoNetwork)
anotherVar.value
anotherVar.error

var anotherVar1 = AnotherGeneric(value: [1,2,3], error: NetworkError.NoError)
anotherVar1.value
anotherVar1.error

