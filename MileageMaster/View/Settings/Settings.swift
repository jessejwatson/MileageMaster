//
//  Settings.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        NavigationView
        {
            List
            {
                NavigationLink("General", destination: GeneralSettings())
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    Settings()
}
