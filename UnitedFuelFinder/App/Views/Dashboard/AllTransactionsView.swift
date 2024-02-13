//
//  AllTransactionsView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 12/02/24.
//

import SwiftUI

struct AllTransactionsView: View {
    @Environment (\.dismiss) var dismiss
    @State private var date1: Date = Date()
    @State private var date2: Date = Date()
    @State private var datePresented: Bool = false
    @State private var tempDate = Date()
    @State private var buttonNumber = 0
    var body: some View {
        VStack {
            datePicker
                .padding(.top, 20)
            LazyVStack {
                ForEach(0..<6) {index in
                    TransactionView(title: "TRN12938", location: "PILOT BURBANK 287", gallon: 73.02, totalSum: 300, savedAmount: 34.21, price: 4.11, driver: "Aliev Vali", cardNumber: "•••• 1232", date: "12:00 10.11.2023")
                }
                .padding(.horizontal)
            }
            .scrollable()
            .navigationTitle("Transferring transactions")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.init(uiColor: .label))
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(Color.init(uiColor: .label))
                    })
                }
            }
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
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        AllTransactionsView()
    }
}
