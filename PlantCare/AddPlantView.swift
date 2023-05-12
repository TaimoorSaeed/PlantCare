//
//  AddPlantView.swift
//  PlantCare
//
//  Created by Admin  on 24/04/2023.
//

import SwiftUI

struct AddPlantView: View {
    
    
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDate : Date = .now
    @State var nickName: String = ""
    @State var typeOfPlant : String = "Loading Plants..."
    @State var cutomerNotes: String = ""
    @State var showImagePicker: Bool = false
    @State var image: UIImage? = UIImage()
    @State private var showingAlert = false
    @State private var alertMessage : String = ""
    @State var selectedItem = Reminder()
    
    //    @State var plants = Plants(
    @State var books = [Datum]()
    @State private var showPicker = false
    
    
    var body: some View {
        
        Text("Add Plant").font(.headline).padding(10)
        VStack(alignment: .center,spacing: 30) {
            TextField("Enter Plant Nick Name...", text: $nickName).textFieldStyle(.roundedBorder)
            
            VStack(spacing: 10) {
                HStack(spacing: 10){
                    Text("Select Plant: ")
                    Picker("Appearance", selection: $typeOfPlant) {
                        ForEach(0 ..< books.count ,id: \.self) { book in
//                            nickName = books[book].commonName as! String
                            let commonName = books[book].commonName as! String
//                            nickName = commonName
                            Text(commonName).tag(commonName)
//                            return Text(commonName)
//                            nickName = commonName
                        }
                    }
                }
                Button("Save Plant") {
                    let newTask = Reminder(context: viewContext)
                    newTask.name = nickName
                    newTask.type = typeOfPlant
                    try? viewContext.save()
                    presentationMode.wrappedValue.dismiss()
                }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity)
            }.padding(15)
            
                
//            }
                    
//                }
//            }
            //            Picker("Appearance", selection: $typeOfPlant) {
            //                ForEach(0 ..< books.count) { book in
            //                    var book = book as? Datum
            //                //  book?.commonName
            //                    Text(book?.commonName ?? "")
            //                }
            //            }
            //            TextField("Add Notes", text: $cutomerNotes) .textFieldStyle(RoundedBorderTextFieldStyle())
            //            DatePicker("Reminder Date/Time",selection: $selectedDate, displayedComponents: [.date,.hourAndMinute])
            //            HStack{
            //                Button(action: {
            //                    self.showImagePicker.toggle()
            //                }) {
            //                    Text("Pick an image")
            //                }.sheet(isPresented: $showImagePicker) {
            //                    ImagePicker(sourceType: .photoLibrary) { image in
            //                        self.image = image
            //                    }
            //                }
            //
            //                Image(uiImage: (self.image ?? UIImage(systemName: "photo.circle"))!)
            //                    .resizable()
            //                    .cornerRadius(75)
            //                    .padding(.all, 4)
            //                    .frame(width: 120, height: 120)
            //                    .background(Color.black.opacity(0.2))
            //                    .aspectRatio(contentMode: .fill)
            //                    .clipShape(Circle())
            //                    .padding(8)
            //            }
            //            .alert(alertMessage, isPresented: $showingAlert) {
            //                Button("OK", role: .cancel) { }
            //            }
            
            //            Button("Save Reminder") {
            //                if nickName == "" {
            //                    showingAlert = true
            //                    alertMessage = "Please enter nick name"
            //                    return
            //                } else if typeOfPlant == "" {
            //                    showingAlert = true
            //                    alertMessage = "Please enter plant type"
            //                    return
            //                }
            //                else if cutomerNotes == "" {
            //                    showingAlert = true
            //                    alertMessage = "Please enter notes"
            //                    return
            //                }
            //
            //                let pickedImage = image?.jpegData(compressionQuality: 1.0)
            //
            //                if selectedItem.managedObjectContext != nil {
            //                    selectedItem.name = nickName
            //                    selectedItem.type = typeOfPlant
            //                    selectedItem.note = cutomerNotes
            //                    selectedItem.date = selectedDate
            //                    selectedItem.image = pickedImage
            //                    try? viewContext.save()
            //                } else {
            //                    let newTask = Reminder(context: viewContext)
            //                    newTask.name = nickName
            //                    newTask.type = typeOfPlant
            //                    newTask.note = cutomerNotes
            //                    newTask.date = selectedDate
            //                    newTask.image = pickedImage
            //                    try? viewContext.save()
            //                    sendNotification()
            //                }
            //
            //                presentationMode.wrappedValue.dismiss()
            //            }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity)
        }.padding(20)
            .onAppear(perform: fetch)
            .onAppear() {
                Api().loadData { (books) in
                    print("**** AA \(books.count)")
                    self.typeOfPlant = books.first?.commonName ?? ""
                    self.books = books
                    showPicker = true
                }
            }
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


class Api : ObservableObject{
    @Published var booksN = [Datum]()
    
    func loadData(completion:@escaping ([Datum]) -> ()) {
        guard let url = URL(string: "https://trefle.io/api/v1/plants?token=ldiFAQn9l0MRfTBdmC9i5noQmxwy_DnpaQ9_04J9Ols") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("JSON \(data) \(response)")
            let books = try! JSONDecoder().decode(Plants.self, from: data!)
            print("**** \(books.data)")
            DispatchQueue.main.async {
                completion(books.data!)
//                self.booksN = books.data!
                
            }
        }.resume()
        
    }
}
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let plants = try? JSONDecoder().decode(Plants.self, from: jsonData)

import Foundation

// MARK: - Plants
class Plants: Codable {
    let data: [Datum]?
    let links: PlantsLinks?
    let meta: Meta?
    
    init(data: [Datum]?, links: PlantsLinks?, meta: Meta?) {
        self.data = data
        self.links = links
        self.meta = meta
    }
}

// MARK: - Datum
class Datum: Codable {
    let id: Int?
    let commonName, slug, scientificName: String?
    let year: Int?
    let bibliography, author: String?
    let status: Status?
    let rank: Rank?
    let familyCommonName: FamilyCommonName?
    let genusID: Int?
    let imageURL: String?
    let synonyms: [String]?
    let genus, family: String?
    let links: DatumLinks?
    
    enum CodingKeys: String, CodingKey {
        case id
        case commonName = "common_name"
        case slug
        case scientificName = "scientific_name"
        case year, bibliography, author, status, rank
        case familyCommonName = "family_common_name"
        case genusID = "genus_id"
        case imageURL = "image_url"
        case synonyms, genus, family, links
    }
    
    init(id: Int?, commonName: String?, slug: String?, scientificName: String?, year: Int?, bibliography: String?, author: String?, status: Status?, rank: Rank?, familyCommonName: FamilyCommonName?, genusID: Int?, imageURL: String?, synonyms: [String]?, genus: String?, family: String?, links: DatumLinks?) {
        self.id = id
        self.commonName = commonName
        self.slug = slug
        self.scientificName = scientificName
        self.year = year
        self.bibliography = bibliography
        self.author = author
        self.status = status
        self.rank = rank
        self.familyCommonName = familyCommonName
        self.genusID = genusID
        self.imageURL = imageURL
        self.synonyms = synonyms
        self.genus = genus
        self.family = family
        self.links = links
    }
}

enum FamilyCommonName: String, Codable {
    case asterFamily = "Aster family"
    case null = "null"
    case oliveFamily = "Olive family"
    case roseFamily = "Rose family"
}

// MARK: - DatumLinks
class DatumLinks: Codable {
    let linksSelf, plant, genus: String?
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case plant, genus
    }
    
    init(linksSelf: String?, plant: String?, genus: String?) {
        self.linksSelf = linksSelf
        self.plant = plant
        self.genus = genus
    }
}

enum Rank: String, Codable {
    case species = "species"
}

enum Status: String, Codable {
    case accepted = "accepted"
}

// MARK: - PlantsLinks
class PlantsLinks: Codable {
    let linksSelf, first, next, last: String?
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case first, next, last
    }
    
    init(linksSelf: String?, first: String?, next: String?, last: String?) {
        self.linksSelf = linksSelf
        self.first = first
        self.next = next
        self.last = last
    }
}

// MARK: - Meta
class Meta: Codable {
    let total: Int?
    
    init(total: Int?) {
        self.total = total
    }
}



