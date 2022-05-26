//
//  StockGraph.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

struct StockGraph: View {
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.legibilityWeight) var fontLegibilityWeight
    
    let stock: Stock
    
    let points: [Int] = [10, 20, 30, 40, 30, 25, 44]
    
    private var labeledPoints: [(String, Int)] = []
    @State private var selectedLabeledPointIndex: Int = 0
    
    init(stock: Stock) {
        self.stock = stock
        self.labeledPoints = getLabeledPoints()
    }
    // make circles bigger for bold text preference or accessibility dynamic type size
    private var bigCircles: Bool {
        fontLegibilityWeight == .bold || dynamicTypeSize.isAccessibilitySize
    }
    
    @State var showDots = false
    
    var body: some View {
        ZStack {
            Color.black
                .cornerRadius(7)
                .frame(minWidth: 75, idealWidth: 100, maxWidth: 100, minHeight: 50, idealHeight: 50, maxHeight: 75)
            
            HStack(spacing: bigCircles ? 2 : 8) {
                ForEach(points.indices, id: \.self) { index in
                    let point = points[index]
                    Circle()
                        .frame(width: bigCircles ? 10 : 4, height: bigCircles ? 10 : 4)
                        .foregroundColor(stock.goingUp ? .greenA11y : .redA11y)
                        .offset(y: CGFloat(stock.goingUp ? -point : point) * 0.3)
                        .accessibilityIgnoresInvertColors()
                }
            }
            .opacity(showDots ? 1 : 0)
            .offset(y: showDots ? 0 : 12)
            .animation(reduceMotion ? nil : .default, value: showDots)
            .animation(reduceMotion ? nil : .spring(), value: bigCircles)
        }
        .accessibilityElement()
        .accessibilityLabel(Text("Stock graph"))
        .accessibilityValue(Text("\(labeledPoints[selectedLabeledPointIndex].0), \(Double(labeledPoints[selectedLabeledPointIndex].1).getCurrencyText())"))
        .accessibilityAdjustableAction(handleAdjustAction)
        .accessibilityChartDescriptor(self)
        .onAppear {
            showDots = true
        }
    }
    
    // assume each point is one day. numbers won't make sense based on total price, but you get the idea :)
    private func getLabeledPoints() -> [(String, Int)] {
        var labeledPoints: [(String, Int)] = []
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        for (index, point) in points.reversed().enumerated() {
            let day: Date = Calendar.current.date(byAdding: .day, value: -index, to: today) ?? Date(timeInterval: TimeInterval(-index * 60 * 60 * 24), since: today)
            labeledPoints.insert((dateFormatter.string(from: day), point), at: 0)
        }
        
        return labeledPoints
    }
    
    private func handleAdjustAction(direction: AccessibilityAdjustmentDirection) {
        switch direction {
        case .increment:
            if selectedLabeledPointIndex == labeledPoints.endIndex - 1 {
                selectedLabeledPointIndex = labeledPoints.startIndex
            } else {
                selectedLabeledPointIndex += 1
            }
        case .decrement:
            if selectedLabeledPointIndex == labeledPoints.startIndex {
                selectedLabeledPointIndex = labeledPoints.endIndex - 1
            } else {
                selectedLabeledPointIndex -= 1
            }
        @unknown default:
            break
        }
    }
}

extension StockGraph: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let xAxisDescriptor = AXCategoricalDataAxisDescriptor(
            title: "Date",
            categoryOrder: labeledPoints.map(\.0)
        )
        
        let yAxisDescriptor = AXNumericDataAxisDescriptor(
            title: "Price",
            range: Double(labeledPoints.map(\.1).min() ?? 0)...Double(labeledPoints.map(\.1).max() ?? 0),
            gridlinePositions: [],
            valueDescriptionProvider: { $0.getCurrencyText() })
        
        let dataSeries = AXDataSeriesDescriptor(
            name: "Prices",
            isContinuous: false,
            dataPoints: labeledPoints.map { .init(x: $0.0, y: Double($0.1)) }
        )
        return AXChartDescriptor(
            title: "\(stock.name) stock value",
            summary: "\(stock.name) stock values over the past week",
            xAxis: xAxisDescriptor,
            yAxis: yAxisDescriptor,
            additionalAxes: [],
            series: [dataSeries]
        )
    }
}

struct StockGraph_Previews: PreviewProvider {
    static var previews: some View {
        StockGraph(stock: .example())
    }
}
