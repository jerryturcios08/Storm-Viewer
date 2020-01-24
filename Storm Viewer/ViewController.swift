//
//  ViewController.swift
//  Storm Viewer
//
//  Created by Jerry Turcios on 12/30/19.
//  Copyright © 2019 Jerry Turcios. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [StormImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareTapped)
        )

        let defaults = UserDefaults.standard

        if let savedData = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                pictures = try jsonDecoder.decode([StormImage].self, from: savedData)
            } catch {
                print("Failed to decode data from JSON")
            }
        } else {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let fm = FileManager.default
                let path = Bundle.main.resourcePath!
                let items = try! fm.contentsOfDirectory(atPath: path)

                for item in items {
                    if item.hasPrefix("nssl") {
                        // This is a picture to load!
                        let image = StormImage(imageName: item)
                        self?.pictures.append(image)
                    }
                }

                self?.pictures.sort()
            }
        }

        tableView.reloadData()
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

        cell.textLabel?.text = pictures[indexPath.row].imageName
        cell.detailTextLabel?.text = "View count: \(pictures[indexPath.row].viewCount)"

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
            vc.selectedImage = pictures[indexPath.row].imageName

            // Updates the view count and reloads the table's data
            pictures[indexPath.row].viewCount += 1
            save()
            tableView.reloadData()

            navigationController?.pushViewController(vc, animated: true)
        }
    }

    /// Shares the application link (?) to others when the user presses the share button
    @objc func shareTapped() {
        let vc = UIActivityViewController(
            activityItems: ["Checkout Storm Viewer on the App Store: link?"],
            applicationActivities: []
        )

        vc.popoverPresentationController?.barButtonItem =
            navigationItem.rightBarButtonItem

        present(vc, animated: true)
    }

    func save() {
        let jsonEncoder = JSONEncoder()

        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to encode data to JSON")
        }
    }
}
