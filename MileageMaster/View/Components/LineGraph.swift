//
//  LineGraph.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI
import Charts

struct LineGraph: View {
    
    var data: [(category: String, value: Double)]?
    
    var body: some View {
        Chart {
            ForEach(data!, id: \.category) { datum in
                LineMark(
                    x: .value("Test Num", datum.category),
                    y: .value("Value", datum.value)
                )
            }
            .symbol(
                Circle()
            )
        }
        .frame(height: 200)
        .padding()
    }
}

#Preview {
    
    LineGraph(data: [
        ("Test", 2.0),
        ("Test2", 5.0),
        ("Test3", 4.0)
    ])
    
}
