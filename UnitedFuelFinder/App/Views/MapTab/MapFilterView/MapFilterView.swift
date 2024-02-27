//
//  MapFilterView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 10/02/24.
//

import Foundation
import RealmSwift
import SwiftUI

enum SortType: String, Codable {
    case discount
    case price
}

struct FilterPriceRange {
    var from: Float = 10
    var to: Float = 100
}

struct MapFilterInput {
    var sortType: SortType
    var from: Int
    var to: Int
    var radius: Int
    var selectedStations: Set<Int>
    var stateId: String?
    var cityId: Int?
    
    init(
        sortType: SortType,
        from: Int,
        to: Int,
        radius: Int,
        selectedStations: Set<Int>,
        stateId: String? = nil,
        cityId: Int? = nil
    ) {
        self.sortType = sortType
        self.from = from
        self.to = to
        self.radius = radius
        self.selectedStations = selectedStations
        self.stateId = stateId
        self.cityId = cityId
    }
}

struct MapFilterView: View {
    @State var sortType: SortType = .discount
    
    @State private var fromPriceRange: String = "0"
    @State private var toPriceRange: String = "100"
    @State private var radius: String = "4"
    @State private var selectedStations: Set<Int> = []
    
    @State private var showState: Bool = false
    @State private var showCity: Bool = false
    
    @State private var selectedState: DState?
    @State private var selectedCity: DCity?
    
    @ObservedResults(DCustomer.self, configuration: Realm.config) var customers
    
    private var onApply: (MapFilterInput) -> Void
    private var input: MapFilterInput
    @State private var didAppear = false
    
    init(input: MapFilterInput, completion: @escaping (MapFilterInput) -> Void) {
        self.onApply = completion
        self.input = input
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                sortedByRow
                Divider()
                priceRange
                radiusView
                stationsView
                
                addressInfo
                    .padding(.top, Padding.small / 2)
                    .padding(.horizontal, Padding.default)
                    .padding(.bottom, 120)
            }
            .scrollable()
            
            VStack {
                Spacer()
                
                SubmitButton {
                    let result: MapFilterInput = .init(
                        sortType: sortType,
                        from: Int(fromPriceRange) ?? 0,
                        to: Int(toPriceRange) ?? 0,
                        radius: Int(radius) ?? 0,
                        selectedStations: selectedStations,
                        stateId: selectedState?.id,
                        cityId: selectedCity?.id
                    )
                    
                    self.onApply(result)
                } label: {
                    Text("apply".localize.capitalized)
                }
                .padding(.horizontal, Padding.default)
                .padding(.bottom, Padding.default)
            }
        }
        .navigationDestination(isPresented: $showState, destination: {
            SelectStateView(state: $selectedState)
        })
        .navigationDestination(isPresented: $showCity, destination: {
            SelectCityView(city: $selectedCity, stateId: selectedState?.id ?? "")
        })
        .onAppear {
            if didAppear {
                return
            }
            
            didAppear = true
            
            self.fromPriceRange = input.from.asString
            self.toPriceRange = input.to.asString
            self.radius = input.radius.asString
            self.sortType = input.sortType
            self.selectedStations = input.selectedStations
            
            self.selectedState = DState.allStates().first(where: {$0.id == input.stateId})
            if let id = input.stateId {
                self.selectedCity = DCity.allCities(byStateId: id).first(where: {$0.id == input.cityId})
            }
        }
    }
    
    private var sortedByRow: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("sorted.by".localize)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.label)
            
            HStack {
                selectionButton(title: "price".localize, isSelected: sortType == .price)
                    .onTapGesture {
                        sortType = .price
                    }
                
                selectionButton(title: "discount".localize, isSelected: sortType == .discount)
                    .onTapGesture {
                        sortType = .discount
                    }
            }
            
            Text("filter.sort.by.info".localize)//Can be sorted by cheapest price or highest discount
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(Color(uiColor: .secondaryLabel))
        }
        .padding(.horizontal, Padding.default)
    }
    
    private var priceRange: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("price.range".localize)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.label)
            
            HStack {
                YRoundedTextField {
                    YTextField(text: $fromPriceRange, placeholder: "from".localize, onEditingChanged: { _ in
                        let fprice = Int(fromPriceRange) ?? 0
                        let tprice = Int(toPriceRange) ?? 0
                        
                        fromPriceRange = min(fprice, tprice).asString
                    })
                    .set(haveTitle: true)
                    .keyboardType(.numberPad)
                }
                
                YRoundedTextField {
                    YTextField(text: $toPriceRange, placeholder: "to".localize, onEditingChanged: { _ in
                        let fprice = Int(fromPriceRange) ?? 0
                        let tprice = Int(toPriceRange) ?? 0
                        
                        toPriceRange = max(fprice, tprice).asString
                    })
                    .set(haveTitle: true)
                    .keyboardType(.numberPad)
                }
            }
            
            Text("filter.price.range.info".localize)//This range will be applied to discounted price
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(Color(uiColor: .secondaryLabel))
                .padding(.top, -10)

        }
        .padding(.horizontal, Padding.default)
    }
    
    private var radiusView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("radius.mile".localize)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.label)
            
            YRoundedTextField {
                YTextField(text: $radius, placeholder: "radius".localize, onEditingChanged: { _ in
                    if (Int(radius) ?? 0) > UserSettings.shared.maxRadius {
                        radius = UserSettings.shared.maxRadius.asString
                    }
                })
                .keyboardType(.numberPad)
            }
        }
        
        .padding(.horizontal, Padding.default)
    }
    
    private var stationsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("stations".localize)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.label)
            
            HStack {
                ForEach(customers) { cust in
                    selectionButton(
                        title: cust.name,
                        isSelected: selectedStations.contains(cust.id)
                    )
                    .onTapGesture {
                        if self.selectedStations.contains(cust.id) {
                            self.selectedStations.remove(cust.id)
                        } else {
                            self.selectedStations.insert(cust.id)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, Padding.default)

    }
    
    func selectionButton(title: String, isSelected: Bool) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .frame(height: 22)
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            .foregroundStyle(isSelected ? .white : .black)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .frame(height: 32)
                    .foregroundStyle(isSelected ? Color.accent : .clear)
            }
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundStyle(Color.accent)
                    .opacity(isSelected ? 0 : 1)
            }
    }
    
    private var addressInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("region".localize)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.init(.label))
            
            SelectionButton(title: "State", value: selectedState?.name ?? "") {
                showState = true
            }
            
            SelectionButton(title: "City", value: selectedCity?.name ?? "") {
                guard let _ = selectedState?.id else {
                    return
                }
                
                showCity = true
            }
        }
    }
}

#Preview {
    return NavigationStack {
        MapFilterView(input: .init(sortType: .price, from: 0, to: 20, radius: 10, selectedStations: []), completion: { _ in
           
       })
       .onAppear {
           Task {
               let _ = await MainService.shared.getCustomers()
           }
       }
    }
}
