//
//  Search.swift
//  Homework
//
//  Created by SangDo on 2020/09/06.
//  Copyright © 2020 SangDo. All rights reserved.
//

import Foundation

struct Search: Codable {
    let meta: ResponseMeta
    let documents: [ResponseData]
    
    struct ResponseMeta: Codable {
        let is_end: Bool
        let pageable_count: Int
        let total_count: Int
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            is_end = (try? values.decode(Bool.self, forKey: .is_end)) ?? false
            pageable_count = (try? values.decode(Int.self, forKey: .pageable_count)) ?? 0
            total_count = (try? values.decode(Int.self, forKey: .total_count)) ?? 0
        }
    }
    
    struct ResponseData: Codable {
        let cafename: String
        let blogname: String
        let contents: String
        let datetime: String
        let thumbnail: String
        let title: String
        let url: String
        
        enum CodingKeys: String, CodingKey {
            case cafename = "cafename"
            case blogname = "blogname"
            case contents = "contents"
            case datetime = "datetime"
            case thumbnail = "thumbnail"
            case title = "title"
            case url = "url"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            cafename = (try? values.decode(String.self, forKey: .cafename)) ?? ""
            blogname = (try? values.decode(String.self, forKey: .blogname)) ?? ""
            contents = (try? values.decode(String.self, forKey: .contents)) ?? ""
            datetime = (try? values.decode(String.self, forKey: .datetime)) ?? ""
            thumbnail = (try? values.decode(String.self, forKey: .thumbnail)) ?? ""
            title = (try? values.decode(String.self, forKey: .title)) ?? ""
            url = (try? values.decode(String.self, forKey: .url)) ?? ""
        }
    }
}
