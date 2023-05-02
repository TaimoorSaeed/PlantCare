//
//  NavigationView.swift
//  PlantCare
//
//  Created by Taimoor  on 24/04/2023.
//

import SwiftUI

struct CustomNavigationView: View {
    var body: some View {
        NavigationView {
            HStack {
                Text("Apps")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                    NavigationLink(destination: AddPlantView()) {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                    }
            }
            .padding(.all, 10)
        }
        MenuList()
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationView()
    }
}
