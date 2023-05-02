//
//  MenuRow.swift
//  PlantCare
//
//  Created by Taimoor  on 24/04/2023.
//

import SwiftUI

struct MenuRow: View {
    
    var dish: Dish
    
    var body: some View {
        HStack {
            dish.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(verbatim: dish.name)
            Spacer()
        }
    }
}

struct MenuRow_Previews: PreviewProvider {
    static var previews: some View {
        MenuRow(dish: menuItems[0])
    }
}


