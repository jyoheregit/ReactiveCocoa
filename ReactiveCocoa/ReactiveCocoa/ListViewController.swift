//
//  ListViewController.swift
//  ReactiveCocoa
//
//  Created by Joe on 24/11/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class ListViewController : UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel = ViewModel()
    var names : [String] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
        getData()
    }
    
    func getData() {
        
        viewModel.getData().startWithSignal { (signal, disposable) -> () in
            signal.observeResult({ (result) in
                
                switch(result){
                    
                case .success(let value):
                    self.names = value
                    print(value)
                case .failure(let error):
                    print(error)
                }
            })
        
            signal.observeCompleted {
                print("Completed.....")
            }
        }
    }
}

extension ListViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }

    
}

class Cell : UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
