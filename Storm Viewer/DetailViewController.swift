//
//  DetailViewController.swift
//  Storm Viewer
//
//  Created by Jerry Turcios on 12/31/19.
//  Copyright © 2019 Jerry Turcios. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var detailTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = detailTitle
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.hidesBarsOnTap = false
    }
}
