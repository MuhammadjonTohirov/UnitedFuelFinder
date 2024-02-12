//
//  DiscountStationView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 11/02/24.
//

import SwiftUI

struct DiscountStationView: View {
    @State var title: String
    @State var location: String
    @State var price: Float
    @State var discount: Float
    
    var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.white.opacity(0.2), radius: 4, x: 0, y: 2)
                
                VStack(spacing: 35) {
                    HStack(spacing: 10) {
                       Image("image_ta")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 32)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(title)
                            Text(location)
                        }
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "#4B4B4B"))
                        Spacer()
                        
                        let discountedPrice = price - discount
                        
                        Text("$\(String(format: "%g", discountedPrice))")
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Save ")
                            + Text("$\(String(format: "%g", discount)) ").foregroundColor(Color(hex: "#FCB527"))
                            + Text("per gallon")
                            
                            Text("Retail price ")
                            + Text("$\(String(format: "%g", price))").foregroundColor(Color(hex: "#FCB527"))
                        }
                        .font(.system(size: 12))
                        .fontWeight(.regular)
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }, label: {
                            HStack {
                                Image(systemName: "smallcircle.filled.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 12, height: 12)
                                
                                Text("Focus")
                            }
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                        })
                        .foregroundStyle(Color.white)
                        .frame(width: 73, height: 26)
                        .background(Color(hex: "#FCB527"))
                        .cornerRadius(4)
                    }
                    .padding(.horizontal)
                }
                .foregroundColor(.black)
            }
            .frame(width: 325, height: 120)
            .edgesIgnoringSafeArea(.vertical)
    }
}

#Preview {
    DiscountStationView(title: "TA/Petrol", location: "23.37 ml • NEWARK NJ", price: 5.1, discount: 0.68)
}
