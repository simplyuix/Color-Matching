import SwiftUI
import UIKit

struct ContentView: View {
    @State var startGame = false
    @State private var targetColor = Color.random()
    
    var body: some View {
        if startGame {
            GameView()
        } else {
            VStack(spacing: 30) {
                Text("Match the colors!")
                    .font(.system(size: 54)).fontWidth(.expanded).bold()
                    .multilineTextAlignment(.center)
                ColorCircle(color: $targetColor, offset: .constant(.zero))
                    .frame(width: 160, height: 160)
                
                HStack(spacing: 20) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.largeTitle)
                    Text("Swipe up / down to change Brightness")
                        .font(.title3.width(.expanded).weight(.medium))
                        .multilineTextAlignment(.leading)
                }
                HStack(spacing: 20) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.largeTitle)
                    Text("Swipe left / right to change Hue")
                        .font(.title3.width(.expanded).weight(.medium))
                        .multilineTextAlignment(.leading)
                }
                Text("You have 3 lives. \nGuess faster to get more points.")
                    .font(.subheadline).fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 300)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    startGame = true
                }) {
                    Text("Start")
                        .font(.title3).bold()
                        .padding(30)
                        .background(Circle().stroke(lineWidth: 5))
                        .foregroundColor(.black)
                        .mask(Circle())
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
