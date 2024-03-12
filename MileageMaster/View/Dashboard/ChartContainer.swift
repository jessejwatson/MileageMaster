//
//  ChartContainer.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct ChartContainer<Content: View>: View {
    
    let header: String
    let graph: Content
    
    var body: some View {
        VStack
        {
            Text(header)
                .padding()
                .font(.headline)
            graph
        }
        .background(Color.gray.opacity(0.1))
        .frame(width: UIScreen.main.bounds.width - 20)
        .cornerRadius(25)
    }
}

/*
#Preview {
    ChartContainer(graph: LineGraph())
}
*/
