//
//  RecentView.swift
//  UnitedFuelFinder
//
//  Created by Jurayev Nodir on 28/05/24.
//

import SwiftUI

struct RecentView: View {
    @State var title:String
    @State var btnTitle:String
    
    var body: some View {
        HStack(){
            Text(title)
                .font(.semibold(size: 14))
            Spacer()
            Text(btnTitle)
                .font(.semibold(size: 16))
                .foregroundColor(.white)
                .background(Color.clear)
                .padding(EdgeInsets(top: 9, leading: 15, bottom: 9, trailing: 15))
                .background(Color.black)
                .cornerRadius(15)
                
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        
        
        
    }
}
struct RecentTransactionView: View{
    @State var items:[TransactionItem]
    var body: some View {
        VStack(){
            RecentView(title: "Recent transactions ", btnTitle: "View All")
            ForEach(items) { item in
                TransactionView(item: item)
            }
            
        }
        //.padding()
    }
}
struct RecentInvoicesView: View{
    @State var items:[InvoiceItem]
    var body: some View {
        VStack(){
            RecentView(title: "Recent invoices ", btnTitle: "View All")
            ForEach(items) { item in
                InvoiceView(item: item)
            }
            
        }
        //.padding()
    }
}
#Preview {
    VStack(spacing:20){
        RecentTransactionView(items: TransactionItem.mockItems())
        RecentInvoicesView(items: InvoiceItem.mockItems())
    }
    
}
