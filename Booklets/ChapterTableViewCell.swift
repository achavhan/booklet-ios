//
//  ChaptertTableViewCell.swift
//  Booklets
//
//  Created by Steven Enamakel on 09/04/16.
//  Copyright © 2016 Booklets. All rights reserved.
//

import UIKit
import AVFoundation

class ChapterTableViewCell: UITableViewCell, NSURLSessionDownloadDelegate {
	@IBOutlet weak var chapterName: UILabel!
	@IBOutlet weak var listenButton: UIButton!
	@IBOutlet weak var excerpt: UITextView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var maincontainerView: UIView!

	var chapter: Chapter?
	var player: AVPlayer?
	var downloadTask: NSURLSessionDownloadTask!
	var backgroundSession: NSURLSession!

	var isPlaying: Bool = false

	var audioFilename: String?
	var destinationUrl: NSURL?

	func attachChapter(chapter: Chapter) {
		// lets create the document folder url
		let documentsDirectoryURL = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!

		self.chapter = chapter
		chapterName.text = chapter.title as String
		excerpt.text = chapter.summary as! String

		descriptionLabel.text = chapter.summary as? String
//        excerpt.textContainer.maximumNumberOfLines = 3
//        excerpt.delegate = self

		audioFilename = ((chapter.title)! as String) + ".mp3"
		destinationUrl = documentsDirectoryURL.URLByAppendingPathComponent(audioFilename!)

		if NSFileManager().fileExistsAtPath(destinationUrl!.path!) {
			showPlayButton()
		} else {
			showDownloadButton()
		}
//
//		let backgroundSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("backgroundSession")
//		backgroundSession = NSURLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())

		maincontainerView.layer.cornerRadius = 5
	}

	@IBAction func onReadTouch(sender: AnyObject) {
//        self.performSegueWithIdentifier("chapterSegue", sender: nil)
	}

	@IBAction func listenButtonClick(sender: AnyObject) {
		if NSFileManager().fileExistsAtPath(destinationUrl!.path!) {
			if (isPlaying) {
				isPlaying = false
				stopPlaying()
			} else {
				isPlaying = true
				startPlaying()
			}
		} else {
			let url = self.chapter!.audioFile
			downloadAudio(url!)
		}

	}

	func startPlaying() {
		listenButton.setTitle("Stop playing", forState: .Normal)

		if (player == nil) {
			player = AVPlayer(URL: self.destinationUrl!)
		}

		player!.play()
	}

	func stopPlaying() {
		listenButton.setTitle("Continue playing", forState: .Normal)

		player!.pause()
	}

	func showPlayButton() {
		listenButton.setTitle("Play audio", forState: .Normal)
	}

	func showDownloadButton() {
		listenButton.setTitle("Get Audio", forState: .Normal)
	}

	func downloadAudio(audioUrl: NSURL) {
		listenButton.setTitle("Downloading", forState: .Normal)

		// to check if it exists before downloading it
		if NSFileManager().fileExistsAtPath(destinationUrl!.path!) {
			print("The file already exists at path")
			showPlayButton()

			// if the file doesn't exist
		} else {
//			downloadTask = backgroundSession.downloadTaskWithURL(audioUrl)
//			downloadTask.resume()

			// you can use NSURLSession.sharedSession to download the data asynchronously
			NSURLSession.sharedSession().downloadTaskWithURL(audioUrl, completionHandler: { (location, response, error) -> Void in
				guard let location = location where error == nil else { return }

				do {
					// after downloading your file you need to move it to your destination url
					try NSFileManager().moveItemAtURL(location, toURL: self.destinationUrl!)
					print("File moved to documents folder")

					self.showPlayButton()
				} catch let error as NSError {
					print(error.localizedDescription)
				}
			}).resume()
		}
	}

	// 1
	func URLSession(session: NSURLSession,
		downloadTask: NSURLSessionDownloadTask,
		didFinishDownloadingToURL location: NSURL) {
			let fileManager = NSFileManager()

			if fileManager.fileExistsAtPath(destinationUrl!.path!) {
				self.showPlayButton()
			} else {
				do {
					try fileManager.moveItemAtURL(location, toURL: destinationUrl!)

					self.showPlayButton()
				} catch {
					print("An error occurred while moving file to destination url")
				}
			}
	}

	// 2
	func URLSession(session: NSURLSession,
		downloadTask: NSURLSessionDownloadTask,
		didWriteData bytesWritten: Int64,
		totalBytesWritten: Int64,
		totalBytesExpectedToWrite: Int64) {
			let val = round(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite) * 100)
			print("hi \(val)")
			self.listenButton.setTitle("Downloading \(val)%", forState: .Normal)
	}
}