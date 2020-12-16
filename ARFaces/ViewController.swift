//
//  ViewController.swift
//  ARFaces
//
//  Created by Artyom Mihailovich on 12/15/20.
//

import UIKit
import RealityKit
import SnapKit
import ARKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet var arView: ARView!
    
    
    //MARK: - View lifw cycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        createArConfiguration()
        addFooterView()
    }
    
    
    //MARK: - AR part
    
    func createArConfiguration() {
        let arConfig = ARFaceTrackingConfiguration()
        arView.scene.anchors.removeAll()
        arView.session.run(arConfig, options: [.resetTracking, .removeExistingAnchors])

            let arAnchor = try! Experience.loadLamp()
            arView.scene.anchors.append(arAnchor)
    }
    
    
    //MARK: - Create Footer view

    var photoButton: UIButton = {
       let photoButton = UIButton()
       photoButton.setImage(UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
       photoButton.setImage(UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular))?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal), for: .highlighted)
       photoButton.layer.cornerRadius = photoButton.frame.width / 2
       photoButton.clipsToBounds = true
       photoButton.addTarget(self, action: #selector(takeSnapshot), for: .touchUpInside)
       return photoButton
    }()
    
    // Add camera snapshot 
    @objc
    func takeSnapshot() {
      arView.snapshot(saveToHDR: false) { (image) in
        let compressedImage = UIImage(data: (image?.pngData())!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        
      }
    }
    
    //TODO: next and back mask buttons

    lazy var mainStackView: UIStackView = {
      let stackView = UIStackView(arrangedSubviews: [photoButton])
       stackView.backgroundColor = .black
       stackView.axis = .horizontal
       stackView.distribution = .fillEqually
       stackView.spacing = 10
       
       return stackView
    }()

     func addFooterView() {
       
        view.addSubview(mainStackView)

       mainStackView.snp.makeConstraints { make in
           make.bottom.left.right.equalToSuperview()
           make.height.equalTo(150)
       }
    }
}
