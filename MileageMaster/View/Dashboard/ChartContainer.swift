//
//  ChartContainer.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct ChartContainer<Content: View>: View
{
        
    let header: String
    var graph: Content
    
    var body: some View {
        VStack {
            Text(header)
                .padding()
                .font(.headline)
            graph
        }
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 0)
        .padding()
    }
}

#Preview {
    ChartContainer(header: "Test" , graph: LineGraph(data: [
        ("Test", 2.0),
        ("Test2", 5.0),
        ("Test3", 4.0)
    ]))
}
