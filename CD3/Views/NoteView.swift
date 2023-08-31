//
//  NoteView.swift
//  CD3
//
//  Created by wheatley on 28.08.23.
//

import SwiftUI



struct NoteView: View {
    
    @StateObject var viewModel: NoteViewModel
    
    var body: some View {
        
        Form {
            Section {
                TextEditor(text: $viewModel.text)
                    .multilineTextAlignment(.leading)
                    .onChange(of: viewModel.text) { newValue in
                        
                        withAnimation {
                            if newValue.isEmpty {
                                viewModel.saveButtonIsDisabled = true
                            } else {
                                viewModel.saveButtonIsDisabled = false
                            }
                        }
                    }
                    .frame(width: 300, height: 200, alignment: .leading)
                
                Button("Save note") {
                    viewModel.saveNote()
                }.disabled(viewModel.text.isEmpty ? true : false)
            }
                
            
            
            
                Section("Tags") {
                    
                    List {
                        ForEach(viewModel.tagsArray) { tag in
                            Text(tag.name ?? "")
                        }.onDelete { indexSet in
                            let index = indexSet.first!
                            let tag = viewModel.tagsArray[index]
                            viewModel.tagsArray.remove(at: index)
                            viewModel.removeTag(tag: tag)
                        }
                    }
                }
            
            

            
            Section("add tag") {
                
                TextField("Add tag name", text: $viewModel.newTagName)
                    .onChange(of: viewModel.newTagName) { newValue in
                        viewModel.checkIfTagAlreadyExistsForThisNote(name: newValue)
                        viewModel.checkIfTagAlreadyExistsInDatabase(name: newValue)
                    }
                
                HStack {
                    
                    Button("Save tag") {
                        
                        withAnimation {
                            viewModel.saveTagWith(name: viewModel.newTagName)
                            viewModel.newTagName = ""
                        }
                        


                        
                        
                    }
                    .disabled(viewModel.newTagName.isEmpty || viewModel.tagAlreadyExistsForThisNote)
                    
                    
                    Spacer()
                    if viewModel.tagAlreadyExistsForThisNote {
                        Label("Tag already exists", systemImage: "exclamationmark.triangle").foregroundColor(Color.yellow)
                    } else if viewModel.tagExistsInDatabase {
                        Image(systemName: "checkmark.circle").foregroundColor(Color.green)
                    }
                    
                    
                }

            }
            
        }
    }
}

protocol dismissViewDelegate: AnyObject {
    func dismiss()
    func appendNewNoteToSnapshot(note: NoteEntity)
    func reloadTableView()
}

//struct NoteView_Previews: PreviewProvider {
//    static var previews: some View {
////        NoteView(viewModel: NoteViewModel.sample)
//    }
//}
