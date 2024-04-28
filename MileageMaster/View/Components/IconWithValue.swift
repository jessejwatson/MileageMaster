//
//  IconWithData.swift
//  MileageMaster
//
//  Created by Jesse Watson on 27/04/2024.
//

import SwiftUI

struct IconWithValue: View {
    
    let systemName: String
    let iconColor: Color
    let value: String
    let lineLimit: Int
    
    init(systemName: String, iconColor: Color, value: String) {
        self.systemName = systemName
        self.iconColor = iconColor
        self.value = value
        self.lineLimit = 1
    }
    
    init(systemName: String, iconColor: Color, value: String, lineLimit: Int) {
        self.systemName = systemName
        self.iconColor = iconColor
        self.value = value
        self.lineLimit = lineLimit
    }
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundStyle(iconColor)
                .padding([.leading, .trailing], 4)
                .frame(alignment: .leading)
            Text(value)
                .lineLimit(lineLimit)
                .truncationMode(.tail)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}
