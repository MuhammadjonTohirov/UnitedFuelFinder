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
    @State private var showSelectCard: Bool = false
    @State private var selectedCard: DriverCard? = nil
    @State private var cards: [DriverCard] = []
    
    private var downloadURL: URL {
        URL.baseAPI.appendingPath(isCompany ? "Company" : "Driver", "PrintTransactions")
            .queries(
                .init(name: "fromDate", value: date1.toString(format: "ddMMyyyy")),
                .init(name: "toDate", value: date2.toString(format: "ddMMyyyy")),
                .init(name: "cardNumber", value: selectedCard?.id)
            )
    }
    
    @State private var pdfURL: URL?
    @State private var showShareSheet: Bool = false
    
    private var isCompany: Bool {
        UserSettings.shared.userType == .company
    }
    
    @Environment(\.scenePhase)
    private var scenePhase
    
    var body: some View {
        VStack {
            datePicker
                .padding(.top, 0)
                .padding(.horizontal, Padding.default)
            
            cardField
                .set(isVisible: isCompany)
            
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
            .sheet(isPresented: $showShareSheet, content: {
                if let pdfURL = pdfURL {
                    ShareSheet(items: [pdfURL])
                }
            })
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.reloadData()
                }
                
                Task {
                    await loadCards()
                }
            }
        }
        .sheet(isPresented: $showSelectCard, content: {
            SelectCardListView(
                selectedCard: $selectedCard,
                cards: cards
            )
            .dynamicSheet()
            .scrollable()
        })
        .onChange(of: selectedCard, perform: { _ in
            showSelectCard = false
            reloadData()
        })
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
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isLoading = true
                    Network().downloadPDF(
                        url: downloadURL.absoluteString
                    ) { pdfUrl in
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.pdfURL = pdfUrl
                            self.showShareSheet = true
                        }
                    }
                }, label: {
                    Image("icon_pdf_download")
                        .renderingMode(.template)
                        .foregroundStyle(Color.appIcon)
                })
            }
        })
    }
    
    private var cardField: some View {
        HStack {
            Text(selectedCard == nil ? "all".localize : selectedCard?.name ?? "")
                .font(.regular(size: 12))
            Spacer()
            Icon(systemName: "chevron.down")
        }
        .padding(.leading, Padding.medium)
        .padding(.trailing, Padding.small)
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 1)
                .foregroundColor(Color(hex: "#D4D4D4"))
        )
        .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.appBackground))
        .padding(.horizontal, Padding.default)
        .onTapGesture {
            showSelectCard = true
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
                    Icon(systemName: "calendar")
                        .aspectRatio(.fit)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .font(.lato(size: 13))
                .fontWeight(.regular)
                .foregroundColor(Color.init(uiColor: .label))
            })
            .frame(height: 40)
            .padding(.leading, Padding.medium)
            .padding(.trailing, Padding.small)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
                    .foregroundColor(Color(hex: "#D4D4D4"))
            )
            
            Button(action: {
                buttonNumber = 2
                datePresented.toggle()
            }, label: {
                HStack {
                    Text("\(formattedDate(date2))")
                    Spacer()
                    Icon(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
                .font(.lato(size: 13))
                .fontWeight(.regular)
                .foregroundColor(Color.init(uiColor: .label))
            })
            .frame(height: 40)
            .padding(.leading, Padding.medium)
            .padding(.trailing, Padding.small)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
                    .foregroundColor(Color(hex: "#D4D4D4"))
            )
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
    
    private func loadCards() async {
        let _cards = await CompanyService.shared.loadDriverCards()
        
        await MainActor.run {
            self.cards = _cards
        }
    }
    
    private func loadTransactions(from: Date, to: Date) async {
        let _from = from.toString(format: "ddMMyyyy")
        let _to = to.toString(format: "ddMMyyyy")
        
        let _transactions = (await CommonService.shared.fetchTransactions(
            fromDate: _from,
            to: _to,
            card: selectedCard?.id,
            isCompany: isCompany
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
