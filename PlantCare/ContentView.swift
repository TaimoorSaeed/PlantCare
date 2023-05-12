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
    @State var isNotesModal: Bool = false
    @State var selectedItem: FetchedResults<Reminder>.Element
    //    @State var isReminderModal: Bool = false
    @State var id: Int = 0
    //    @State reminderItem: FetchedResults<Reminder>.Element =
    
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
                                
                                print("*** \(item)")
//                                id = item.id.hashValue
                                self.selectedItem = item
                                self.isNotesModal = true
                                
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                            //                                .sheet(isPresented: $isInfoModal, content: {
                            //                                AddNotesView(reminderItems: item)
                            //                            })
                            Image(systemName: "i.circle").onTapGesture {
                                print("button C pressed")
                               
                                print("*** \(item)")
//                                id = item.id.hashValue
                                self.selectedItem = item
                                self.isReminderModal = true
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                            Image(systemName: "trash").onTapGesture {
                                print("button A pressed")
                                viewContext.delete(item)
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }.listRowBackground(Color(hex: 0x8cd959))
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
        }
        .onAppear{
            requestPermissions()
        }
        .sheet(isPresented: $isReminderModal, content: {
//            print("*** \(selectedItem)")
            AddReminderView(reminderItems: selectedItem)
        })
        .sheet(isPresented: $isNotesModal, content: {
            //AddReminderView(reminderItems: selectedItem)
//            print("*** \(selectedItem)")
            
            AddNotesView(reminderItems: $selectedItem)
        })
        
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environmentObject(DataManager())
//    }
//}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}


