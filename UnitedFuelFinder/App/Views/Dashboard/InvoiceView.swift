//
//  InvoicesView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 11/02/24.
//

import SwiftUI

struct InvoiceView: View {
//    @State var invoice: String = "INV-37869"
//    @State var amount: Float = 500.2
//    @State var secoundAmount: Float = 124
//    @State var companyName: String = "JK CARGO INC"
//    @State var date: String = "12:00 10.11.2023"
    
    var item: InvoiceItem
    init(item:InvoiceItem) {
        self.item = item
    }
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.appSecondaryBackground)
                .cornerRadius(12)
                
            VStack(spacing: 10) {
                HStack {
                    Text(item.invoiceNumber ?? "")
                    Spacer()
                    Text("$\(String(format: "%g", item.totalAmount))/$\(String(format: "%g", item.totalDiscount ?? 0))")
                }
                .fontWeight(.bold)
                
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("Company")
                    Spacer()
                    Text(item.companyAccount?.name ?? "")
                        .fontWeight(.bold)
                }
                
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("Date")
                    Spacer()
                    Text(item.fromToDate)
                }
            }
            .foregroundColor(.label)
            .font(.lato(size: 12))
            .fontWeight(.regular)
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    InvoiceView(invoice: "INV-37869", amount: 500.2, secoundAmount: 124, companyName: "JK CARGO INC", date: "12:00 10.11.2023")
//}
