//
//  MapFilterView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 10/02/24.
//

import Foundation
import RealmSwift
import SwiftUI

enum SortType: String, Codable, CaseIterable {
    case distance
    case discount
    case price
    
    var title: String {
        switch self {
        case .distance:
            return "distance".localize
        case .discount:
            return "discounted_price".localize
        case .price:
            return "retail_price".localize
        }
    }
}

struct FilterPriceRange {
    var from: Float = 10
    var to: Float = 100
}

struct MapFilterInput {
    var sortType: SortType
    var from: Float
    var to: Float
    var radius: Int
    var selectedStations: Set<Int>
    var stateId: String?
    var cityId: Int?
    
    init(
        sortType: SortType,
        from: Float,
        to: Float,
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
    @State var sortType: SortType = .distance
    
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
                    .padding(.top, Padding.small)
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
            .scrollBounceBehavior(.basedOnSize)
            
            VStack {
                Spacer()
                
                SubmitButton {
                    onSubmit()
                } label: {
                    Text("apply".localize.capitalized)
                }
                .padding(.horizontal, Padding.default)
                .padding(.bottom, Padding.default)
                .background {
                    Rectangle()
                        .padding(.top, -Padding.small)
                        .foregroundStyle(Color.background)
                        .ignoresSafeArea()
                }
            }
        }
        .keyboardDismissable()
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    resetFilter()
                } label: {
                    Icon(name: "icon_reset_filter")
                        .foregroundStyle(Color.appIcon)
                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("filter".localize)
        .navigationDestination(isPresented: $showState, destination: {
            SelectStateView(state: $selectedState)
        })
        .coverNavigationBar()
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
        .background(.appBackground)
    }
    
    private var sortedByRow: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("sorted.by".localize)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.label)
            
            HStack(spacing: 0) {
                ForEach(SortType.allCases, id: \.rawValue) { _case in
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(Color.accentColor.opacity(
                            self.sortType == _case ? 1 : 0
                        ))
                        .overlay {
                            Text(_case.title)
                                .foregroundStyle(
                                    self.sortType == _case ? .black : Color.label
                                )
                                .font(.system(size: 11.5, weight: .medium))
                        }
                        .frame(height: 40)
                        .onTapGesture {
                            sortType = _case
                        }
                }
            }
            .padding(5)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.appSecondaryBackground)
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
                        
                    })
                    .set(haveTitle: true)
                    .keyboardType(.decimalPad)
                }
                
                YRoundedTextField {
                    YTextField(text: $toPriceRange, placeholder: "to".localize, onEditingChanged: { _ in
                        
                    })
                    .set(haveTitle: true)
                    .keyboardType(.decimalPad)
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
            
            HStack(spacing: 14) {
                ForEach(customers) { cust in
                    selectionButton(
                        title: cust.name,
                        logo: cust.iconUrl ?? "",
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
                .frame(width: 100, height: 126)
                .padding(2)
            }
            .scrollable(axis: .horizontal)
            .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
        }
        .padding(.horizontal, Padding.default)

    }
    
    func selectionButton(title: String, logo: String, isSelected: Bool) -> some View {
        FilteringStationView(logo: logo, title: title, isSelected: isSelected)
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
    
    private func resetFilter() {
        let _stations = DCustomer.all?.compactMap { $0.id } ?? []
        let result: MapFilterInput = .init(
            sortType: .discount,
            from: 0,
            to: 1000,
            radius: UserSettings.shared.maxRadius,
            selectedStations: Set(_stations),
            stateId: nil,
            cityId: nil
        )
        
        self.onApply(result)
    }
    
    private func onSubmit() {
        let result: MapFilterInput = .init(
            sortType: sortType,
            from: Float(fromPriceRange.numberFormatted) ?? 0,
            to: Float(toPriceRange.numberFormatted) ?? 0,
            radius: Int(radius) ?? 0,
            selectedStations: selectedStations,
            stateId: selectedState?.id,
            cityId: selectedCity?.id
        )
        
        self.onApply(result)
    }
}

#Preview {
    return NavigationStack {
        MapFilterView(input: .init(sortType: .price, from: 0, to: 20, radius: 10, selectedStations: []), completion: { _ in
           
       })
    }
    .onAppear {
        Task {
            let _ = await MainService.shared.syncCustomers()
        }
    }
}
