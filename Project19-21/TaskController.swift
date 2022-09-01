//
//  TaskController.swift
//  Project19-21
//
//  Created by Gitko Denis on 23.08.2022.
//

import UIKit

extension String {
	var nilIfEmpty: String? {
		self.isEmpty ? nil : self
	}
}

class TaskController: UIViewController {
	@IBOutlet var textView: UITextView!
	@IBOutlet var deleteBtn: UIBarButtonItem!
	@IBOutlet var shareBtn: UIBarButtonItem!
	
	var text: String?
	var cellIndex: Int?
	var allTasks = [SingleTask]()
	
    override func viewDidLoad() {
			super.viewDidLoad()
			
			textView.text = text
			
			deleteBtn.isEnabled = false
			deleteBtn.tintColor = .white
			
//			If there is a cell index, that means the task already exists in the table view
			if cellIndex != nil {
				deleteBtn.isEnabled = true
				deleteBtn.tintColor = .systemBlue
			}
    }
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let tableVC = segue.destination as! ViewController
		
		//			This property is nil if the textView is empty, so if it is nil then a new note won't be created
		tableVC.taskContent = textView.text.nilIfEmpty
		
		tableVC.cellIndex = cellIndex
		
		if segue.identifier == "unwindToTableView" {
			if cellIndex != nil {
				if textView.text != text {
					tableVC.didChangeText = true
				} else {
					tableVC.didChangeText = false
			 }
			}
		}
	}
	

	@IBAction func shareTapped(_ sender: Any) {
		print("share tapped")
		let items = [textView.text]
		let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
		present(ac, animated: true)
	}
	
}
