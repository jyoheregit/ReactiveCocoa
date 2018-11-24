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
        //configureUI()
        setupUI()
    }
    
    func setupUI() {
        
        let userNameSignal = username.reactive.continuousTextValues.map { (name) -> Bool in
            return self.userNameValid(name: name)
        }
        
        userNameSignal.map { (valid) -> CGColor in
            return valid ? UIColor.green.cgColor : UIColor.red.cgColor
        }
        .skip(first: 1) // the number of times the subscriber should ignore the signal
        .observeValues { (color) -> Void in
            self.username.layer.borderWidth = 1.0
            self.username.layer.borderColor = color
        }
        
        let passwordSignal = password.reactive.continuousTextValues.map { (name) -> Bool in
            return self.passwordValid(name: name)
        }
        
        passwordSignal.map { (valid) -> CGColor in
            return valid ? UIColor.green.cgColor : UIColor.red.cgColor
        }
        .skip(first: 1)
        .observeValues { (color) -> Void in
            self.password.layer.borderWidth = 1.0
            self.password.layer.borderColor = color
        }
        
        Signal.combineLatest([userNameSignal,passwordSignal])
            .observeValues { (values) in
            
            self.loginButton.isEnabled = values[0] && values[1]
        }
    }
    
    func userNameValid(name : String?) -> Bool {
        return name != nil && name!.count > 2
    }

    func passwordValid(name : String?) -> Bool {
        return name != nil && name!.count > 2
    }
    
    func configureUI() {
    
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
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController")
                self.navigationController?.pushViewController(vc!, animated: true)
            }
    }

}

