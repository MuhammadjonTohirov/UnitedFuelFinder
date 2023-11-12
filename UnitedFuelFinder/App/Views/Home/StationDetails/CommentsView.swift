//
//  CommentsView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 07/11/23.
//

import SwiftUI

struct CommentsView: View {
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        LazyVStack(spacing: Padding.medium) {
            ForEach(0..<10) {index in
                StationCommentItemView(sender: "Me", comment: "StationCommentItemStationCommentItemStationCommentItemStationCommentItem", rate: 1, dateValue: "12")
                    .padding(.horizontal, Padding.medium)
            }
        }
        .navigationTitle("All comments")
        .navigationBarTitleDisplayMode(.inline)
        .scrollable(showIndicators: false)
    }
}

#Preview {
    NavigationView {
        CommentsView()
    }
}
