//
//  CardView.swift
//  UnitedFuelFinder
//
//  Created by Jurayev Nodir on 24/06/24.
//

import UIKit
import SwiftUI

class CardItem:Identifiable{
    var id:Int = 0
    var companyName: String{
        return "Energy trucking"
    }
    var balanceString: String{
        return "$ 3 772.08"
    }
    var cardOwner: String{
        return "Rumi Yallo"
    }
    var maskedNumber: String{
        return "**** 7867"
    }
}
struct CardView: View {
    var cardItem: CardItem
    init(cardItem: CardItem) {
        self.cardItem = cardItem
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Text(cardItem.companyName)
                    .font(.semibold(size: 20))
                Spacer()
            }
            
            HStack(spacing: 6) {
                VStack(alignment: .leading){
                    Text("Balance")
                        .font(.regular(size: 14))
                    Text(cardItem.balanceString)
                        .font(.bold(size: 20))
                }
                Spacer()
                Image("eye_show")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .clipped()
            }
            .background(Color.black)
            
            HStack {
                VStack (alignment: .leading){
                    Text(cardItem.maskedNumber)
                        .font(.regular(size: 16))
                    
                    Text(cardItem.cardOwner)
                        .font(.regular(size: 14))
                        .foregroundColor(Color.appDarkGray)
                    
                }
                Spacer()
                Image("simcard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .clipped()
            }
            .background(Color.black)
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.init(hex: "#EF6630"))
        .cornerRadius(6)
    }
}

struct SmallCardView: View {
    var cardItem: CardItem
    init(cardItem: CardItem) {
        self.cardItem = cardItem
    }
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            
            VStack (alignment: .trailing, spacing: 5){
                Text(cardItem.companyName)
                    .font(.regular(size: 9))
                    .padding(.top, 5)
                    .padding(.trailing, 5)
                    .padding(.leading, 5)
                Image("simcard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .clipped()
                    .padding(.bottom, 5)
                    .padding(.trailing, 5)
            }
            .background(Color.init(hex: "#EF6630"))
            .cornerRadius(8)
            
            // Masked numbers
            VStack (alignment: .leading){
                Text(cardItem.maskedNumber)
                    .font(.regular(size: 16))
                    .foregroundColor(Color.appBlack)
                
                Text(cardItem.cardOwner)
                    .font(.regular(size: 14))
                    .foregroundColor(Color.appBlack)
            }
            //.background(Color.black)
            
            Spacer()
            
            //balance
            VStack(alignment:.trailing, spacing: 6) {
                Text("Balance")
                    .font(.regular(size: 12))
                    .foregroundColor(Color.appBlack)
                
                Text(cardItem.balanceString)
                    .font(.bold(size: 14))
                    .foregroundColor(Color.appBlack)
            }
            .padding(.trailing, 5)
            
            
        }
        .foregroundColor(.white)
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        .background(Color.init(hex: "#F2F1FA"))
        .cornerRadius(6)
        //.frame(height:60)
    }
}

struct CardListView: View {
    var cardList: [CardItem]
    @State var isSmall: Bool = true
    init(list: [CardItem], isSmall:Bool = false) {
        self.cardList = list
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScrollView{
                ForEach(cardList) { item in
                    if isSmall{
                        SmallCardView(cardItem: item)
                            .cornerRadius(8)
                    } else{
                        CardView(cardItem: item)
                            .cornerRadius(20)
                    }
                }
            }
        }
        .padding(.horizontal)
        .font(.semibold(size: 14))
        .frame(maxWidth: .infinity)
        .scrollable(showIndicators: false)
        .onAppear {
            
        }
    }
}




#Preview {
    //    let view = CardView(cardItem: CardItem())
    //        .cornerRadius(13)
    //        .background(Color.green)
    //        .padding()
    
//    let view = SmallCardView(cardItem: CardItem())
//        .cornerRadius(8)
//        .background(Color.gray)
//        .padding()
    
    var list = [CardItem]()
    for i in 1...15{
        list.append(CardItem())
    }
    let view = CardListView(list: list)
        .cornerRadius(8)
        .background(Color.gray)
        .padding()
    return view
}
