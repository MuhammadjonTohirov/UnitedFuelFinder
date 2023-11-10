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
        NavigationView {
            VStack {
                ForEach(0..<10) {index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.04))
                            .padding()
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("You")
                                    .fontWeight(.medium)
                                Spacer()
                                Button(action: {
                                    
                                }, label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                })
                            }
                            
                            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's")
                                .fontWeight(.light)
                            
                            HStack(spacing: 5) {
                                ForEach(1..<6) {index in
                                    Image(systemName: "star")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(.orange).opacity(0.8)
                                }
                                Spacer()
                                Text("12:30 12/10/2023")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.gray).opacity(0.7)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( Color.gray.opacity(0.5), lineWidth: 0.6))
                        .padding()
                    }
                }
            }
            .navigationTitle("All comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.init(uiColor: .label))
                    })
                }
            })
        .scrollable(showIndicators: false)
        }
    }
}

#Preview {
    NavigationView {
        CommentsView()
    }
}
