//
//  SwiftUIView.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 23/06/2024.
//
import Foundation
import Charts
import SwiftUI

struct PageviewChart: View {

    @ObservedObject var model: PageviewsViewModel

    

    var body: some View {
        VStack {
            if self.model.stacked.count == 0 {
                ProgressView()
            } else {
                ScrollView(.horizontal) {
                    Chart {
                        ForEach(self.model.stacked) { item in
                            BarMark(
                                x: .value("Date", item.x),
                                y: .value("Views", item.y), width: 20
                            ).foregroundStyle(by: .value("Sessions", item.z))
                        }
                    }.frame(width: 30 * model.barmarkColumns, height: 300).padding().chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: Int(model.barmarkColumns) / 4)) { value in
                            if let date = value.as(Date.self) {
                                
                                
                                switch model.body.unit {
                                case .hour:
                                    AxisValueLabel {
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "HH:mm"
                                        return Text("\(formatter.string(from: date))")
                                    }
                                case .month:
                                    AxisValueLabel {
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "YY-MM"
                                        return Text("\(formatter.string(from: date))")
                                    }
                                case .year:
                                    AxisValueLabel {
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "YYYY"
                                        return Text("\(formatter.string(from: date))")
                                    }
                                case .day:
                                    
                                    AxisValueLabel {
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "MM-dd"
                                        return Text("\(formatter.string(from: date))")
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        WebsiteDetail(websiteId: "31de6a02-3b36-44c8-9d1c-ddbda7f8ea1e")
    }
}

