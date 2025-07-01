import SwiftUI

struct CategorySummaryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category Summary")
                .font(.title2)
            HStack {
                VStack(alignment: .leading) {
                    Text("Groceries")
                    Text("$320")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Utilities")
                    Text("$100")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Entertainment")
                    Text("$75")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
    }
}

#if DEBUG
struct CategorySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySummaryView()
    }
}
#endif