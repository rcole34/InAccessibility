//
//  DetailView.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

enum AlertItem: String, Identifiable {
    case share
    case favorite
    
    var id: String { self.rawValue }
}
struct DetailView: View {
    
    let stock: Stock
    @State var selectedAlertItem: AlertItem?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.colorSchemeContrast) var colorSchemeContrast
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    companyInfo
                    description
                    buttons
                }
                .padding(.horizontal)
            }
            .navigationTitle(stock.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarItems
            }
        }
        .alert(item: $selectedAlertItem, content: { item in
            if item == .share {
                return Alert(title: Text("Thanks for sharing!"))
            } else {
                return Alert(title: Text("Thanks for favoriting (but not really)!"))
            }
        })
    }
    
    var companyInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Company Name")
                    .font(.subheadline)
                    .accessibilityAddTraits(.isHeader)
                Text(stock.name)
                    .font(.title2)
                    .bold()
                Text(stock.shortName)
                    .font(.caption)
                    .speechSpellsOutCharacters()
                
                if dynamicTypeSize.isAccessibilitySize {
                    StockGraph(stock: stock)
                }
            }
            
            if !dynamicTypeSize.isAccessibilitySize {
                Spacer()
                StockGraph(stock: stock)
            }
        }
    }
    
    var description: some View {
        VStack(alignment: .leading) {
            Text("Company Description")
                .font(.subheadline)
                .accessibilityAddTraits(.isHeader)
            Text("This is a company that was founded at some point in time by some people with some ideas. The company makes products and they do other things as well. Some of these things go well, some don't. The company employs people, somewhere between 10 and 250.000. The exact amount is not currently available.")
                .font(.title2)
        }
    }
    
    var buttons: some View {
        VStack {
            Button {
                selectedAlertItem = .share
            } label: {
                Text("Tap to share")
            }
            .buttonStyle(RoundedButtonStyle(textColor: (colorScheme == .dark && colorSchemeContrast == .increased) ? .black : .white, backgroundColor: .accentColor))
            
            Button {
                selectedAlertItem = .share
            } label: {
                Text("Favorite")
            }
            .buttonStyle(RoundedButtonStyle(textColor: (colorScheme == .light && colorSchemeContrast == .increased) ? .white : .black, backgroundColor: .yellow))
            // 22 point bold white text on system yellow does not meets 3.0 minimum contrast ratio for large text, so we use black text here instead
        }
    }
    
    var toolbarItems: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .accessibilityLabel(Text("Close"))
                        .accessibilityInputLabels([
                            Text("Close"),
                            Text("Dismiss"),
                            Text("X")
                        ])
                        .frame(minWidth: 44, minHeight: 44, alignment: .leading)
                }
            }
            
        }
    }
}

struct RoundedButtonStyle: ButtonStyle {
    var textColor: Color
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2.bold())
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            .background(backgroundColor)
            .cornerRadius(15)
            .foregroundColor(textColor)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(stock: .example())
    }
}
