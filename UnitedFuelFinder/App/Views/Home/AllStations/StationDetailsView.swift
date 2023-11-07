//
//  StationDetailsView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 07/11/23.
//

import SwiftUI

struct StationDetailsView: View {
    
    @Environment (\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    @FocusState private var commentFocused: Int?
    @State private var comment: String = ""
    @State private var rating: Int = 0
    @State private var commentsPresented: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                
                headerView
        
                details
                
                postFeedbacks
                
                comments
                
                Text("")
                    .frame(height: 50)
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.backward")
                            .foregroundStyle(Color.init(uiColor: .label))
                            .fontWeight(.bold)
                    })
                }
            })
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $commentsPresented, content: {
            CommentsView()
        })
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: -40) {
            Image("station")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
        }
    }
    
    private var details: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image("image_ta")
                    .resizable()
                    .frame(width: 44, height: 32)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("TA/Petro")
                        .fontWeight(.semibold)
                
                    Text("Richard st. New York, 10010")
                        .font(Font.custom("SF Compact", size: 12))
                }
            }
            .padding(.leading)
            
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and")
                .padding(.horizontal)
            
            HStack {
                Text("Distance")
                Spacer()
                Text("23.37ml")
            }
            .fontWeight(.light)
            .padding(.horizontal)
            Divider()
                .background(Color.black)
                .padding(.horizontal)
            
            HStack {
                Text("Price")
                Spacer()
                Text("$ 4.45")
                    .foregroundStyle(.green)
            }
            .fontWeight(.light)
            .padding(.horizontal)
            Divider()
                .background(Color.black)
                .padding(.horizontal)
            
            HStack {
                Text("Discount")
                Spacer()
                Text("2.0%")
                    .foregroundStyle(.red)
            }
            .fontWeight(.light)
            .padding(.horizontal)
            Divider()
                .background(Color.black)
                .padding(.horizontal)
        }
        .padding(.top)
    }
    
    private var postFeedbacks: some View {
        VStack(alignment: .leading) {
            Text("Post feedbacks")
                .padding(.top)
                .padding(.horizontal)
            
            TextField("", text: $comment, prompt: Text("Write comment"), axis: .vertical)
                .padding()
                .textContentType(.streetAddressLine1)
                .font(Font.custom("SF Compact", size: 13))
                .lineLimit(5, reservesSpace: true)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.black.opacity(0.8) : Color.gray.opacity(0.5), lineWidth: 0.6)
                    )
                .focused($isFocused)
                .padding()
                .padding(.horizontal, 5)
            
            starRating
                Divider()
                .padding(.bottom)
        }
    }
    
    private var starRating: some View {
        HStack(spacing: 5) {
            ForEach(1..<6) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundStyle(.orange).opacity(0.8)
                    .onTapGesture {
                        rating = index
                    }
            }
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                Text("Post")
            })
            .frame(width: 99, height: 40)
            .foregroundStyle(Color.label)
            .background(Color.init(uiColor: .secondarySystemBackground))
            .cornerRadius(6)
        }
        .padding(.horizontal, 25)
        .padding(.bottom)
    }
    
    private var comments: some View {
        VStack(alignment: .leading) {
            
            Text("Latest comments")
                .fontWeight(.semibold)
                .padding(.leading)
            
            ForEach(0..<3) {index in
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
            Button(action: {
                commentsPresented.toggle()
            }, label: {
                Text("More comments")
                    .frame(maxWidth: .infinity)
                    .frame(height: 51)
                    .foregroundStyle(.white)
                    .font(Font.headline)
                    .background(Color.orange).opacity(0.8)
                    .cornerRadius(6)
                    .padding(.horizontal)
            })
        }
    }
}

#Preview {
    NavigationView {
        StationDetailsView()
    }
}
