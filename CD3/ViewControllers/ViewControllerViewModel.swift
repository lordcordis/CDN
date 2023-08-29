//
//  ViewControllerViewModel.swift
//  CD3
//
//  Created by wheatley on 29.08.23.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

class ViewControllerViewModel {
    
    init() {
        manager = CoreDataManager.shared
//        appendSomeDataToCoreData()
        fetchData()
    }
    
    let manager: CoreDataManager
    
    var notes: [NoteEntity] = []
    
    func fetchData() {
        notes = []
        let request = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
        
        do {
            notes = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching data, \(error.localizedDescription)")
        }
    }
    
    func tagsDescriptionForNote(note: NoteEntity) -> String {
        var tagsArray = [TagEntity]()
        
        
        tagsArray = note.tags?.allObjects as! [TagEntity]
        var tagsStringsArray = [String]()
        
        switch tagsArray.isEmpty {
        case true:
            return "No tags"
        case false:
            
            switch tagsArray.count {
            case 1:
                guard let textForTag = tagsArray.first?.name else {return "Error"}
                return "Tag: \(textForTag)"
            default:
                
                for tag in tagsArray {
                    guard let name = tag.name else {return "Error"}
                    tagsStringsArray.append(name) }
                
                let output = tagsStringsArray.joined(separator: ", ")
                return "Tags: \(output)"
                
                
                
            }
                                               
            
        }
        
    }
    
    func deleteItem(item: NoteEntity) {
        manager.context.delete(item)
        manager.save()
        fetchData()
    }
    
    @objc func createNewItem(viewController: UIViewController) {
        let newItem = NoteEntity(context: manager.context)
        let viewModelForNewItem = NoteViewModel(note: newItem, isNewNote: true)
        viewModelForNewItem.delegate = viewController as? any dismissViewDelegate
        let viewForNewItem = NoteView(viewModel: viewModelForNewItem)
        let container = UIHostingController(rootView: viewForNewItem)
        viewController.navigationController?.pushViewController(container, animated: true)
    }
    
    
}
