//
//  TagsViewModel.swift
//  CD3
//
//  Created by wheatley on 30.08.23.
//

import Foundation
import CoreData

class TagsViewModel: ObservableObject {
    
    @Published var allAvailableTagsInDatabase: [TagEntity] = []
    let manager = CoreDataManager.shared
    weak var delegate: dismissViewDelegate?
    
    init() {
        fetchAllTags()
    }
    
    func deleteTag(tag: TagEntity) {
        manager.context.delete(tag)
        manager.save()
        fetchAllTags()
        delegate?.reloadTableView()
    }
    
    func fetchAllTags() {

        let request = NSFetchRequest<TagEntity>(entityName: "TagEntity")
        
        do {
            allAvailableTagsInDatabase = try manager.context.fetch(request)
        } catch let error {
            print("Error getting tags from core data, \(error.localizedDescription)")
        }
    }
    
}
