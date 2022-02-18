import AVFoundation
import AppKit
import SwiftUI

struct PopupView: View {
  @ObservedObject var statusBar: StatusBarController
  @State(initialValue: 0) var minute
  @State(initialValue: 0) var second
  @State(initialValue: 0) var setSecond
  @State(initialValue: 0) var remainingSecond

  @State(initialValue: nil) var started: Bool?
  @State(initialValue: nil) var timer: Timer?

  @State(initialValue: "2500") var settingTimeString

  private let sound = try! AVAudioPlayer(data: NSDataAsset(name: "chime")!.data)

  var body: some View {
    ZStack {
      TextField(
        "",
        text: Binding(
          get: { settingTimeString },
          set: {
            let str = $0.filter { "0123456789".contains($0) }
            guard str.count <= 4 else { return }
            settingTimeString = $0.filter { "0123456789".contains($0) }
          }
        )
      ).opacity(0)

      VStack {
        if started != nil {
          Text(
            "\(String(format: "%02d", remainingSecond / 60))分\(String(format: "%02d", remainingSecond % 60))秒"
          ).font(.largeTitle)
        } else if started == nil {
          Text(
            "\(String(settingTimeString.leftPadding(toLength: 4, withPad: "0").prefix(2)))分\(String(settingTimeString.leftPadding(toLength: 4, withPad: "0").suffix(2)))秒"
          ).font(.largeTitle)
        }

        HStack {
          if started != true {
            Button(
              action: startTimer
            ) {
              Text("スタート").padding(3)
            }
          } else {
            Button(
              action: stopTimer
            ) {
              Text("ストップ").padding(3)
            }
          }

          Button(
            action: {
              stopTimer()
              sound.stop()  //追加①
              sound.currentTime = 0.0  //追加②
              remainingSecond = 0
              minute = setSecond / 60
              second = setSecond - (minute * 60)
              started = nil
              statusBar.statusItem.button?.title =
                "\(String(format: "%02d",minute))分\(String(format: "%02d",second))秒"
            }) {
              Text("リセット").padding(3)
            }
        }
      }.padding()
    }
  }

  private func startTimer() {
    if started == nil {
      let number = NumberFormatter().number(from: "0" + settingTimeString) as! Int
      minute = number / 100
      second = number - (minute * 100)
      remainingSecond = minute * 60 + second
      setSecond = remainingSecond
    }

    started = true
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      if remainingSecond <= 0 {
        timer?.invalidate()
        sound.stop()
        sound.currentTime = 0.0
        sound.play()
        return
      }
      remainingSecond -= 1
      let minute = remainingSecond / 60
      let second = remainingSecond - (minute * 60)
      statusBar.statusItem.button?.title = "\(minute)分\(second)秒"
    }
  }

  private func stopTimer() {
    timer?.invalidate()
    started = false
    minute = remainingSecond / 60
    second = remainingSecond - (minute * 60)
  }
}

extension String {
  func leftPadding(toLength: Int, withPad character: Character) -> String {
    let stringLength = self.count
    if stringLength < toLength {
      return String(repeatElement(character, count: toLength - stringLength)) + self
    } else {
      return String(self.suffix(toLength))
    }
  }
}
