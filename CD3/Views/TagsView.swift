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
        
        
        
        VStack{
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack{
                    Spacer()
                    Image(systemName: "xmark.circle")
                        .font(.headline)
                }
                .padding(.all)
                
                
                
                
            }
            
            
            List {
                ForEach(viewModel.allAvailableTagsInDatabase) { tag in
                    VStack(alignment: .leading) {
                        Text(tag.name ?? "no text")
                        Text("Notes associated: \(String(tag.notes!.count))")
                        Text("Identifier: "+String(tag.id.hashValue))
                            .font(Font.footnote)
                            .foregroundColor(Color.gray)
                    }
                    
                    
                }.onDelete { indexSet in
                    let index = indexSet.first!
                    let tagToDelete = viewModel.allAvailableTagsInDatabase[index]
                    viewModel.deleteTag(tag: tagToDelete)
                }
            }.listStyle(.inset)
            
        }
        
        
        
    }
}

//struct TagsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagsView()
//    }
//}
