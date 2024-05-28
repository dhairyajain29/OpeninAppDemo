import SwiftUI
import Charts

struct ChartView: View {
    let data: [ChartData]

    var body: some View {
        VStack {
            Text("INTERN TASK - Dhairya Jain")
                .font(.title)
                .padding(.bottom)
            
            Chart(data) { entry in
                BarMark(
                    x: .value("Category", entry.name),
                    y: .value("Value", entry.value)
                )
            }
        }
    }
}
