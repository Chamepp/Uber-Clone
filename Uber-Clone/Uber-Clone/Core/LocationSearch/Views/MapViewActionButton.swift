//
//  MapViewActionButton.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 3/2/23.
//

import SwiftUI

struct MapViewActionButton: View {
    
    @Binding var map_state: MapViewState
    
    var body: some View {
        Button {
            action_for_state(map_state)
        } label: {
            Image(systemName: image_name_for_state(map_state))
                .font(.title)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func action_for_state(_ state: MapViewState) {
        switch state {
        case .noInput:
            print("No Input")
        case .searchingForLocation:
            map_state = .noInput
        case .locationSelected:
            map_state = .noInput
        }
    }
    
    func image_name_for_state(_ state: MapViewState) {
        switch state {
        case .noInput:
            print("No Input")
        case .searchingForLocation:
            map_state = .noInput
        case .locationSelected:
            map_state = .noInput
        }
    }
    
    func image_name_for_state(_ state: MapViewState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation, .locationSelected:
            return "arrow.left"
        }
    }
    
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(map_state: .constant(.noInput))
    }
}
