//
//  AllInvoicesView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 20/02/24.
//

import Foundation
import SwiftUI


struct AllInvoicesView: View {
    @Environment (\.dismiss) var dismiss
    @State private var date1: Date = Date().before(monthes: 1)
    @State private var date2: Date = Date()
    @State private var datePresented: Bool = false
    @State private var tempDate = Date()
    @State private var buttonNumber = 0
    @State private var isLoading = false
    @ObservedObject var viewModel = AllTranInvoViewModel()
    
    var body: some View {
        VStack {
            datePicker
                .padding(.top, 20)
            LazyVStack {
                ForEach(viewModel.invoices) { invo in
                    InvoicesView(
                        invoice: invo.invoiceNumber ?? "",
                        amount: Float(invo.totalAmount),
                        secoundAmount: Float(invo.totalDiscount ?? 0),
                        companyName: invo.companyAccount?.organization.name ?? "",
                        date: invo.beatufiedDate
                    )    
                }
                .padding(.horizontal)
            }
            .scrollable()
            .navigationTitle("popul.invoices".localize)
            .navigationBarTitleDisplayMode(.inline)
            
            .onChange(of: date1, perform: { value in
                self.date1 = min(value, date2.before(days: 1))
                self.reloadData()
            })
            .onChange(of: date2, perform: { value in
                self.date2 = max(value, date1)
                self.reloadData()
            })
            .coveredLoading(isLoading: $isLoading)
            .sheet(isPresented: $datePresented, content: {
                VStack {
                    DatePicker("", selection: $tempDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .presentationDetents([.height(400)])
                    
                    Button("Submit") {
                        if buttonNumber == 1 {
                            date1 = tempDate
                        } else {
                            date2 = tempDate
                        }
                        datePresented.toggle()
                    }
                }
            })
            .onAppear {
                reloadData()
            }
        }
    }
    
    private var datePicker: some View {
        HStack {
            Button(action: {
                buttonNumber = 1
                datePresented.toggle()
            }, label: {
                HStack {
                    Text("\(formattedDate(date1))")
                    Spacer()
                    Image(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
                .padding()
                .font(.system(size: 13))
                .fontWeight(.regular)
                .foregroundColor(Color.init(uiColor: .label))
            })
            .frame(width: 163, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
                    .foregroundColor(Color(hex: "#D4D4D4")))
            
            Button(action: {
                buttonNumber = 2
                datePresented.toggle()
            }, label: {
                HStack {
                    Text("\(formattedDate(date2))")
                    Spacer()
                    Image(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
                .padding()
                .font(.system(size: 13))
                .fontWeight(.regular)
                .foregroundColor(Color.init(uiColor: .label))
            })
            .frame(width: 163, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
                    .foregroundColor(Color(hex: "#D4D4D4")))
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func reloadData() {
        isLoading = true
        Task {
            await viewModel.loadInvoices(from: self.date1, to: self.date2)
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        AllInvoicesView()
    }
}

