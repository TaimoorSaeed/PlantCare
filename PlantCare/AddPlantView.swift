//
//  AddPlantView.swift
//  PlantCare
//
//  Created by Taimoor  on 24/04/2023.
//

import SwiftUI

struct AddPlantView: View {
    
    private func sendNotification() {
        let yourFireDate = selectedDate
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey:
                                                                    "Reminder", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Reminder for Test Task", arguments: nil)
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let dateComponents = Calendar.current.dateComponents(Set(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day), from: yourFireDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Your notification identifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                //handle error
            } else {
                //notification set up successfully
            }
        })
    }
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDate : Date = .now
    @State var nickName: String = ""
    @State var typeOfPlant : String = ""
    @State var cutomerNotes: String = ""
    @State var showImagePicker: Bool = false
    @State var image: UIImage? = UIImage()
    @State private var showingAlert = false
    @State private var alertMessage : String = ""
    @State var selectedItem = Reminder()
    
    var body: some View {
        VStack(alignment: .center,spacing: 30) {
            TextField("Enter Plant Nick Name...", text: $nickName).textFieldStyle(.roundedBorder)
            TextField("Type of Plant", text: $typeOfPlant).textFieldStyle(.roundedBorder)
            TextField("Add Notes", text: $cutomerNotes) .textFieldStyle(RoundedBorderTextFieldStyle())
            DatePicker("Reminder Date/Time",selection: $selectedDate, displayedComponents: [.date,.hourAndMinute])
            HStack{
                Button(action: {
                    self.showImagePicker.toggle()
                }) {
                    Text("Pick an image")
                }.sheet(isPresented: $showImagePicker) {
                    ImagePicker(sourceType: .photoLibrary) { image in
                        self.image = image
                    }
                }
                
                Image(uiImage: (self.image ?? UIImage(systemName: "photo.circle"))!)
                    .resizable()
                    .cornerRadius(75)
                    .padding(.all, 4)
                    .frame(width: 120, height: 120)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .padding(8)
            }
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
            
            Button("Save Reminder") {
                if nickName == "" {
                    showingAlert = true
                    alertMessage = "Please enter nick name"
                    return
                } else if typeOfPlant == "" {
                    showingAlert = true
                    alertMessage = "Please enter plant type"
                    return
                }
                else if cutomerNotes == "" {
                    showingAlert = true
                    alertMessage = "Please enter notes"
                    return
                }
                
                let pickedImage = image?.jpegData(compressionQuality: 1.0)
                
                if selectedItem.managedObjectContext != nil {
                    selectedItem.name = nickName
                    selectedItem.type = typeOfPlant
                    selectedItem.note = cutomerNotes
                    selectedItem.date = selectedDate
                    selectedItem.image = pickedImage
                    try? viewContext.save()
                } else {
                    let newTask = Reminder(context: viewContext)
                    newTask.name = nickName
                    newTask.type = typeOfPlant
                    newTask.note = cutomerNotes
                    newTask.date = selectedDate
                    newTask.image = pickedImage
                    try? viewContext.save()
                    sendNotification()
                }
                
                presentationMode.wrappedValue.dismiss()
            }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity)
        }.padding(20)
        .onAppear(perform: fetch)
    }
    
    private func fetch() {
        if selectedItem.managedObjectContext != nil {
                       print("***AAA \(selectedItem)")
                       nickName = selectedItem.name ?? ""
                       typeOfPlant = selectedItem.type ?? ""
                       cutomerNotes = selectedItem.note ?? ""
                       image =  UIImage(data: selectedItem.image ?? Data())
        } else {
            print("***CCC \(selectedItem)")
        }
    }
}

struct AddPlantView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlantView()
    }
}
