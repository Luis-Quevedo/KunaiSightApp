import SwiftUI

struct ScanView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.viewfinder")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            Text("Scan your receipt")
                .font(.headline)
            Button("Start Scan") {
                // Launch VisionKit
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#if DEBUG
struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
#endif