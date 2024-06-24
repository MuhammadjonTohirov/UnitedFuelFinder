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
    @State private var date1: Date = Date().firstDayOfMonth
    @State private var date2: Date = Date().lastDayOfMonth
    
    @State private var datePresented: Bool = false
    @State private var buttonNumber = 0
    @State private var isLoading = false
    @State private var invoices: [InvoiceItem] = []
    
    @Environment(\.scenePhase)
    private var scenePhase
    
    var body: some View {
        VStack {
            datePicker
                .padding(.top, 20)
            LazyVStack {
                ForEach(invoices) { invo in
                    InvoiceView(item: invo)
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
                    DatePicker("", selection: buttonNumber == 1 ? $date1 : $date2, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .presentationDetents([.height(400)])
                    
                    Button("Submit") {
                        datePresented.toggle()
                    }
                }
            })
            .onAppear {
                reloadData()
            }
            
            .onChange(of: scenePhase, perform: { newValue in
                if newValue == .active {
                    reloadData()
                }
            })
        }
        .background(.appBackground)
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
            await loadInvoices(from: self.date1, to: self.date2)
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    private func loadInvoices(from: Date, to: Date) async {
        let _from = from.toString(format: "ddMMyyyy")
        let _to = to.toString(format: "ddMMyyyy")
        
        let _invoices = (await CommonService.shared.fetchInvoices(
            fromDate: _from,
            to: _to
        )).compactMap {
            InvoiceItem(from: $0)
        }

        await MainActor.run {
            self.invoices = _invoices
        }
    }
}

#Preview {
    NavigationStack {
        AllInvoicesView()
    }
}

