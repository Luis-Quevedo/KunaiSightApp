import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Spending Summary")) {
                    HStack {
                        Text("Groceries")
                        Spacer()
                        Text("$320")
                    }
                    HStack {
                        Text("Transportation")
                        Spacer()
                        Text("$80")
                    }
                }

                Section(header: Text("Projections")) {
                    Text("You're on track to save $1500 this month 🎯")
                        .foregroundColor(.green)
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}

#if DEBUG
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
#endif