//
//  ChartContainer.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct ChartContainer<Content: View>: View {
    
    @Environment(\.colorScheme) var colorScheme
        
    let header: String
    var graph: Content
    
    var body: some View {
        VStack {
            Text(header)
                .padding()
                .font(.headline)
            graph
        }
        .background(Colors.shared.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
        .shadow(color: colorScheme == .light ? .gray.opacity(0.3) : .clear, radius: colorScheme == .light ? 5 : 0, x: 0, y: 0)
    }
}

#Preview {
    ChartContainer(header: "Test" , graph: LineGraph(data: [
        ("Test", 2.0),
        ("Test2", 5.0),
        ("Test3", 4.0)
    ]))
}
