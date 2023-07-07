//
//  String.swift
//  算法
//
//  Created by 张清泉 on 2022/1/26.
//

import Foundation

extension String {
    func index(_ index: Int) -> Character? {
        if index >= self.count || index < 0 { return nil }
        let i = self.index(self.startIndex, offsetBy: index)
        return self[i]
    }
}

/**
 判断字符串是否是回文串
 */
func isPalindrome(_ s: String) -> Bool {
    var left = 0, right = s.count - 1
    while left < right {
        if s.index(left) == s.index(right) {
            left += 1
            right -= 1
        } else {
            return false
        }
    }
    return true
}

/**
 字符串头部去除空格，单词之间保留一个空格，多余空格全部放在尾部
 */
func normalize(_ a: inout [Character]) -> [Character] {
    var isBegain = true, begain = 0, end = a.count - 1
    // 先排除两端空格
    while begain < end && (a[begain].isWhitespace || a[end].isWhitespace) {
        if a[begain] == Character(" ") {
            a.append(a.remove(at: 0)) // 把前面的空格移到尾部
            end -= 1
        }
        if a[end] == Character(" ")  {
            end -= 1
        }
    }
    
    while begain < end {
        let c = a[begain]
        if c.isLetter { // 是字符
            if isBegain {
                a[begain] = Character(c.uppercased())
                isBegain = false
            } else {
                a[begain] = Character(c.lowercased())
            }
        } else { // 是空格
            if isBegain == false { // 第一次检测到空格，不处理
                isBegain = true
            } else {
                a.append(a.remove(at: begain))
                begain -= 1 // 当删除完空格后，相当于索引自动后移了一位，为了索引的正确，需要前移1
                end -= 1 // 尾部指针也要前移一位
            }
        }
        begain += 1
    }
    return a
}

/**
 8. 字符串转整数
 请你来实现一个 myAtoi(string s) 函数，使其能将字符串转换成一个 32 位有符号整数（类似 C/C++ 中的 atoi 函数）。
 函数 myAtoi(string s) 的算法如下：

 1.读入字符串并丢弃无用的前导空格
 2.检查下一个字符（假设还未到字符末尾）为正还是负号，读取该字符（如果有）。 确定最终结果是负数还是正数。如果两者都不存在，则假定结果为正。
 3.读入下一个字符，直到到达下一个非数字字符或到达输入的结尾。字符串的其余部分将被忽略。
 4.将前面步骤读入的这些数字转换为整数（即，"123" -> 123， "0032" -> 32）。如果没有读入数字，则整数为 0。必要时更改符号（从步骤 2 开始）。
 5.如果整数数超过 32 位有符号整数范围 [−2^31,  2^31 − 1]，需要截断这个整数，使其保持在这个范围内。
 具体来说，小于 −2^31 的整数应该被固定为 −2^31 ，大于 2^31 − 1 的整数应该被固定为 2^31 − 1 。
 6.返回整数作为最终结果。
 
 注意：
 本题中的空白字符只包括空格字符 ' ' 。
 除前导空格或数字后的其余字符串外，请勿忽略 任何其他字符。
 */
func myAtoi(_ s: String) -> Int {
    let a = [Character](s)
    var i = 0, end = 0
    var res = 0
    var sign = 1 // 符号位
    while i < a.count {
        let c = a[i]
        i += 1
        if end == 0 && (c == " " || c == "+") { // 字符串以空格、+ 开头开头
            continue
        }
        if end == 0 && c == "-" { // 字符串以-开头
            sign *= -1
            continue
        }
        if end == 0 && !c.isNumber { // 以非数字开始，直接返回0
            return 0
        }
        if !c.isNumber { // 不是数字了
            break;
        }
        end = 1 // 开始查找数字
        res = res * 10 + Int(String(c))! // 统计结果
        if res * sign >= Int32.max {
            return Int(Int32.max)
        }
        if res * sign <= Int32.min {
            return Int(Int32.min)
        }
    }
    return end == 0 ? 0 : res*sign;
}

/**
 5. 最长回文子串
 */
func longestPalindrome(_ s: String) -> String {
    let sA = Array(s), size = s.count
    var start = 0, end = 0
    for i in 0..<size {
        // 以i为中心的最长回文子串
        let s1 = palindrome(sA, i, i)
        // 以i和i+1为中心的最长回文子串
        let s2 = palindrome(sA, i, i+1)
        // 更新最长回文子串
        let length = max(s1, s2)
        if length > end - start + 1 {
            start = i - (length - 1)/2
            end = i + length/2
        }
    }
    return String(sA[start...end])
}
// 获取回文串的长度
func palindrome(_ s: [Character], _ l: Int, _ r: Int) -> Int {
    var l = l, r = r
    while l >= 0 && r < s.count && s[l] == s[r] {
        // 向两边展开
        l -= 1
        r += 1
    }
    // 返回已s[l]和s[r]为中心的最长回文串
    return r-l-1
}

/**
 1143. 最长公共子序列
 
 给定两个字符串 text1 和 text2，返回这两个字符串的最长 公共子序列 的长度。如果不存在 公共子序列 ，返回 0 。
 一个字符串的 子序列 是指这样一个新的字符串：它是由原字符串在不改变字符的相对顺序的情况下删除某些字符（也可以不删除任何字符）后组成的新字符串。

 例如，"ace" 是 "abcde" 的子序列，但 "aec" 不是 "abcde" 的子序列。
 两个字符串的 公共子序列 是这两个字符串所共同拥有的子序列。
 */
func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
    let m = text1.count, n = text2.count, t1 = Array(text1), t2 = Array(text2)
    // 构建dp table
    var dp = Array(repeating: Array(repeating: 0, count: n+1), count: m+1)
    // 进行状态转移
    for i in 1...m {
        for j in 1...n {
            if t1[i-1] == t2[j-1] {
                // 找到一个lcs中的字符
                dp[i][j] = 1 + dp[i-1][j-1]
            } else {
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])
            }
        }
    }
    return dp[m][n]
}


/**
 43. 字符串相乘
 
 给定两个以字符串形式表示的非负整数 num1 和 num2，返回 num1 和 num2 的乘积，它们的乘积也表示为字符串形式。
 注意：不能使用任何内置的 BigInteger 库或直接将输入转换为整数。

 */
func multiply(_ num1: String, _ num2: String) -> String {
    if num1 == "0" || num2 == "0" { return "0"}
    // 结果最多为m+n位
    var res = Array(repeating: 0, count: num1.count+num2.count)
    // 从个位数开始逐位相乘
    for (i, c1) in num1.enumerated().reversed() {
        for (j, c2) in num2.enumerated().reversed() {
            let mul = Int(String(c1))! * Int(String(c2))!
            // 乘积结果，存储在相应的索引位置上
            let p1 = i + j, p2 = i + j + 1
            // 叠加到 res 上
            let sum = mul + res[p2]
            res[p2] = sum % 10
            res[p1] += sum / 10
        }
    }
    // 前缀结果可能存在0
    var i = 0
    while i < res.count  && res[i] == 0 {
        i += 1
    }
    // 构造结果字符串
    let re = res[i...].map { Character("\($0)") }
    return String(re)
}

/**
 20. 有效的括号
 
 给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串 s ，判断字符串是否有效。
 有效字符串需满足：
 左括号必须用相同类型的右括号闭合。
 左括号必须以正确的顺序闭合。
 */
func isValidBrackets(_ s: String) -> Bool {
    var queue = [Character]()
    for c in Array(s) {
        if c == "(" || c == "[" || c == "{" {
            queue.append(c)
        } else {
            if queue.count > 0 && queue.last! == rightToLeft(c) {
                queue.removeLast()
            } else {
                return false
            }
        }
    }
    return queue.count == 0
}
func rightToLeft(_ c: Character) -> Character {
    switch c {
        case Character(")"):
            return Character("(")
        case Character("]"):
            return Character("[")
        case Character("}"):
            return Character("{")
        default:
            return Character("")
    }
}

/**
 921. 使括号有效的最少添加
 给定一个由 '(' 和 ')' 括号组成的字符串 S，我们需要添加最少的括号（ '(' 或是 ')'，可以在任何位置），以使得到的括号字符串有效。

 从形式上讲，只有满足下面几点之一，括号字符串才是有效的：

 它是一个空字符串，或者
 它可以被写成 AB （A 与 B 连接）, 其中 A 和 B 都是有效字符串，或者
 它可以被写作 (A)，其中 A 是有效字符串。
 给定一个括号字符串，返回为使结果字符串有效而必须添加的最少括号数。

 */
func minAddToMakeValid(_ s: String) -> Int {
    // res 记录插入次数
    var res = 0
    // need 变量记录右括号的需求量
    var need = 0
    
    for c in s {
        if c == "(" {
            // 对右括号的需求 + 1
            need += 1
        } else {
            // 对右括号的需求 - 1
            need -= 1
            if need == -1 {
                need = 0
                // 需插入一个左括号
                res += 1
            }
        }
    }
    return res + need
}

/**
 1541. 平衡括号字符串的最少插入次数
 
 给你一个括号字符串 s ，它只包含字符 '(' 和 ')' 。一个括号字符串被称为平衡的当它满足：
 任何左括号 '(' 必须对应两个连续的右括号 '))' 。
 左括号 '(' 必须在对应的连续两个右括号 '))' 之前。
 比方说 "())"， "())(())))" 和 "(())())))" 都是平衡的， ")()"， "()))" 和 "(()))" 都是不平衡的。
 你可以在任意位置插入字符 '(' 和 ')' 使字符串平衡。
 请你返回让 s 平衡的最少插入次数。
 */
func minInsertions(_ s: String) -> Int {
    // need 记录需右括号的需求量
    var res = 0, need = 0
    for c in s {
        if c == "(" {
            need += 2
            if need % 2 == 1 {
                res += 1
                need -= 1
            }
        } else {
            need -= 1
            if need == -1 {
                res += 1
                need = 1
            }
        }
    }
    return res + need
}

/**
 76. 最小覆盖子串
 给你一个字符串 s 、一个字符串 t 。返回 s 中涵盖 t 所有字符的最小子串。如果 s 中不存在涵盖 t 所有字符的子串，则返回空字符串 "" 。
 
 注意：
 对于 t 中重复字符，我们寻找的子字符串中该字符数量必须不少于 t 中该字符数量。
 如果 s 中存在这样的子串，我们保证它是唯一的答案。
 */
func minWindow(_ s: String, _ t: String) -> String {
    if s.count < t.count { return "" }
    var window = [Character: Int](), need = [Character: Int]()
    for c in t {
        need[c, default: 0] += 1
    }
    var left = 0, right = 0, match = 0
    var start = 0, len = 100000
    while right < s.count {
        let c = s.index(left)!
        // 右移窗口
        right += 1
        // 进行窗口内数据的一系列更新
        if need[c, default: 0] > 0 {
            window[c, default: 0] += 1
            if need[c] == window[c] { match += 1 }
        }
        // 判断左侧窗口是否要收缩
        while match == need.count {
            if right - left < len {
                start = left
                len = right - left
            }
            let d = s.index(left)!
            // 左移窗口
            left += 1
            // 如果当前字符是需要比较的字符，更新窗口内数据，移动窗口
            if need[d, default: 0] > 0 {
                if need[d] == window[d] { match -= 1 }
                window[d]! -= 1
            }
        }
    }
    let sIndex = s.index(s.startIndex, offsetBy: start)
    let eIndex = s.index(sIndex, offsetBy: len)
    return len == 100000 ? "" : String(s[sIndex..<eIndex])
}

/**
 567. 字符串的排列
 
 给你两个字符串 s1 和 s2 ，写一个函数来判断 s2 是否包含 s1 的排列。如果是，返回 true ；否则，返回 false 。
 换句话说，s1 的排列之一是 s2 的 子串 。
 */
func checkInclusion(_ s1: String, _ s2: String) -> Bool {
    if s1.count > s2.count { return false }
    var window = [Character: Int](), need = [Character: Int]()
    for c in s1 { need[c, default: 0] += 1 }
    
    var left = 0, right = 0, match = 0
    while right < s2.count {
        let i = s2.index(s2.startIndex, offsetBy: right)
        let c = s2[i]
        right += 1
        
        if need[c] != nil {
            window[c, default: 0] += 1
            if window[c] == need[c] { match += 1 }
        }
        
        while right - left >= s1.count { // 当窗口大于等于s1的长度，需要缩小窗口
            if match == need.count {
                return true // 找到了包含的自读串
            }
            let d = s2.index(left)!
            left += 1 // 左移窗口
            if need[d] != nil {
                if window[d] == need[d] { match -= 1 }
                window[d, default: 0] -= 1
            }
        }
    }
    
    return false
}

/**
 438. 找到字符串中所有字母异位词
 给定两个字符串 s 和 p，找到 s 中所有 p 的 异位词 的子串，返回这些子串的起始索引。不考虑答案输出的顺序。

 异位词 指由相同字母重排列形成的字符串（包括相同的字符串）。
 */
func findAnagrams(_ s: String, _ p: String) -> [Int] {
    if p.count > s.count { return [] }
    var window = [Character: Int](), need = [Character: Int]()
    for c in p { need[c, default: 0] += 1 }
    
    var left = 0, right = 0, match = 0
    var res = [Int]()
    while right < s.count {
        let c = s.index(right)!
        right += 1
        // 更新窗口
        if need[c] != nil {
            window[c, default: 0] += 1
            if window[c] == need[c] { match += 1 }
        }
        // 判断左侧窗口是否要收缩
        while right - left >= p.count {
            if match == need.count {
                res.append(left)
            }
            let d = s.index(left)!
            left += 1
            if need[d] != nil {
                if window[d] == need[d] { match -= 1 }
                window[d, default: 0] -= 1
            }
        }
    }
    return res
}

/**
 3. 最长无重复子串
 给定一个字符串 s ，请你找出其中不含有重复字符的 最长子串 的长度。
 */
func lengthOfLongestSubstring(_ s: String) -> Int {
    if s.isEmpty {return 0}
    var length = 0
    var window: [Character] = []
    for c in s {
        if window.contains(c) {
            let firstIndex = window.firstIndex(of: c)!
            window.removeFirst(firstIndex + 1) // 删除 0-字符c 元素
        }
        window.append(c)
        if window.count > length {
            length = window.count
        }
    }
    return length
}
