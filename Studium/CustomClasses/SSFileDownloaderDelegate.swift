//
//  SSFileDownloaderProtocol.swift
//  Studium
//
//  Created by Simone Scionti on 27/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

protocol SSFileDownloaderDelegate : AnyObject {
    func updateDownloadProgress(currentProgress: Float,forIndexPath: IndexPath)
    func downloadProgressFinished(withError: Error?, tempUrl : URL?,forIndexPath: IndexPath)
}
