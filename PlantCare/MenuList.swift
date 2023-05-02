//
//  MenuList.swift
//  PlantCare
//
//  Created by Taimoor  on 24/04/2023.
//

import SwiftUI

struct MenuList: View {
    var body: some View {
        List(menuItems) { dish in
            MenuRow(dish: dish)
        }
    }
}

struct MenuList_Previews: PreviewProvider {
    static var previews: some View {
        MenuList()
    }
}


extension Dish {
    var image: Image {
        RestaurantImageStore.shared.image(name: imageName)
    }
}
