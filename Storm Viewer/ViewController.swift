//
//  ViewController.swift
//  Storm Viewer
//
//  Created by Jerry Turcios on 12/30/19.
//  Copyright © 2019 Jerry Turcios. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true

        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasPrefix("nssl") {
                // This is a picture to load!
                pictures.append(item)
            }
        }

        pictures.sort()
    }

    /// The method calculates the number of rows for the table view using the number of items in the
    /// pictures array.
    override func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        return pictures.count
    }

    /// The method displays data for one cell using the title of a picture as the label.
    override func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Picture", for: indexPath
        )
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }

    /// The method instantiates the detail view controller and displays it with the selected image
    override func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail")
            as? DetailViewController
        {
            vc.detailTitle = "Picture \(indexPath.row + 1) of \(pictures.count)"
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
