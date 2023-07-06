//
//  Sequence.swift
//  Algorithm
//
//  Created by 张清泉 on 2020/9/20.
//  Copyright © 2020 张清泉. All rights reserved.
//

import Cocoa

class Sequence: NSObject {
    /**
     1、无重复字符的最长子串（3）
     给定一个字符串，请你找出其中不含有重复字符的 最长子串 的长度。
     输入: "abcabcbb"
     输出: 3
     解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
     */
    func lengthOfLongestSubstring(_ s: String) -> Int {
        if s.isEmpty {return 0}
        var length = 0
        var window: [Character] = []
        for c in s {
            if window.contains(c) {
                let firstIndex = window.firstIndex(of: c)!
                window.removeFirst(firstIndex + 1)
            }
            window.append(c)
            if window.count > length {
                length = window.count
            }
        }
        return length
    }

    let s = "bbabcabc"
    //print(lengthOfLongestSubstring(s))

    /**
    2、最小覆盖子串（76）
    给你一个字符串 S、一个字符串 T 。请你设计一种算法，可以在 O(n) 的时间复杂度内，从字符串 S 里面找出：包含 T 所有字符的最小子串。
    提示：
    如果 S 中不存这样的子串，则返回空字符串 ""。
    如果 S 中存在这样的子串，我们保证它是唯一的答案。

    示例：
    输入：S = "ADOBECODEBANC", T = "ABC"
    输出："BANC"
    */
    func minWindow(_ s: String, _ t: String) -> String {
        let sArr = [Character](s)
        let tArr = [Character](t)
        if sArr.count < tArr.count { return "" }
        
        var needs = [Character: Int]()
        var window = [Character: Int]()
        for c in t {
            needs[c] = needs[c] == nil ? 1 : needs[c]! + 1
        }
        
        var left = 0, right = 0, match = 0
        var start = 0, len = Int.max
        while right < sArr.count {
            let c = sArr[right]
            right += 1
            window[c] = window[c] == nil ? 1 : window[c]! + 1
            if window[c] == needs[c] { match += 1 }
            
            print("window: [\(left), \(right)]")
            // 收缩左侧窗口
            while match == needs.count {
                // 更新最小覆盖子串
                if right - left < len {
                    start = left
                    len = right - left
                }
                // 将要移除的字符
                let d = sArr[left]
                // 左移窗口
                left += 1
                // 如果当前字符是需要比较的字符，更新窗口内数据，移动窗口
                if needs[d] != nil {
                    if window[d] == needs[d] {
                        match -= 1
                    }
                    window[d]! -= 1
                }
            }
        }
        let tmp = String(sArr[start...(start + len - 1)])
        return (len == Int.max) ? "" : tmp
    }
    let s1 = "ADOBECODEBANC"
    let subs1 = "ABC"
    //print(minWindow(s1, subs1))

    /**
     3、滑动窗口最大值 （239）

     给定一个数组 nums，有一个大小为 k 的滑动窗口从数组的最左侧移动到数组的最右侧。你只可以看到在滑动窗口内的 k 个数字。滑动窗口每次只向右移动一位。
     返回滑动窗口中的最大值。

     进阶：
     你能在线性时间复杂度内解决此题吗？
     */
    func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
    //    if nums.count == 0 || k == 0 { return [] }
    //    if nums.count < k || k == 1 { return nums }
    //
    //    var maxWindow: [Int] = [], curWindow: [Int] = []
    //    var maxNum = Int.min
    //    for num in nums {
    //        curWindow.append(num)
    //        if num > maxNum {
    //            maxNum = num
    //        }
    //        if curWindow.count == k {
    //            print("num = \(num), maxNum = \(maxNum), maxWindow = \(maxWindow )")
    //            maxWindow.append(maxNum)
    //            print(curWindow)
    //            // 将要把最大数移除时，需要重新判断最大数
    //            let rv = curWindow.remove(at: 0)
    //            if rv == maxNum {
    //                maxNum = curWindow.max()!
    //            }
    //        }
    //    }
    //    return maxWindow
        
        var queue = [Int]()
        var finalQueue = [Int]()
        var maxCountIndex = 0
        for index in 0..<nums.count {
            Swift.print(nums[index], queue, maxCountIndex, finalQueue)
            // 最大数移除窗口
            if index - k + 1 > maxCountIndex {
                queue.removeFirst()
            }
            // 更新第二大数
            while !queue.isEmpty && nums[queue.last!] < nums[index] {
                Swift.print("queue", queue)
                queue.removeLast()
            }
            queue.append(index)
            maxCountIndex = queue[0]
            if index + 1 >= k {
                finalQueue.append(nums[maxCountIndex])
            }
            
        }
        return finalQueue
    }
    let nums = [1,3,-1,-3,5,3,6,7]
//    print(maxSlidingWindow(nums, 3))

    /**
     1143. 最长公共子序列
     给定两个字符串 text1 和 text2，返回这两个字符串的最长 公共子序列 的长度。如果不存在 公共子序列 ，返回 0。
     一个字符串的 子序列 是指这样一个新的字符串：它是由原字符串在不改变字符的相对顺序的情况下删除某些字符（也可以不删除任何字符）后组成的新字符串。
     例如，"ace" 是 "abcde" 的子序列，但 "aec" 不是 "abcde" 的子序列。

     */
    func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
        let m = text1.count, n = text2.count, t1 = Array(text1), t2 = Array(text2)
        // 构造dp 数组
        var dp = Array(repeating: Array(repeating: 0, count: n+1), count: m+1)
        for i in 1...m {
            for j in 1...n {
                if t1[i-1] == t2[j-1] {
                    // 找到一个公共子串字符
                    dp[i][j] = 1 + dp[i-1][j-1]
                } else {
                    dp[i][j] = max(dp[i-1][j], dp[i][j-1])
                }
            }
        }
        return dp[m][n]
    }
    
    /**
     5. 最长回文子串
     给你一个字符串 s，找到 s 中最长的回文子串。
     如果字符串的反序与原始字符串相同，则该字符串称为回文字符串。
     中心扩散法
     */
    func longestPalindrome(_ s: String) -> String {
        if s.count  < s.count { return s}
        let chars = Array(s)
        var start = 0, end = 0
        
        for i in 0..<s.count {
            let len1 = expandCenter(chars, i, i)
            let len2 = expandCenter(chars, i, i+1)
            let len = max(len1, len2)
            if len > end - start {
                start = i - (len - 1) / 2
                end = i + len / 2
            }
        }
        return String(chars[start...end])
    }
    // 中心扩散计算最长回文串
    func expandCenter(_ chars: [Character], _ left: Int, _ right: Int) -> Int {
        var left = left,right = right
        while left >= 0 && right < chars.count && chars[left] == chars[right] {
            left -= 1
            right += 1
        }
        return right - left - 1
    }
    
    /**
     409. 最长回文串2
     给定一个包含大写字母和小写字母的字符串 s ，返回 通过这些字母构造成的 最长的回文串 。
     在构造过程中，请注意 区分大小写 。比如 "Aa" 不能当做一个回文字符串
     */
    func longestPalindrome2(_ s: String) -> Int {
        if s.count < 2 { return s.count }
        var record = [Character: Int]()
        for c in s {
            record[c, default: 0] += 1
        }
        
        var count = 0, odd = 0
        for item in record.values {
            if item % 2 == 0 {
                count += item
            } else {
                count += item - 1
                odd = 1
            }
        }
        
        return count + odd
    }
    
    /**
     516. 最长回文子序列
     给你一个字符串 s ，找出其中最长的回文子序列，并返回该序列的长度。

     子序列定义为：不改变剩余字符顺序的情况下，删除某些字符或者不删除任何字符形成的一个序列。

     示例 1：
     输入：s = "bbbab"
     输出：4
     解释：一个可能的最长回文子序列为 "bbbb"
     */
    func longestPalindromeSubsequence(_ s: String) -> Int {
        if s.count < 2 { return s.count }
        let n = s.count, arr = Array(s)
        var dp = Array(repeating: Array(repeating: 0, count: n), count: n)
        
        // base case
        for i in 0..<n {
            dp[i][i] = 1
        }
        
        // 反着遍历保证正确的状态转移
        for i in (0..<n-1).reversed() {
            for j in (i + 1)..<n {
                if arr[i] == arr[j] {
                    dp[i][j] = dp[i + 1][j - 1] + 2
                } else {
                    dp[i][j] = max(dp[i + 1][j], dp[i][j - 1])
                }
            }
        }
        // 整个 s 的最长回文子串长度
        return dp[0][n-1]
    }
    
    /**
     72. 最短编辑距离
     给你两个单词 word1 和 word2， 请返回将 word1 转换成 word2 所使用的最少操作数  。

     你可以对一个单词进行如下三种操作：
     插入一个字符
     删除一个字符
     替换一个字符
     */
    func minDistance(_ word1: String, _ word2: String) -> Int {
        let m = word1.count, n = word2.count, t1 = Array(word1), t2 = Array(word2)
        if m * n == 0 { return m+n }
        
        var dp = Array(repeating: Array(repeating: 0, count: n+1), count: m+1)
        // base case
        for i in 1...m {
            dp[i][0] = i
        }
        for j in 1...n {
            dp[0][j] = j
        }
        
        // 自底向上求解
        for i in 1...m {
            for j in 1...n {
                let top = dp[i-1][j] + 1
                let left = dp[i][j-1] + 1
                var left_top = dp[i-1][j-1]
                //! 因为 i 和 j 表示的是字符串长度，所以对应的 字符 位置是 i-1 和 j-1
                if t1[i-1] != t2[j-1] {
                    left_top += 1
                }
                
                dp[i][j] = min(left, top, left_top)
            }
        }
        return dp[m][n]
    }
}
