//
//  ServicesConstants.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 22/05/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

struct Constants {
    static let MARVEL_MAIN_URL = "https://gateway.marvel.com/v1/public"
    static let MARVEL_KEY = "df8dd556fd0c4c6b35436d25cbab6dc8"
    static let MARVEL_HASH = "efb23e10af0852878a59f75d4ecba00f"
    static let MARVEL_HEROES_URL = "\(MARVEL_MAIN_URL)/characters?apikey=\(MARVEL_KEY)&hash=\(MARVEL_HASH)&ts=1&limit=99"
    static let MARVEL_COMICS_URL = "\(MARVEL_MAIN_URL)/comics?limit=99&apikey=" +
    "\(MARVEL_KEY)&hash=\(MARVEL_HASH)&ts=1"
    
    static func marvelHeroComicsUrl(heroID: Int32) -> String {
        return "\(MARVEL_MAIN_URL)/characters/\(heroID)/comics?apikey=" +
        "\(MARVEL_KEY)&hash=\(MARVEL_HASH)&ts=1"
    }
    
    static func marvelHeroByNameUrl(name: String) -> String {
        return "\(MARVEL_MAIN_URL)/characters?name=\(name.replacingOccurrences(of:" ", with: "%20"))&apikey=" +
        "\(MARVEL_KEY)&hash=\(MARVEL_HASH)&ts=1"
    }
    
    static func marveloHeroByIDUrl(heroID: Int32) -> String {
        return "\(MARVEL_MAIN_URL)/id=\(heroID)&apikey=\(MARVEL_KEY)&hash=\(MARVEL_HASH)&ts=1"
    }
}

struct CompletionAlias{
    typealias HeroesRequestCompletion = ([Hero]?) -> Void
    typealias ComicsRequestCompletion = ([Comic]?) -> Void
    typealias WikiRequestCompletion = (String?) -> Void
    typealias HeroRequestCompletion = (Hero?) -> Void
    typealias EmptyCompletion = () -> Void
}

//TODO Add a way to see messages in the UI
struct Messages{
    static let DECODE_ERROR_MESSAGE = "Decode ERROR"
    static let REQUEST_ERROR_MESSAGE = "Request ERROR"
    static let NAME_NOT_FOUND = "Name not found"
    static let DESCRIPTION_NOT_FOUND = "Description not found"
    static let IMAGE_NOT_FOUND = "Image not found"
    static let NOTIFICATION_REMINDER_TITLE = "Remind!"
    static let NOTIFICATION_REMINDER_SUBTITLE = "You must see this!"
    static let NOTIFICATION_REMINDER_BODY = "You must see the awesome superhero wiki ;)"
    static let NOTIFICATION_ERROR_MESSAGE = "Notification Error"
}


