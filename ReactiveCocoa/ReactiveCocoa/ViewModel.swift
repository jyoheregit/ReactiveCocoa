//
//  ViewModel.swift
//  ReactiveCocoa
//
//  Created by Joe on 24/11/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

enum AppError : Error {
    
    case NetworkError
    
}

class ViewModel {
    
    func getData() -> SignalProducer<[String], AppError> {
        
        return SignalProducer { (sink, disposable) in

                sink.send(value: ["Hi", "Hello"])
                // sink.send(error: AppError.NetworkError)
                sink.sendCompleted()
        }
 
        //Different ways of creating SignalProducer
        
        //return SignalProducer.init(value: ["Hello", "1"])
        
        /* return SignalProducer.init({ () -> [String] in
            return ["1","2","3"]
        }) */
        
        
//        let (signal, observer) = Signal<[String], AppError>.pipe()
//        let producer = SignalProducer.init(signal)
//        observer.send(value: ["One", "Two", "Three"])
//        observer.sendCompleted()
//        return producer
        
        
        
        
        
    }
}
