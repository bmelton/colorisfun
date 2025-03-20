import SwiftUI

struct PurchaseView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Trial Period Expired")
                .font(.title)
                .padding(.top, 20)
            
            Text("Your 7-day trial of Color is fun has ended. Purchase the full version to continue using all features.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Button(action: {
                StoreManager.shared.purchaseProduct()
            }) {
                Text("Purchase Full Version")
                    .frame(minWidth: 200)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Text("Quit")
                    .frame(minWidth: 200)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .foregroundColor(.primary)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
        }
        .frame(width: 300, height: 300)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PurchaseCompleted"))) { _ in
            isPresented = false
        }
    }
}
