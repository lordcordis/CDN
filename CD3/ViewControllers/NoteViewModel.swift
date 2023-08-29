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
    
    func saveTag(tag: String) -> TagEntity {
        let newTag = TagEntity(context: manager.context)
        newTag.name = tag
        newTag.notes = NSSet(array: [note])
        manager.context.insert(newTag)
        manager.save()
        return newTag
    }
    
    func removeTag(tag: TagEntity) {
        note.removeFromTags(tag)
        manager.save()
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
