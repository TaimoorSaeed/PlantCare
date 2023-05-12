//
//  AddReminderView.swift
//  PlantCare
//
//  Created by Admin on 11/05/2023.
//

import SwiftUI

struct AddReminderView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var image: UIImage? = UIImage()
    //    @Binding var newValue: Reminder
    var reminderItems: FetchedResults<Reminder>.Element
    
    
    
    @State private var selectedDate : Date = .now
    @State var showImagePicker: Bool = false
    @State private var alertMessage : String = ""
    @State private var showingAlert = false
    @State var selectedItem = Reminder()
    
    
    var body: some View {
        
        VStack(spacing: 15) {
            Text("Add Reminder").font(.headline).padding(10)
            DatePicker("Reminder Date/Time",selection: $selectedDate, displayedComponents: [.date,.hourAndMinute])
            HStack{
                Button(action: {
                    self.showImagePicker.toggle()
                    //                    self.image = UIImage(data: reminderItems.image ?? Data()) ?? UIImage(systemName: "photo.circle") ?? UIImage()
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
                
                let pickedImage = image?.jpegData(compressionQuality: 1.0)
                
                reminderItems.date = selectedDate
                
                reminderItems.image = pickedImage
                
                try? viewContext.save()
                sendNotification(data: selectedDate)
                presentationMode.wrappedValue.dismiss()
            }
            //            .onAppear {
            //                print("ContentView appeared!")
            //    //            self.image = UIImage(data: reminderItems.image ?? Data()) ?? UIImage(systemName: "photo.circle") ?? UIImage()
            //            }
            
            
        }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity).padding(15)
    }
    
    private func sendNotification(data: Date) {
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
    
}


//
//struct AddReminderView_Previews: PreviewProvider {
//    static var previews: some View {
////        AddReminderView( newValue: Reminder())
//    }
//}


