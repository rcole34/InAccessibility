//
//  StockCell.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

struct StockCell: View {
    let stock: Stock
    
    @State var showInfo = false
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityInvertColors) var accessibilityInvertColors
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(stock.shortName)
                        .speechSpellsOutCharacters()
                        .bold()
                        .fixedSize()
                    
                    Text(stock.name)
                        .foregroundColor(.secondaryTextA11y)
                        .font(.caption2)
                }
                
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.primary)
                    .frame(minWidth: 44, minHeight: 44, alignment: .center)
                    .accessibilityLabel(Text("More info about \(stock.name)"))
                    .accessibilityAddTraits(.isButton)
                    .accessibilityRemoveTraits(.isImage) // removing image trait prevents VO from reading "i" as inferred image content
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showInfo = true
                    }
                
                if stock.favorite {
                    ZStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        
                        // add black stroke around star for better contrast in light mode
                        if colorScheme != .dark && !accessibilityInvertColors {
                            Image(systemName: "star")
                                .font(.body.weight(.light))
                                .foregroundColor(.black)
                        }
                    }
                    .accessibilityLabel(Text("Favorited stock"))
                    .accessibilityIgnoresInvertColors()
                }
                
                if !dynamicTypeSize.isAccessibilitySize {
                    Spacer()
                        
                    StockGraph(stock: stock)
                    StockPrice(stock: stock)
                        .fixedSize()
                }
            }
            
            if dynamicTypeSize.isAccessibilitySize {
                HStack {
                    StockGraph(stock: stock)
                    StockPrice(stock: stock)
                }
            }
        }
        .font(.body)
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8))
        .alert(isPresented: $showInfo) {
            Alert(
                title: Text(stock.name),
                message: Text("The stock price for \(stock.name) (\(stock.shortName)) is \(stock.stockPrice.getCurrencyText())."),
                dismissButton: .cancel())
        }
        .accessibilityElement()
        .accessibilityLabel(Text("\(stock.name), ") + Text(stock.shortName).speechSpellsOutCharacters() + Text("\(stock.favorite ? ", favorited stock" : "")"))
        .accessibilityValue(Text("\(stock.stockPrice.getCurrencyText()), \(stock.goingUp ? "increased" : "decreased") by \(abs(stock.change).getCurrencyText())"))
        .accessibilityInputLabels([Text(stock.name), Text(stock.shortName)])
        .accessibilityActivationPoint(UnitPoint(x: 0.1, y: 0.5)) // was hitting the info button rather than opening details screen
        .accessibilityAction(named: Text("More info about \(stock.name)")) {
            showInfo = true
        }
    }
}

extension Double {
    func getCurrencyText() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: self as NSNumber) ?? "\(self)"
    }
}

struct StockCell_Previews: PreviewProvider {
    static var previews: some View {
        StockCell(stock: .example())
    }
}
