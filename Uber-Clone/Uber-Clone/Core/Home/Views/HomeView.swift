//
//  HomeView.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 2/25/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        UberMapViewRepresentable()
            .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
