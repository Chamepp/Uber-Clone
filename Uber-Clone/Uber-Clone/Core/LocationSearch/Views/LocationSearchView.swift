//
//  LocationSearchView.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 3/2/23.
//

import SwiftUI

struct LocationSearchView: View {
    
    @State private var start_location_text = ""
    @Binding var map_state: MapViewState
    @EnvironmentObject var view_model: LocationSearchViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6, height: 6)
                }
                VStack {
                    TextField("Current location", text: $start_location_text)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    
                    TextField("Where to?", text: $view_model.query_fragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
            }
            .padding(.horizontal)
            .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(view_model.results, id: \.self) { result in
                        LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    map_state = .locationSelected
                                    view_model.select_location(result)
                                }
                            }
                    }
                }
            }
        }
        .background(Color.theme.background_color)
        .background(.white)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(map_state: .constant(.searchingForLocation))
    }
}
