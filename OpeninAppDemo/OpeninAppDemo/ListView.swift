import SwiftUI

struct ListView: View {
    let links: [LinkData]

    var body: some View {
        List(links) { link in
            VStack(alignment: .leading) {
                Button(action: {
                    // Handle tap action here, for example, open the link
                    if let url = URL(string: link.web_link) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text(link.title)
                        .font(.headline)
                        .foregroundColor(.white) // Set title color to white
                }
                Button(action: {
                    // Handle tap action here, for example, open the link
                    if let url = URL(string: link.web_link) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text(link.web_link)
                        .font(.subheadline)
                        .foregroundColor(.blue) // Set link color to blue
                }
            }
        }
    }
}
