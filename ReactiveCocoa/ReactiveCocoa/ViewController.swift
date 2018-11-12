//
//  ViewController.swift
//  ReactiveCocoa
//
//  Created by Joe on 10/11/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loginButton.isEnabled = false
        configureUI()
    }

    func configureUI() {
    
        username.reactive.continuousTextValues.observeValues { [weak self] value in
            
            guard let username = value else {return}
            //print(username)
        }
        
        username
            .reactive
            .continuousTextValues
            .combineLatest(with: password.reactive.continuousTextValues)
            .observeValues { [weak self] username, password in
            
            guard let username = username, let password = password else {return}
                print(username)
                print(password)
            self?.loginButton.isEnabled = (username.count > 2 && password.count > 2)
        }
        
        loginButton
            .reactive
            .controlEvents(UIControl.Event.touchUpInside)
            .observeValues { button in
                print("tapped")
            }
    }

}

