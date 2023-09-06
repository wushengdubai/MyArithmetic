//
//  华为OD.swift
//  Arithmetic
//
//  Created by 张清泉 on 2023/8/12.
//

import Foundation

enum OD {}

extension OD {
    static func longestFoot() {
        while let line = readLine() {
            line.isEmpty
            pow(10, 0)
            line.components(separatedBy: "#")
            print(line)
        }
    }
}

/* od题目 https://blog.csdn.net/2301_76848549/article/details/130829950  */

//var arr: [[String]] = ["2,5,6,7,9,5,7".components(separatedBy: ","),
//                               "1,7,4,3,4".components(separatedBy: ",")]
//var res: [String] = []
//let l = 3
//
//
//while !arr.isEmpty {
//    for (i, c) in arr.enumerated() {
//        if c.count < l {
//            res.append(contentsOf: c)
//            arr[i] = []
//        } else {
//            var c = c
//            for _ in 0..<l {
//                res.append(c.remove(at: 0))
//            }
//            arr[i] = c
//        }
//    }
//    arr = arr.filter({ !$0.isEmpty })
//}
//
//res.map({ String($0) }).joined(separator: ",")

//var words = "hell"
//var index = 0
//let commands = ["FORWARD 2", "REPLACE Ooo"]
//
//for line in commands {
//    let count = words.count
//    let parts = line.split(separator: " ")
//    let command = parts[0]
//    let word = parts[1]
//    
//    if command == "FORWARD" {
//        let step = Int(word) ?? 0
//        index = min(index + step, count-1)
//    } else if command == "BACKWARD" {
//        let step = Int(word) ?? 0
//        index = max(index - step, 0)
//    } else if command == "SEARCH-FORWARD" {
//        if word.isEmpty { continue }
//        for i in index..<(count - word.count) {
//            let start =  words.index(words.startIndex, offsetBy: i)
//            let end = words.index(start, offsetBy: word.count)
//            let subString = words[start...end]
//            if subString  == words {
//                index = i
//                break
//            }
//        }
//        
//    } else if command == "SEARCH-BACKWARD" {
//        if word.isEmpty { continue }
//        if index <= word.count { continue }
//        
//        for i in ((word.count-1)...index).reversed() {
//            let start = words.index(words.startIndex, offsetBy: i - word.count)
//            let end = words.index(words.startIndex, offsetBy: i)
//            let subString = words[start...end]
//            if subString  == words {
//                index = i -  word.count
//                break
//            }
//        }
//        
//    } else if command == "INSERT" {
//        if word.isEmpty { continue }
//        let insertIndex = words.index(words.startIndex, offsetBy: index)
//        words.insert(contentsOf: word, at: insertIndex)
//        index = index + word.count - 1
//        
//    } else if command == "REPLACE" {
//        if word.isEmpty { continue }
//        if index == 0 && word.count >= count {
//            words = String(word)
//        } else if index >= count - 1 {
//            words = "\(words)\(word)"
//        } else {
//            let offset = min(count - index, word.count)
//            let startIndex = words.index(words.startIndex, offsetBy: index)
//            let endIndex = words.index(startIndex, offsetBy: offset)
//            words.replaceSubrange(startIndex...endIndex, with: word)
//            
//            if word.count - 1 > offset {
//                let s = word.index(word.startIndex, offsetBy: offset)
//                let e = word.index(s, offsetBy: word.count - 1 - offset)
//                words = "\(words)\(word[s...e])"
//            }
//        }
//        
//    } else if command == "DELETE" {
//        let step = Int(word) ?? 0
//        let startIndex = words.index(words.startIndex, offsetBy: index)
//        let endIndex = words.index(startIndex, offsetBy: step)
//        words.removeSubrange(startIndex...endIndex)
//    } else {}
//}
