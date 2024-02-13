//
//  TransactionView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 11/02/24.
//

import SwiftUI

struct TransactionView: View {
    @State var title: String
    @State var location: String
    @State var gallon: Float
    @State var totalSum: Int
    @State var savedAmount: Float
    @State var price: Float
    @State var driver: String
    @State var cardNumber: String
    @State var date: String
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            VStack(spacing: 10) {
                HStack {
                    Text(title)
                    Spacer()
                    Text("$\(totalSum)")
                    + Text("($\(String(format: "%g", savedAmount)) saved)")
                        .foregroundColor(.green)
                }
                .font(.system(size: 12))
                .fontWeight(.bold)
                
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("Location".localize)
                    Spacer()
                    Text(location)
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                }
                
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("Information")
                    Spacer()
                    Text("\(String(format: "%g", gallon))")
                        .fontWeight(.bold)
                    + Text("($\(String(format: "%g", price)))")
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                }
                
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("Driver")
                    Spacer()
                    Text(cardNumber)
                }
                
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                HStack {
                    Spacer()
                    Text(date)
                }
            }
            .foregroundColor(.black)
            .font(.system(size: 12))
            .fontWeight(.regular)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 184)
    }
}


struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dashLength: CGFloat = 3 // Adjust the dash length as needed
        let gapLength: CGFloat = 3 // Adjust the gap length as needed
        let totalLength = dashLength + gapLength
        
        var currentPosition: CGFloat = 0
        while currentPosition <= rect.width {
            path.move(to: CGPoint(x: currentPosition, y: 0))
            path.addLine(to: CGPoint(x: min(currentPosition + dashLength, rect.width), y: 0))
            currentPosition += totalLength
        }
        return path
    }
}

#Preview {
    TransactionView(title: "TRN12938", location: "PILOT BURBANK 287", gallon: 73.02, totalSum: 300, savedAmount: 34.21, price: 4.11, driver: "Aliev Vali", cardNumber: "•••• 1232", date: "12:00 10.11.2023")
}
