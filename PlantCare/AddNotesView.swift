//
//  AddNotesView.swift
//  PlantCare
//
//  Created by Admin on 11/05/2023.
//

import SwiftUI

struct AddNotesView: View {
    
    @State var cutomerNotes: String = ""
    var reminderItems: FetchedResults<Reminder>.Element
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Add Notes").font(.headline).padding(10)
            TextField("Enter Notes", text: $cutomerNotes) .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Save Notes") {
                
                reminderItems.note = cutomerNotes
                
                try? viewContext.save()
                
                presentationMode.wrappedValue.dismiss()
            }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity)
        }.padding(15).onAppear{
            //            fetch()
        }
        
    }
}

//struct AddNotesView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNotesView()
//    }
//}

