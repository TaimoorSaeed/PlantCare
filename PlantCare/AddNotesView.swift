//
//  AddNotesView.swift
//  PlantCare
//
//  Created by Admin on 11/05/2023.
//

import SwiftUI

struct AddNotesView: View {
    
    @State var cutomerNotes: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            TextField("Add Notes", text: $cutomerNotes) .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Save Notes") {
                
            }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity)
        }.padding(15).onAppear{
            fetch()
        }
       
    }
    
    private func fetch() {
//        if selectedItem.managedObjectContext != nil {
//            print("***AAA \(selectedItem)")
//            nickName = selectedItem.name ?? ""
//            typeOfPlant = selectedItem.type ?? ""
//            cutomerNotes = selectedItem.note ?? ""
//            image =  UIImage(data: selectedItem.image ?? Data())
//        } else {
//            print("***CCC \(selectedItem)")
//        }
    }
}

struct AddNotesView_Previews: PreviewProvider {
    static var previews: some View {
        AddNotesView()
    }
}
