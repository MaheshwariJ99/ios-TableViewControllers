//
//  ViewController.swift
//  Task 5p
//
//  Created by Usha Juttu on 26/5/19.
//  Copyright © 2019 Usha Juttu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var FilterTF: UITextField!

    @IBOutlet weak var FilterB: UIButton!
    var actors:[ActorModel] = []{
        didSet{
            filteredActors = actors
        }
    }
    
    var filteredActors:[ActorModel] = []
    {
        didSet{
            tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        saveJsonFileToDocumentDirectory()
        readJsonFromDocumentDirectory()
        
        
        
    }
    func saveJsonFileToDocumentDirectory(){
        
        guard let filePath = Bundle.main.path(forResource: "actors", ofType: "json") else { return }//
        
        let fileManager = FileManager.default
        do {
            
            let jsonString = try String(contentsOfFile: filePath)
            
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent("actors.json")
            
            try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch{
            print(error)
        }
    }
    
    
    func readJsonFromDocumentDirectory(){
        let fileManager = FileManager.default
        do{
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent("actors.json")
            
            if fileManager.fileExists(atPath: fileURL.path){
                
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let actorsModel = try decoder.decode(ActorsModel.self, from: data)
                self.actors = actorsModel.actors
                
            }else{
                print("actors.json file not found in document directory")
            }
            
        }catch{
            print(error)
        }
    }
    
    

    @IBAction func segmentedcontrolchange(_ sender: UISegmentedControl) {
    self.view.endEditing(true)
        FilterTF.text = nil
        
        switch sender.selectedSegmentIndex {
        case 0:
            actors.sort { (actor1, actor2) -> Bool in
                return actor1.first < actor2.first
            }
            
        case 1:
            actors.sort { (actor1, actor2) -> Bool in
                return actor1.second < actor2.second
            }
            
        case 2:
            actors.sort { (actor1, actor2) -> Bool in
                return actor1.age < actor2.age
            }
            
        default:
            break
        }
        
        
    }
    
    
    @IBAction func filterBclicked(_ sender: Any) {
    self.view.endEditing(true)
        
        if let filterText = FilterTF.text, filterText.count > 0{
            switch segmentedController.selectedSegmentIndex {
            case 0:
                filteredActors =  actors.filter { (actor) -> Bool in
                    return actor.first.lowercased().contains(filterText.lowercased())
                }
                
            case 1:
                filteredActors =  actors.filter { (actor) -> Bool in
                    return actor.second.lowercased().contains(filterText.lowercased())
                }
                
            case 2:
                filteredActors =  actors.filter { (actor) -> Bool in
                    return actor.age.description.contains(filterText)
                }
                
            default:
                filteredActors =  actors.filter { (actor) -> Bool in
                    return actor.first.lowercased().contains(filterText.lowercased())
                }
            }
        }else{
            filteredActors = actors
        }
    }
    
    @IBAction func clearClicked(_ sender: Any) {
        self.view.endEditing(true)
        FilterTF.text = nil
        filteredActors =  actors
    }
    

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredActors.count
}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
        let actor = filteredActors[indexPath.row]
        cell.textLabel?.text = actor.first + " " + actor.second
        cell.detailTextLabel?.text = actor.age.description
        return cell
}
}
