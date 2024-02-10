//
//  DashboardView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 10/02/24.
//

import SwiftUI

struct DashboardView: View {
    @State var profileImage: String = "station"
    var body: some View {
        VStack {
            CardWidgetView(name: "John Doe", cardNummber: "•••• 8484", balance: 1500)
        }
        .scrollable(showIndicators: false)
        .navigationTitle("Dahsboard")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "bell")
                })
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .cornerRadius(20)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}
