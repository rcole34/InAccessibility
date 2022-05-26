//
//  ContentView.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

enum MainAlertItem: String, Identifiable {
    case settings
    case more
    
    var id: String { self.rawValue }
}

struct MainView: View {
    
    @State var showDetailStock: Stock?
    @State private var alertItem: MainAlertItem?
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        NavigationView {
            List {
                favoriteStocksSection
                allStocksSection
            }
            .navigationTitle("Stocks")
            .toolbar(content: {
                toolbarItems
            })
            .sheet(item: $showDetailStock) { stock in
                DetailView(stock: stock)
            }
            .alert(item: $alertItem) { item in
                switch item {
                case .more:
                    return Alert(title: Text("There are no more favorites to show"))
                    
                case .settings:
                    return Alert(title: Text("There are no settings available for this sample app"))
                }
            }
        }
    }
    
    var favoriteStocksSection: some View {
        Section {
            ForEach(Stock.favorites()) { stock in
                StockCell(stock: stock)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showDetailStock = stock
                    }
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint(Text("Show details for \(stock.name)"))
            }
        } header: {
            DynamicHStack {
                Text("Favorite Stocks")
                    .foregroundColor(.secondaryTextA11y)
                
                if !dynamicTypeSize.isAccessibilitySize {
                    Spacer()
                }
                
                Button {
                    alertItem = .more
                } label: {
                    Text("Show more")
                        .frame(minHeight: 44)
                        .accessibilityLabel(Text("Show more favorites"))
                        .accessibilityInputLabels([Text("Show more")])
                }
            }
        } footer: {
            Text("Favorite stocks are updated every 1 minute.")
                .foregroundColor(.secondaryTextA11y)
                .padding(.vertical, dynamicTypeSize.isAccessibilitySize ? 8 : 0)
        }
        
    }
    
    var allStocksSection: some View {
        Section {
            ForEach(Stock.all()) { stock in
                StockCell(stock: stock)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showDetailStock = stock
                    }
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint(Text("Show details for \(stock.name)"))
            }
        } header: {
            Text("All Stocks")
                .foregroundColor(.secondaryTextA11y)
        }
    }
    
    var toolbarItems: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    alertItem = .settings
                } label: {
                    Image(systemName: "gearshape.fill")
                        .accessibilityLabel(Text("Settings"))
                        .frame(minWidth: 44, minHeight: 44, alignment: .leading)
                }
            }
            
        }
    }
}

// very simplified version of a stack that will be horizontal for non-accessibility dynamic type sizes, but adjust to vertical for accessibility sizes.
// would also probably want to take params for stack view alignments/spacings
struct DynamicHStack<Content: View>: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading) {
                    content
                }
            } else {
                HStack {
                    content
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
