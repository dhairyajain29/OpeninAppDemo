import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Link.title, ascending: true)],
        animation: .default)
    private var links: FetchedResults<Link>

    @State private var greeting: String = ""
    @State private var chartData: [ChartData] = []
    @State private var topLinks: [LinkData] = []
    @State private var recentLinks: [LinkData] = []

    var body: some View {
        VStack {
            Text(greeting)
                .font(.largeTitle)
                .padding()

            ChartView(data: chartData)
                .padding()

            TabView {
                ListView(links: topLinks)
                    .tabItem {
                        Text("Top Links")
                            .font(.system(size: 16))
                    }
                ListView(links: recentLinks)
                    .tabItem {
                        Text("Recent Links")
                            .font(.system(size: 16))
                    }
            }
        }
        .onAppear(perform: loadData)
    }

    func loadData() {
        getGreeting()
        fetchData()
    }

    func getGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            greeting = "Good Morning"
        case 12..<18:
            greeting = "Good Afternoon"
        case 18..<22:
            greeting = "Good Evening"
        default:
            greeting = "Good Night"
        }
    }

    func fetchData() {
        guard let url = URL(string: "https://api.inopenapp.com/api/v1/dashboardNew") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjU5MjcsImlhdCI6MTY3NDU1MDQ1MH0.dCkW0ox8tbjJA2GgUx2UEwNlbTZ7Rr38PVFJevYcXFI", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                // Print the raw JSON response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }

                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    DispatchQueue.main.async {
                        topLinks = result.data.top_links
                        recentLinks = result.data.recent_links

                        // Convert overall_url_chart dictionary to ChartData array
                        chartData = result.data.overall_url_chart.map { key, value in
                            ChartData(name: key, value: value)
                        }
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
}

struct ChartData: Identifiable, Decodable {
    var id: String { name }
    let name: String
    let value: Int
}

struct LinkData: Identifiable, Decodable {
    var id: Int { url_id }
    let url_id: Int
    let web_link: String
    let smart_link: String
    let title: String
    let total_clicks: Int
    let original_image: String?
    let thumbnail: String?
    let times_ago: String
    let created_at: String
    let domain_id: String
    let url_prefix: String?
    let url_suffix: String
    let app: String
    let is_favourite: Bool
}

struct ApiResponse: Decodable {
    let status: Bool
    let statusCode: Int
    let message: String
    let support_whatsapp_number: String
    let extra_income: Double
    let total_links: Int
    let total_clicks: Int
    let today_clicks: Int
    let top_source: String
    let top_location: String
    let startTime: String
    let links_created_today: Int
    let applied_campaign: Int
    let data: ApiData
}

struct ApiData: Decodable {
    let recent_links: [LinkData]
    let top_links: [LinkData]
    let overall_url_chart: [String: Int]
}

