//
//  MapViewActionButton.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 3/2/23.
//

import SwiftUI

struct MapViewActionButton: View {
    
    @Binding var show_location_search_view: Bool
    
    var body: some View {
        Button {
            show_location_search_view.toggle()
        } label: {
            Image(systemName: show_location_search_view ? "arrow.left" : "line.3.horizontal")
                .font(.title)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(show_location_search_view: .constant(true))
    }
}
