import SwiftUI
import AVKit

struct ContentView: View {
    let player: AVPlayer?
    init() {
        if let url = URL(string: "https://filesamples.com/samples/audio/mp3/sample3.mp3") {
            player = AVPlayer(url: url)
        } else {
            player = nil
        }
    }
    var body: some View {
        VStack(spacing: 10) {
            if let p = player {
                VideoPlayer(player: p).frame(width: 0, height: 0)
            }
            Button("start") { player?.play() }
            Button("stop") { player?.pause() }
            Button("half speed") { player?.rate = 0.5 }
        }
    }
}
