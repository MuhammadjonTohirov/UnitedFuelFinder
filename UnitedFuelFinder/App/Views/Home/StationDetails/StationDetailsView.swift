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
                        .font(.system(size: 13, weight: .semibold))
                    
                    Text("Richard st. New York, 10010")
                        .font(.system(size: 12))
                }
            }
            .padding(.leading)
            
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and")
                .padding(.horizontal)
                .font(.system(size: 12))
            
            [
                row(
                    title: "distance".localize,
                    detail: Text("2.37 ml")
                        .font(.system(size: 12, weight: .medium))
                ),
                
                row(
                    title: "price".localize,
                    detail: Text("$4.43")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.init(uiColor: .systemGreen))
                ),
                
                row(
                    title: "discount".localize,
                    detail: Text("2.0 %")
                        .font(.system(size: 12, weight: .medium))
                )
            ].vstack(spacing: Padding.small)
                .padding(.horizontal, Padding.medium)
        }
        .padding(.top)
    }
    
    private func row(title: String, detail: any View) -> some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 12))
                Spacer()
                AnyView(detail)
            }
            
            Divider()
        }
    }
    private var postFeedbacks: some View {
        VStack(alignment: .leading) {
            Text("post_feedback".localize)
                .padding(.top)
                .padding(.horizontal)
                .font(.system(size: 14, weight: .medium))
            
            YTextView(
                text: $comment,
                placeholder: "write_comment".localize
            )
            .padding(.horizontal, Padding.medium)
            
            starRating
                Divider()
                .padding(.bottom)
        }
    }
    
    private var starRating: some View {
        HStack(spacing: 5) {
            RateView(starsCount: 5, rate: 0)
                .set(onRateChange: { rate in
                    Logging.l(tag: "StationDetails", "Rate \(rate)")
                })
                .frame(width: 100, height: 20)
                .padding(.leading, Padding.small / 2)
            Spacer()
            
            Button(action: {
                
            }, label: {
                Text("Post")
                    .font(.system(size: 13, weight: .semibold))
            })
            .frame(width: 99, height: 40)
            .foregroundStyle(Color.label)
            .background(Color.init(uiColor: .secondarySystemBackground))
            .cornerRadius(6)
        }
        .padding(.horizontal, Padding.medium)
        .padding(.bottom)
    }
    
    private var comments: some View {
        VStack(alignment: .leading) {
            
            Text("latest_comments".localize)
                .fontWeight(.semibold)
                .padding(.leading)
            
            ForEach(0..<3) {index in
                commentItem
            }
            
            SubmitButton {
                
            } label: {
                Text("more_comments".localize)
            }
            .padding(Padding.medium)
        }
    }
    
    private var commentItem: some View {
        VStack(alignment: .leading, spacing: Padding.small) {
            HStack {
                Text("You")
                    .fontWeight(.medium)
                    .font(.system(size: 13, weight: .medium))
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                })
            }
            
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's")
                .fontWeight(.light)
                .font(.system(size: 12))
            
            HStack(spacing: 5) {
                RateView(rate: 2)
                    .frame(width: 80, height: 16)
                Spacer()
                Text("12:30 12/10/2023")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray).opacity(0.7)
            }
        }
        .padding(Padding.small)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.04))
        )
        .frame(maxHeight: 120)
        .padding(.horizontal, Padding.medium)
        .padding(.vertical, Padding.small / 2)
    }
}

#Preview {
    NavigationView {
        StationDetailsView()
    }
}
