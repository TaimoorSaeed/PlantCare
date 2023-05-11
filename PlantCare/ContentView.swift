//
//  ContentView.swift
//  PlantCare
//
//  Created by Admin  on 24/04/2023.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Reminder.entity(),sortDescriptors: [])
    private var reminderItems: FetchedResults<Reminder>
    @State var isInfoModal: Bool = false
    @State var isReminderModal: Bool = false
    private var selectedItem: FetchedResults<Reminder>.Element = Reminder.init()
//    @State var isReminderModal: Bool = false
    @State var id: Int = 0
    
    private func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                // permissionGranted = true
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
                        Image(uiImage: (UIImage(data: item.image ?? Data()) ?? UIImage(systemName: "photo.circle")) ?? UIImage())
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 70.0, height: 70.0)
                            .cornerRadius(50)
                        VStack(alignment: .leading, spacing: 10) {
                            Text(verbatim: item.name ?? "-")
                            Text(verbatim: item.type ?? "-")
                            Text(verbatim: item.note ?? "-")
                        }.padding(10)
                        VStack(spacing: 10) {
                            
                            Image(systemName: "bell").onTapGesture {
                                print("button B pressed")
                                isInfoModal = true
                            }.frame(maxWidth: .infinity, alignment: .trailing).sheet(isPresented: $isInfoModal, content: {
                                AddNotesView()
                            })
                            Image(systemName: "i.circle").onTapGesture {
                                print("button C pressed")
                                self.isReminderModal = true
                                print("*** \(item)")
                                id = item.id.hashValue
//                                selectedItem = item
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                                .sheet(isPresented: $isReminderModal, content: {
                                        AddReminderView(reminderItems: item)
//                                    }
                                    
                                })
                            Image(systemName: "trash").onTapGesture {
                                print("button A pressed")
                                viewContext.delete(item)
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
            }
            .overlay(Group {
                if reminderItems.isEmpty {
                    VStack{
                        Text("Add + button to add plants")
                        Image("plant")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                }
                
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Spacer().frame(maxWidth: .infinity,alignment: .leading)
                        Text("Plant Care").font(.headline).frame(maxWidth: .infinity,alignment: .center)
                        NavigationLink(destination: AddPlantView(viewContext: _viewContext,selectedItem: Reminder())) {
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environmentObject(DataManager())
//    }
//}
