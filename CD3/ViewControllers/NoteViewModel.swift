//
//  NoteViewModel.swift
//  CD3
//
//  Created by wheatley on 29.08.23.
//

import Foundation

class NoteViewModel: ObservableObject {
    
    weak var delegate: dismissViewDelegate?
    
    let manager = CoreDataManager.shared
    let allTagsViewModel = TagsViewModel()
    private var note: NoteEntity
    private let isNewNote: Bool
    
    init(note: NoteEntity, isNewNote: Bool) {
        self.text = note.text ?? ""
        self.note = note
        self.isNewNote = isNewNote
        self.tagsArray = note.tags?.allObjects as! [TagEntity]
    }
    
    @Published var text = ""
    @Published var saveButtonIsDisabled = true
    @Published var tagsArray = [TagEntity]()
    @Published var newTagName = ""
    @Published var saveTagButtonIsDisabled = true
    @Published var tagAlreadyExistsForThisNote = false
    @Published var tagExistsInDatabase = false
    
    func saveTag(tag: String) {
        let newTag = TagEntity(context: manager.context)
        newTag.name = tag
        tagsArray.append(newTag)
        newTag.addToNotes(note)
        manager.context.insert(newTag)
        manager.save()
    }
    
    
    func saveTagWith(name: String) {
        if let tag = checkIfTagAlreadyExistsInDatabase(name: name) {
            note.addToTags(tag)
            tagsArray.append(tag)
            manager.save()
        } else {
            saveTag(tag: name)
        }
    }
    
    func removeTag(tag: TagEntity) {
        note.removeFromTags(tag)
        manager.save()
    }
    
    @discardableResult
    func checkIfTagAlreadyExistsForThisNote(name: String) -> TagEntity? {
        
        var output: TagEntity?
        
        for tag in tagsArray {
            if tag.name == name {
                output = tag
                break
            } else {
                output = nil
            }
        }
        
        if let output = output {
            tagAlreadyExistsForThisNote = true
        } else {
            tagAlreadyExistsForThisNote = false
        }
        
        return output
        
    }
    
    @discardableResult
    func checkIfTagAlreadyExistsInDatabase(name: String) -> TagEntity? {
        
        var output: TagEntity?
        
        for tag in allTagsViewModel.allAvailableTagsInDatabase {
            if tag.name == name {
                output = tag
                break
            } else {
                output = nil
            }
        }
        
        if let output = output {
            tagExistsInDatabase = true
        } else {
            tagExistsInDatabase = false
        }
        
        return output
        
    }
    
    
    
    func saveNote() {
        note.text = text
        
        switch isNewNote {
            
        case true:
            manager.context.insert(note)
            delegate?.appendNewNoteToSnapshot(note: note)
        case false:
            manager.context.refresh(note, mergeChanges: true)
        }
        
        manager.save()
        delegate?.dismiss()
    }
    

}
