//
//  ViewController.swift
//  Project19-21
//
//  Created by Gitko Denis on 23.08.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	var allTasks = [SingleTask]()
	var taskContent: String?
	var didChangeText: Bool?
	var cellIndex: Int!

	@IBOutlet var tableView: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		let userDefaults = UserDefaults.standard
		if let savedData = userDefaults.object(forKey: "allTasks") as? Data {
			let jsonDecoder = JSONDecoder()
			
			do {
				allTasks = try jsonDecoder.decode([SingleTask].self, from: savedData)
			} catch {
				print("not decoded")
			}
			
		}
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allTasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
		
		var content = cell.defaultContentConfiguration()
		content.text = allTasks[indexPath.row].taskText
		cell.contentConfiguration = content
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let taskVC = segue.destination as! TaskController
		
		if segue.identifier == "showFullTaskSegue" {
			if let cell = sender as? UITableViewCell {
				if let indexPath = tableView.indexPath(for: cell) {
					taskVC.text = allTasks[indexPath.row].taskText
					taskVC.cellIndex = indexPath.row
					tableView.deselectRow(at: indexPath, animated: true)
				}
			}
		}
	}

//	If done is clicked
	@IBAction func unwindToTableView(_ segue: UIStoryboardSegue) {
		if segue.identifier == "unwindToTableView" {
//			If the textView is not nil, move on
			if let taskContent = taskContent {
//				If we return to table view with didChangeText set to nil, than means the task has been created right now, so we append it to the array 
				if didChangeText == nil {
					allTasks.append(SingleTask(taskText: taskContent, wasChanged: false))
					
					save()
					
					tableView.reloadData()
//					If we return to table view with didChangeText set to false, that means the task was created before and not changed now, so just put it back to nil and do nothing
				} else if didChangeText == false {
					didChangeText = nil
					return
				} else if didChangeText == true {
					allTasks[cellIndex].wasChanged = true
					allTasks[cellIndex].taskText = taskContent
					didChangeText = nil
					
					save()
					
					tableView.reloadData()
				}

			}
		}
		
		if segue.identifier == "deleteAndUnwindToTableView" {
			allTasks.remove(at: cellIndex)
			
			save()
			
			tableView.reloadData()
		}
	}
	
	func save() {
		let jsonEncoder = JSONEncoder()
		
		if let savedData = try? jsonEncoder.encode(allTasks) {
			let userDefaults = UserDefaults.standard
			userDefaults.set(savedData, forKey: "allTasks")
		}
	}

	

}

