//
//  ContentView.swift
//  StickerDemo
//
//  Created by Saboor on 28/05/2024.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        VStack(spacing:30) {
            Image("yellowFlower")
                .resizable()
                .scaledToFit()
                .frame(width:200)
            Button("Share") {
                shareStickerPack()
            }
            .frame(width:200)
            .tint(.white)
            .padding()
            
            .background {
                Capsule().fill(Color.teal)
            }

        }
        .padding()
    }
    func shareStickerPack() {
           let stickerPackName = "Saboor Sticker Pack"
           let stickerPackPublisher = "Saboor Ahmad"

           guard let image = UIImage(named: "yellowFlower"),
                 let imageData = image.pngData() else {
               print("Image not found or cannot convert to data")
               return
           }

           let fileManager = FileManager.default
           let tempDir = fileManager.temporaryDirectory
           let stickerPackPath = tempDir.appendingPathComponent(stickerPackName)
           
           do {
               try fileManager.createDirectory(at: stickerPackPath, withIntermediateDirectories: true, attributes: nil)
               
               let imagePath = stickerPackPath.appendingPathComponent("yellowFlower.png")
               try imageData.write(to: imagePath)
               
               let metadata = [
                   "identifier": "com.saboorahmad.stickerpack",
                   "name": stickerPackName,
                   "publisher": stickerPackPublisher,
                   "stickers": [
                       [
                           "image_file": "yellowFlower.png",
                           "emojis": ["🌼"]
                       ]
                   ],
                   "ios_app_store_link": "",
                   "android_play_store_link": ""
               ] as [String : Any]
               let metadataPath = stickerPackPath.appendingPathComponent("metadata.json")
               let metadataData = try JSONSerialization.data(withJSONObject: metadata, options: .prettyPrinted)
               try metadataData.write(to: metadataPath)
               

               let url = URL(string: "whatsapp://sticker?app=com.myapp.stickerpack")!
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url)
               } else {
                   print("WhatsApp is not installed or the URL scheme is incorrect")
               }
           } catch {
               print("Failed to create or share sticker pack: \(error)")
           }
       }// : function
}

#Preview {
    ContentView()
}
