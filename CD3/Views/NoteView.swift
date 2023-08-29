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
                TextField("Text Here", text: $viewModel.text)
                    .padding(.all)
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
                    .onChange(of: viewModel.text) { newValue in
                        
                        withAnimation {
                            if newValue.isEmpty {
                                viewModel.saveButtonIsDisabled = true
                            } else {
                                viewModel.saveButtonIsDisabled = false
                            }
                        }
                    }
                
                Button("Save note") {
                    viewModel.saveNote()
                }.disabled(viewModel.text.isEmpty ? true : false)
            }
                
            
            Section() {
                
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
                Button("Save tag") {
                    let newTag = viewModel.saveTag(tag: viewModel.newTagName)
                    viewModel.tagsArray.append(newTag)
                    viewModel.newTagName = ""
                }
                .disabled(viewModel.newTagName.isEmpty ? true : false)
                
                
                
                
            }

            
            
                
            
            
            

            
                


            
            
            
            
        }
    }
}

protocol dismissViewDelegate: AnyObject {
    func dismiss()
    func appendNewNoteToSnapshot(note: NoteEntity)
}

//struct NoteView_Previews: PreviewProvider {
//    static var previews: some View {
////        NoteView(viewModel: NoteViewModel.sample)
//    }
//}
