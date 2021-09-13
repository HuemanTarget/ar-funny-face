//
//  ContentView.swift
//  ARFunnyFace
//
//  Created by Joshua Basche on 9/13/21.
//

import SwiftUI
import RealityKit

var arView: ARView!

struct ContentView : View {
  @State var propId: Int = 0
  
  var body: some View {
    
    ZStack(alignment: .bottom) {
      ARViewContainer(propId: $propId).edgesIgnoringSafeArea(.all)
      
      HStack {
        Spacer()
        
        Button(action: {
          self.propId = self.propId <= 0 ? 0 : self.propId - 1
        }) {
          Image("PreviousButton")
            .clipShape(Circle())
        }
        
        Spacer()
        
        Button(action: {
          self.TakeSnapshots()
        }) {
          Image("ShutterButton")
            .clipShape(Circle())
        }
        
        Spacer()
        
        Button(action: {
          self.propId = self.propId >= 2 ? 2 : self.propId + 1
        }) {
          Image("NextButton")
            .clipShape(Circle())
        }
        
        Spacer()
      }
    }
    
    
  }
  
  func TakeSnapshots() {
    arView.snapshot(saveToHDR: false) { (image) in
      let compressedImage = UIImage(
        data: (image?.pngData())!)
      
      UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
    }
  }
}

struct ARViewContainer: UIViewRepresentable {
  @Binding var propId: Int
  
  
  func makeUIView(context: Context) -> ARView {
    
    arView = ARView(frame: .zero)
    
    // Load the "Box" scene from the "Experience" Reality File
    let boxAnchor = try! Experience.loadBox()
    
    // Add the box anchor to the scene
    arView.scene.anchors.append(boxAnchor)
    
    return arView
    
  }
  
  func updateUIView(_ uiView: ARView, context: Context) {}
  
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
