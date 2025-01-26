
import SwiftUI
struct LaunchView: View {
    @Binding var isLoading: Bool
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            
            Color(.blue).ignoresSafeArea()  // Фон экрана загрузки
            
            VStack {
                Image("Head")
                Image("T")
                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                Image("BAIKAL")
                Image("food")
                
            }
                .onAppear {
                    // Анимация: вращение бесконечно
                    withAnimation(Animation.linear(duration: 1.95).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }

                    // Переход к основному экрану через 3 секунды
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.95) {
                        withAnimation {
                            isLoading = false
                        }
                    }
                }
        }
    }
}

