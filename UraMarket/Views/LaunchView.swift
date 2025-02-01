
import SwiftUI
struct LaunchView: View {
    @Binding var isLoading: Bool
    @State private var rotation: Double = 0
    @State private var pieces: [Piece] = []
    @State private var isDispersing = false
    @State private var isShow = false
    @State private var isShowLogo = false
    

    var body: some View {
        ZStack {
            
            Color(.blueCustom).ignoresSafeArea()  // Фон экрана загрузки
            
            VStack {
                
                ZStack{
                    if !isDispersing {
                        Image("Head")
                            .onAppear{
                                generatePieces()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    startDispersing() // Запуск анимации рассеивания
                                    isShowLogo = true
                                }
                                
                            }
                    }else{
                        ZStack {
                            ForEach(pieces) { piece in
                                piece.image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: piece.size, height: piece.size)
                                    .clipped()
                                    .position(piece.position)
                                    .offset(piece.offset)
                                    .opacity(piece.opacity)
                                    .animation(.easeOut(duration: 3), value: piece.offset) // Анимация для каждого фрагмента
                            }
                        }
                    }
                    
                    
                    if isShow {
                        Image("Craft")
                            //.font(.largeTitle)
                            //.foregroundColor(.white)
                            //.opacity(isShow ? 1 : 0) // Анимация появления
                            //.transition(.opacity)
                           //.animation(.easeIn(duration: 3), value: isShow)
                    }
                }
                
                if isShowLogo{
                    Image("Logotip")
                        .offset(y: -70)
                    
                }
            
                Image("skalka")
                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
              
            
                
            }
                .onAppear {
                    // Анимация: вращение бесконечно
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }

                    // Переход к основному экрану через 3 секунды
                    DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                        withAnimation {
                            isLoading = false
                            isShowLogo = true
        
                        }
                    }
                }
            
        }
    }
    
    func generatePieces() {
        pieces.removeAll()
        let gridSize = 50
        let pieceSize = UIScreen.main.bounds.width / CGFloat(gridSize)
        let centerX = UIScreen.main.bounds.width / 2
        let centerY = UIScreen.main.bounds.height / 2

        for x in 0..<gridSize {
            for y in 0..<gridSize {
                let position = CGPoint(
                    x: centerX - (UIScreen.main.bounds.width / 2) + CGFloat(x) * pieceSize + pieceSize / 2,
                    y: centerY - (UIScreen.main.bounds.height / 2) + CGFloat(y) * pieceSize + pieceSize / 2
                )

                let piece = Piece(
                    id: UUID(),
                    position: position,
                    size: pieceSize,
                    offset: CGSize.zero,
                    opacity: 1,
                    image: Image("Head")
                )
                pieces.append(piece)
            }
        }
    }
    
    func startDispersing() {
        isDispersing = true
        for i in pieces.indices {
            withAnimation(.easeOut(duration: 3)) {
                pieces[i].offset = CGSize(
                    width: CGFloat.random(in: -300...300),
                    height: CGFloat.random(in: -300...300)
                )
                pieces[i].opacity = 0
            }
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    withAnimation {
                        isShow = true
                        
                        
                    }
                }
        // Переход на следующий экран после завершения анимации
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            isLoading = false
            isShowLogo = true
        }
    }
    
}
    
    


struct Piece: Identifiable {
    let id: UUID
    var position: CGPoint
    var size: CGFloat
    var offset: CGSize
    var opacity: Double
    var image: Image
}
