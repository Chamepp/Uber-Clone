//
//  Color.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 3/12/23.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = color_theme()
}

struct color_theme {
    let background_color = Color("BackgroundColor")
    let secondary_background_color = Color("SecondaryBackgroundColor")
    let primary_text_color = Color("PrimaryTextColor")
}
