//
//  ContentView.swift
//  ARFunnyFace
//
//  Created by Joshua Basche on 9/13/21.
//

import SwiftUI
import RealityKit
import ARKit

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
    
    
    return arView
    
  }
  
  func updateUIView(_ uiView: ARView, context: Context) {
    
    arView.scene.anchors.removeAll()
    
    let arConfiguration = ARFaceTrackingConfiguration()
    
    uiView.session.run(arConfiguration, options: [.resetTracking, .removeExistingAnchors])
    
    switch(propId) {
    
    // Eyes
    case 0:
      let arAnchor = try! Experience.loadEyes()
      uiView.scene.anchors.append(arAnchor)
      break
      
    // Glasses
    case 1:
      let arAnchors = try! Experience.loadGlasses()
      uiView.scene.anchors.append(arAnchors)
      break
      
    // Moustache
    case 2:
      let arAnchors = try! Experience.loadMoustache()
      uiView.scene.anchors.append(arAnchors)
      break
      
    default:
      break
    }
    
  }
  
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
