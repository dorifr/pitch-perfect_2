//
//  RecordedAudio.swift
//  Pitch Perfect2
//
//  Created by Dori Frost on 3/15/15.
//  Copyright (c) 2015 Dori.Frost. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init!(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}