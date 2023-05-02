//
//  ContentView.swift
//  PlantCare
//
//  Created by Taimoor  on 24/04/2023.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Reminder.entity(),sortDescriptors: []) private var reminderItems: FetchedResults<Reminder>
    
    
    private func requestPermissions() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
//                    permissionGranted = true
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(reminderItems,id: \.self) { item in
                    HStack{
                        Image("plant")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                        VStack(alignment: .leading, spacing: 10) {
                            Text(verbatim: item.name ?? "-")
                            Text(verbatim: item.type ?? "-")
                            Text(verbatim: item.note ?? "-")
                        }.padding(10)
                    }
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Spacer().frame(maxWidth: .infinity,alignment: .leading)
                        Text("Plant Care").font(.headline).frame(maxWidth: .infinity,alignment: .center)
                        NavigationLink(destination: AddPlantView(viewContext: _viewContext)) {
                            Image(systemName: "plus")
                        }.frame(maxWidth: .infinity,alignment: .trailing)
                    }
                }
            }
        }.onAppear{
            requestPermissions()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DataManager())
    }
}
