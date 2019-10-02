//
//  Model.swift
//  Task 5p
//
//  Created by Usha Juttu on 26/5/19.
//  Copyright © 2019 Usha Juttu. All rights reserved.
//

import Foundation

struct ActorsModel:Decodable{
    var actors:[ActorModel]
}

struct ActorModel:Decodable{
    var first:String
    var second:String
    var age:Int
}
