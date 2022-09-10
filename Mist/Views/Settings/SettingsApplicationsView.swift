//
//  SettingsApplicationsView.swift
//  Mist
//
//  Created by Nindi Gill on 15/6/2022.
//

import Combine
import SwiftUI

struct SettingsApplicationsView: View {
    private static let imageNames: [String] = [
        "Application - macOS Ventura",
        "Application - macOS Monterey",
        "Application - macOS Big Sur",
        "Application - macOS Catalina",
        "Application - macOS Mojave",
        "Application - macOS High Sierra"
    ]

    @AppStorage("applicationFilename") private var applicationFilename: String = .applicationFilenameTemplate
    @State private var imageName: String = randomImageName()
    @State private var fade: Bool = false
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    private let duration: CGFloat = 0.5
    private let title: String = "Applications"
    // swiftlint:disable:next line_length
    private let description: String = "macOS Installer Applications are app bundles that can be used to install macOS on [Intel-based Macs](https://support.apple.com/en-us/HT201581), and [Apple Silicon Macs](https://support.apple.com/en-us/HT211814) (macOS Big Sur 11 and newer)."

    var body: some View {
        VStack(alignment: .leading) {
            SettingsHeaderView(imageName: imageName, title: title, description: description, fade: $fade)
            PaddedDivider()
            DynamicTextView(title: "Application filename:", text: $applicationFilename, placeholder: .applicationFilenameTemplate) { text in
                text.stringWithSubstitutions(name: Installer.example.name, version: Installer.example.version, build: Installer.example.build)
            }
            FooterText(Installer.filenameDescription)
            PaddedDivider()
            ResetToDefaultButton {
                reset()
            }
        }
        .padding()
        .onReceive(timer) { _ in
            fade.toggle()

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                withAnimation {
                    imageName = SettingsApplicationsView.randomImageName()
                    fade.toggle()
                }
            }
        }
    }

    private static func randomImageName() -> String {
        imageNames.randomElement() ?? "Application - macOS"
    }

    private func reset() {
        applicationFilename = .applicationFilenameTemplate
    }
}

struct SettingsApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsApplicationsView()
    }
}
