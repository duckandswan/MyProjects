//
//  ViewController.swift
//  MyProjects
//
//  Created by Song Bo on 24/04/2018.
//  Copyright © 2018 Song Bo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let names:[String] = ["algorithms","games"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch names[indexPath.row] {
        case "algorithms":
            break
        case "games":
            break
        default:
            break
        }
    }
    
    
}

