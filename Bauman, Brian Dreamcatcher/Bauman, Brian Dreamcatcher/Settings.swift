//
//  Settings.swift
//  Bauman, Brian Dreamcatcher
//
//  Created by Brian Bauman on 3/14/19.
//  Copyright © 2019 Brian Bauman. All rights reserved.
//

import Foundation

var dreams = [ Dream(title: "Armed intruder",
                     category: "nightmare",
                     description: "When I got back home, late at night, a strange man was already inside my apartment. He was standing in my kitchen, staring at me as I walked in. He was carrying a handgun, but wasn't pointing it at me. When I approached him, he began to walk towards me. I reached to grab the gun, and was able to pry it from him. Pointing it at him, I demanded that he leave, but he refused.",
                     tag: "Stress",
                     date: Date()),
               Dream(title: "Lost cat",
                     category: "dream",
                     description: "I brought my cat, Maureen, to a farm far from the city. I had a small room to stay at while I was at the farm, and let my cat roam about the room. She found a hole in the wall and escpaed into the farm. I went looking for her and eventually found her with a local farm dog. They had somehow managed to have a baby together in the few hours that she was missing. The baby had the body of a dog and the head of a cat.",
                     tag: "Adventure",
                     date: Date()),
               Dream(title: "Phone underwater",
                     category: "dream",
                     description: "I was in a raft on a river, alone, when some rough water caused my raft to flip over, sending me into the water. As soon as my body submerged, I rushed to reach for the phone in my pocket and raise it above the water level. I knew it had already been completely submerged, but felt like there was still a chance to save it if I acted quickly. After wading to the shore with the phone held above my head, I confirmed it was still working.",
                     tag: "Phone",
                     date: Date()),
               Dream(title: "Abraham Lincoln's hat",
                     category: "nightmare",
                     description: "An anthropomorphic top hat chased me around Reconstruction Era Washington, D.C., claiming that it was hungry for my head.",
                     tag: "Politics",
                     date: Date()) ]

var filteredDreams: [Dream] = dreams

var tags: [String] = [ "Work", "Friends", "Stress", "Adventure", "Phone", "Politics" ]

class Settings {
    var alarmEnabled = false
    var alarmTime = Date.distantFuture
    var snoozeMinutes = 5
    var dreamEntryMinutes = 1
}
