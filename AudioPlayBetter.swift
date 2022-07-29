import SwiftUI
import AVKit

let sampleURL = "https://filesamples.com/samples/audio/mp3/sample3.mp3"

struct Content2View: View {
    var body: some View {
        VStack(spacing: 0) {
            MyAudioPlayerView(urlStr: sampleURL)
        }
    }
}



class MyPlayer: ObservableObject {
    
    private let player: AVPlayer?

    @Published var timeSecs: Double = 0.0
    @Published var isPlaying: Bool = false
    
    init(mediaURLString: String) {
        if let url = URL(string: mediaURLString) {
            player = AVPlayer(url: url)
        } else {
            player = nil
        }
        guard let p = player else { return }
        p.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), 
            queue: .main) 
        { [weak self] time in 
            self?.timeSecs = time.seconds
        }
    }
    
    func play() { 
        player?.play() 
        isPlaying = true
    }
    func pause() {
        player?.pause()
        isPlaying = false
    }
    var rate: Float {
        get { player?.rate ?? 0.0 }
        set {
            player?.rate = newValue
            isPlaying = newValue > 0
        }
    }
    func jumpTime(seconds: Double) {
        guard let p = player else { return }
        let cmt = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        p.seek(to: p.currentTime() + cmt)
    }
}




struct MyAudioPlayerView: View {
    @StateObject var player: MyPlayer
    init(urlStr: String) {
        self._player = StateObject(wrappedValue: MyPlayer(mediaURLString: urlStr))
    }
    let playIcon: LocalizedStringKey = "\(Image(systemName: "play.fill"))"
    let pauseIcon: LocalizedStringKey = "\(Image(systemName: "pause"))"
    let forwardIcon: LocalizedStringKey = "\(Image(systemName: "goforward.15"))"
    let backIcon: LocalizedStringKey = "\(Image(systemName: "gobackward.15"))"
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Button(backIcon) { player.jumpTime(seconds: -15) }.font(.system(size: 24))
                Button(player.isPlaying ? pauseIcon : playIcon) { 
                    player.isPlaying ? player.pause() : player.play()
                }.font(.system(size: 34)).frame(width: 50)
                Button(forwardIcon) { player.jumpTime(seconds: 15) }.font(.system(size: 24))
            }.foregroundColor(.black).padding(.bottom, 2)
            HStack {
                Text("\(String(format: "%0.0f", player.timeSecs))")
                    .foregroundColor(.black.opacity(0.5))
                    .font(.system(size: 14))
                HStack {}.frame(minWidth: 160)
            }.padding(.bottom, -10).padding(.top, 0)
        }
        .padding(20)
        .background(.linearGradient(Gradient(colors: [.orange, .red]), startPoint: .bottom, endPoint: .top))
        .cornerRadius(20)
    }
}

