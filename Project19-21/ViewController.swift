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
		
//		If we're adding a new task
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

	@IBAction func unwindToTableView(_ segue: UIStoryboardSegue) {
		if segue.identifier == "unwindToTableView" {
//			If the textView is not empty, close the taskContoller and not add a new entry
			if let taskContent = taskContent {
				if didChangeText == nil {
					allTasks.append(SingleTask(taskText: taskContent, wasChanged: false))
					tableView.reloadData()
				} else if didChangeText == false {
					didChangeText = nil
					return
				} else if didChangeText == true {
					allTasks[cellIndex].wasChanged = true
					allTasks[cellIndex].taskText = taskContent
					didChangeText = nil
					tableView.reloadData()
				}

			}
		}
		
		if segue.identifier == "deleteAndUnwindToTableView" {
			allTasks.remove(at: cellIndex)
			tableView.reloadData()
		}
	}

	

}

