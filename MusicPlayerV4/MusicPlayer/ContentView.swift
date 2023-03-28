//  ContentView.swift
//  MusicPlayer

import SwiftUI 
import AVKit
import AVFoundation

let bundleAudio = [
    "Paradise-Island.mp3",
    "Deep-Trailer.mp3",
    "Electronic-Music.mp3",
    "Jazz-Music.mp3",
    "HipHop.mp3",
    "Rock-Music.mp3" 
];

//

func loadBundleAudio(_ fileName:String) -> AVAudioPlayer? {
    let path = Bundle.main.path(forResource: fileName, ofType:nil)!
    let theurl = URL(fileURLWithPath: path)
    do {
        return try AVAudioPlayer(contentsOf: theurl)
    } catch {
        print("loadBundleAudio error", error)
    }
    return nil
}


struct Item : Identifiable {
    var id = UUID()
    var urlStr:String
    var name:String
    var music: String
}

// Array of image url strings
let imageArray = [
    "https://cdn.epidemicsound.com/player/20230221.22-deacc8ab30e1c6ed5ea79ea5566154d9efdb69b6/d70f6dc1c97191b06d091d11f2eb7444-384.jpg",
    "https://cdn.epidemicsound.com/player/20230221.22-deacc8ab30e1c6ed5ea79ea5566154d9efdb69b6/1c22ce280d7299918461d041a454bea6-384.jpg",
    "https://cdn.epidemicsound.com/player/20230221.22-deacc8ab30e1c6ed5ea79ea5566154d9efdb69b6/c4e6162ea5f06778552179b53edb4cca-384.jpg",
    "https://cdn.epidemicsound.com/player/20230221.22-deacc8ab30e1c6ed5ea79ea5566154d9efdb69b6/25f33c6f4a66b3fe05514744af10785e-384.jpg",
    "https://cdn.epidemicsound.com/player/20230221.22-deacc8ab30e1c6ed5ea79ea5566154d9efdb69b6/5e801a7f24fd69dbed80491a6e641696-384.jpeg",
    "https://cdn.epidemicsound.com/player/20230221.22-deacc8ab30e1c6ed5ea79ea5566154d9efdb69b6/bcfe69b24690535b14280dcd0ae26f1d-384.jpg",
]


// Read in an image from the array of url strings
func imageFor( index: Int) -> UIImage {
    let urlStr = imageArray[index % imageArray.count]
    return imageFor(string: urlStr)
}

// Read in an image from a url string
func imageFor(string str: String) -> UIImage {
    let url = URL(string: str)
    let imgData = try? Data(contentsOf: url!)
    let uiImage = UIImage(data:imgData!)
    return uiImage!
}

// Array of image url strings
let imageItems:[Item] = [
    Item(urlStr: imageArray[0], name:"Pop", music:"Paradise-Island.mp3"),
    Item(urlStr: imageArray[1], name:"Film", music:"Deep-Trailer.mp3"),
    Item(urlStr: imageArray[2], name:"Electronic Music", music:"Electronic-Music.mp3"),
    Item(urlStr: imageArray[3], name:"Jazz", music:"Jazz-Music.mp3"),
    Item(urlStr: imageArray[4], name:"Hip Hop", music:"HipHop.mp3"),
    Item(urlStr: imageArray[5], name:"Rock", music:"Rock-Music.mp3"),
]



struct ContentView: View {
    var body: some View {
        TabView {
            
            NavigationView {
                List {
                    ForEach(imageItems) { item in
                        NavigationLink( destination: ItemDetail(item: item)) {
                            ItemRow(item: item)
                        }
                    }
                }
                .navigationTitle("Genres")
            }
            .tabItem {
                Image(systemName: "music.note.house.fill")
                Text("Home")
            }
            
//            Text("Search Screen")
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
//            Text("Profile Screen")
            ProfileScreen()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        //        NavigationView {
        //          List {
        //            ForEach(imageItems) { item in
        //              NavigationLink( destination: ItemDetail(item: item)) {
        //                ItemRow(item: item)
        //              }
        //            }
        //          }
        //          .navigationTitle("Genres")
        //        }
    }
}


struct ItemDetail: View {
    @State var audioPlayer: AVAudioPlayer!
    @State var soundIndex = 0
    @State var soundFile = bundleAudio[0]
    @State var player: AVAudioPlayer? = nil
    @State var sliderValue : Float = 0.0
    
    
    @State var progress: Double = 0
    @State var duration: Double = 0

    @State private var drawingHeight = true
     
        var animation: Animation {
            return .linear(duration: 0.5).repeatForever()
        }
    
// audio slider
//    let audioAsset = AVURLAsset.init(item.music)
//
//    audioAsset.loadValuesAsynchronously(forKeys: ["duration"]) {
//        var error: NSError? = nil
//        let status = audioAsset.statusOfValue(forKey: "duration", error: &error)
//        switch status {
//        case .loaded: // Sucessfully loaded. Continue processing.
//            let duration = audioAsset.duration
//            let durationInSeconds = CMTimeGetSeconds(duration)
//            print(Int(durationInSeconds))
//            break
//        case .failed: break // Handle error
//        case .cancelled: break // Terminate processing
//        default: break // Handle all other cases
//        }
//    }
    
    
    
    var item:Item
    var body: some View {
        
        VStack {
            Image(uiImage: imageFor(string: item.urlStr))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:320, height: 320)
                .cornerRadius(7)
                .padding(.bottom, 100)
            //      Spacer(minLength: 1)
            Text(item.name)
                .font(.title)
                .fontWeight(.semibold)
//                .padding(.bottom, 30)
                .position(x: 200, y: -70)
//            Slider(value: $sliderValue, in: 0...10)
            HStack {
                Text("\(formattedTime(progress))") // display progress as percentage
                Slider(value: $progress, in: 0...duration) // create slider with range from 0 to 1
                    .padding()
                Text("\(formattedTime(duration))") // display progress as percentage
            }
                .padding(.horizontal, 25.0)
                .padding(.bottom, 10)
//
//                .onAppear{
//                    let greatplayer = AVPlayer (player)
//                    duration = greatplayer.currentItem?.duration.seconds ?? 0
//                }
            
            
            
            //play & pause buttons
            HStack {
                Spacer()
                Button(action: {
                    player = loadBundleAudio(item.music)
                    player?.play()
//                    Slider(value: $progress, in: 0...10)
                }) {
                    Image(systemName: "play.circle.fill").resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                }
                
//                VStack{
//                    Text("Length " + String(format: "%.1f", player.duration))
//                    Text("CurrentTime " + String(format: "%.1f", player.currentTime))
//                }
                
                if let player = player {

                    
                    VStack(alignment: .leading) {
                        
                        Text("Length " + String(format: "%.1f", player.duration))
                        Text("CurrentTime " + String(format: "%.1f", player.currentTime))
                            .multilineTextAlignment(.center)
                  
                    
                        HStack {
                            bar(low: 0.4)
                                .animation(animation.speed(1.5), value: drawingHeight)
                            bar(low: 0.3)
                                .animation(animation.speed(1.2), value: drawingHeight)
                            bar(low: 0.5)
                                .animation(animation.speed(1.0), value: drawingHeight)
                            bar(low: 0.3)
                                .animation(animation.speed(1.7), value: drawingHeight)
                            bar(low: 0.5)
                                .animation(animation.speed(1.0), value: drawingHeight)
                            bar(low: 0.4)
                                .animation(animation.speed(1.5), value: drawingHeight)
                            bar(low: 0.3)
                                .animation(animation.speed(1.2), value: drawingHeight)
                            bar(low: 0.5)
                                .animation(animation.speed(1.0), value: drawingHeight)
                            bar(low: 0.3)
                                .animation(animation.speed(1.7), value: drawingHeight)
                            bar(low: 0.5)
                                .animation(animation.speed(1.0), value: drawingHeight)
                        }
                        .frame(width: 150)
                        .onAppear{
                            drawingHeight.toggle()
                        }
                    }
                }
                
                Spacer()
                Button(action: {
                    player = loadBundleAudio(item.music)
                    player?.pause()
                }) {
                    Image(systemName: "pause.circle.fill").resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                }
                Spacer()
            }
            .padding(.bottom, 60.0)
            
        }
        
    }
    
// playback time function
    private func formattedTime(_ time: Double) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
// moving bar animation
    func bar(low: CGFloat = 0.0, high: CGFloat = 1.0) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(.indigo.gradient)
            .frame(height: (drawingHeight ? high : low) * 70)
            .frame(height: -100, alignment: .bottom)
            .position(x: 30, y: -120)
    }
    
}


struct ItemRow: View {
    var item:Item
    var body: some View {
        HStack {
            Image(uiImage: imageFor(string: item.urlStr))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:100, height: 100)
                .cornerRadius(7)
            Text(item.name)
            Spacer()
        }
    }
}

struct AudioPlayerView: View {
    @State var progress: Double = 0
    @State var duration: Double = 0
    
    var body: some View {
        VStack {
            Slider(value: $progress, in: 0...duration)
                .padding()
            HStack {
                Text("\(formattedTime(progress))")
                    .frame(width: 50)
                Spacer()
                Text("\(formattedTime(duration))")
                    .frame(width: 50)
            }
        }
        .onAppear {
            guard let url = Bundle.main.url(forResource: "my-audio-file", withExtension: "mp3") else {
                fatalError("Failed to find audio file")
            }
            let player = AVPlayer(url: url)
            duration = player.currentItem?.duration.seconds ?? 0
        }
    }
    
    private func formattedTime(_ time: Double) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

