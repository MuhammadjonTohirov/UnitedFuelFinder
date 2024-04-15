//
//  TransactionView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 11/02/24.
//

import SwiftUI

struct TransactionView: View {
    var item: TransactionItem
    
    private var totalSum: Double {
        item.amount ?? 0
    }
    
    private var totalDiscount: Double {
        item.discAmount ?? 0
    }
    
    private var quantity: Double {
        item.quantity ?? 0
    }
    
    private var pricePerUnit: Double {
        item.discPpu ?? 0
    }
    
    private var date: String {
        Date.from(string: item.transactionDate, format: "yyyy-MM-dd'T'HH:mm:ss")?.toString(format: "dd/MM/yyyy") ?? "-"
    }
    
    private var savedAmount: String {
        "@saved".localize(arguments: String(format: "$%.2f", totalDiscount))
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(item.invoiceNumber ?? "-")
                Spacer()
                HStack(spacing: 2) {
                    Text(String.init(format: "$%.2f", totalSum))
                    
                    if totalDiscount != 0 {
                        Text("(\(savedAmount))")
                            .foregroundStyle(Color.init(uiColor: .systemGreen))
                    }
                }
            }
            .font(.system(size: 12))
            .fontWeight(.bold)
            .padding(.top, Padding.medium)
            
            Line()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(height: 1)
                .foregroundColor(.gray)
            
            HStack {
                Text("location".localize)
                Spacer()
                Text(item.locationName ?? "-")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
            }
            
            Line()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(height: 1)
                .foregroundColor(.gray)
            
            HStack {
                Text("quant.best".localize)
                Spacer()
                Text("\(String(format: "%g", quantity))")
                    .fontWeight(.bold)
                + Text(" ($\(String(format: "%g", pricePerUnit)))")
                    .foregroundColor(.green)
                    .fontWeight(.bold)
            }
            
            Line()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(height: 1)
                .foregroundColor(.gray)
            
            HStack {
                Text("driver".localize)
                Spacer()
                Text(item.driverName ?? "")
            }
            
            Line()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(height: 1)
                .foregroundColor(.gray)
            
            HStack {
                Text("card".localize)
                Spacer()
                Text(item.cardNumber.maskAsMiniCardNumber)
            }
            
            Line()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(height: 1)
                .foregroundColor(.gray)
            
            HStack {
                Spacer()
                Text(self.date)
            }
            .padding(.bottom, Padding.medium)
        }
        .foregroundColor(.label)
        .font(.system(size: 12))
        .fontWeight(.regular)
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.appSecondaryBackground)
        }
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
