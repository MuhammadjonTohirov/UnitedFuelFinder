//
//  AllTransactionsView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 12/02/24.
//

import SwiftUI

struct AllTransactionsView: View {
    @Environment (\.dismiss) var dismiss
    @State private var date1: Date = Date().firstDayOfMonth
    @State private var date2: Date = Date().lastDayOfMonth
    @State private var datePresented: Bool = false
    @State private var buttonNumber = 0
    @State private var isLoading = false
    @State private var transactions: [TransactionItem] = []
    
    @Environment(\.scenePhase)
    private var scenePhase
    
    var body: some View {
        VStack {
            datePicker
                .padding(.top, 0)
            LazyVStack {
                ForEach(transactions) { item in
                    TransactionView(item: item)
                }
                .padding(.horizontal)
            }
            .scrollable()
            .navigationTitle("transf.transactions".localize)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.reloadData()
                }
            }
        }
        .background(.appBackground)
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.reloadData()
                }
            default:
                break
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
        self.isLoading = true
        Task {
            await loadTransactions(from: self.date1, to: self.date2)
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    private func loadTransactions(from: Date, to: Date) async {
        let _from = from.toString(format: "ddMMyyyy")
        let _to = to.toString(format: "ddMMyyyy")
        
        let _transactions = (await CommonService.shared.fetchTransactions(
            fromDate: _from,
            to: _to
        )).compactMap {
            TransactionItem(from: $0)
        }

        await MainActor.run {
            self.transactions = _transactions
        }
    }
}

#Preview {
    NavigationStack {
        AllTransactionsView()
    }
}
