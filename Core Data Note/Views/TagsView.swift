//
//  TagsView.swift
//  CD3
//
//  Created by wheatley on 30.08.23.
//

import SwiftUI

struct TagsView: View {
    
    @StateObject var viewModel: TagsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        
        VStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack{
                    Text("Tags")
                        .font(.title)
                    Spacer()
                    Image(systemName: "xmark.circle")
                        .font(.headline)
                }
                .padding(.all)
            }
            
            List {
                ForEach(viewModel.allAvailableTagsInDatabase) { tag in
                    HStack {
                        Text(tag.name ?? "no text")
                            .font(.headline)
                        Spacer()
                        Text("\(String(tag.notes!.count))")
                            .font(.headline)
                    }
                }.onDelete { indexSet in
                    let index = indexSet.first!
                    let tagToDelete = viewModel.allAvailableTagsInDatabase[index]
                    viewModel.deleteTag(tag: tagToDelete)
                }
            }.listStyle(.inset)
                .overlay {
                    if viewModel.allAvailableTagsInDatabase.isEmpty {
                        ContentUnavailableView("No tags registered", systemImage: "tag.slash")
                    }
                }
        }
    }
}

//struct TagsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagsView()
//    }
//}
