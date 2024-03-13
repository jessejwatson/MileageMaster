//
//  ChartContainer.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct ChartContainer<Content: View>: View
{
    
    @Environment(\.colorScheme) var colorScheme
    
    let header: String
    var graph: Content
    
    var body: some View {
        VStack
        {
            Text(header)
                .padding()
                .font(.headline)
            graph
        }
        .background(colorScheme == .light ? Color.white : Color.secondary.opacity(0.15))
        .frame(width: UIScreen.main.bounds.width - 30)
        .cornerRadius(25)
    }
}

/*
#Preview {
    ChartContainer(graph: LineGraph())
}
*/
