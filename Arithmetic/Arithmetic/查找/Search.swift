//
//  Search.swift
//  Arithmetic
//
//  Created by qingquan on 2022/12/27.
//

import Foundation

/**
 34. 在排序数组中查找元素的第一个和最后一个位置
 给你一个按照非递减顺序排列的整数数组 nums，和一个目标值 target。请你找出给定目标值在数组中的开始位置和结束位置。
 如果数组中不存在目标值 target，返回 [-1, -1]。
 你必须设计并实现时间复杂度为 O(log n) 的算法解决此问题。
 
 示例 1：
 输入：nums = [5,7,7,8,8,10], target = 8
 输出：[3,4]
 */
func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
    let l = search(nums, target)
    let r = search(nums, target + 1)
    return l == r ? [-1, -1] : [l, r - 1]
}


private func search(_ nums: [Int], _ target: Int) -> Int {
    var left = 0, right = nums.count
    while left < right {
        let mid = (left + right) >> 1
        if nums[mid] >= target {
            right = mid
        } else {
            left = mid + 1
        }
    }
    return left
}

// 二分查找
private func searchLeft(_ nums: [Int], _ target: Int) -> Int {
    var left = 0, right = nums.count - 1
    while left < right {
        let mid = (left + right) / 2
        if nums[mid] == target {
            right = mid
        } else {
            left = mid + 1
        }
    }
    return left
}

private func searchRight(_ nums: [Int], _ target: Int) -> Int {
    var left = 0, right = nums.count - 1
    while left < right {
        let mid = (left + right) / 2
        if nums[mid] == target {
            left = mid
        } else {
            right = mid + 1
        }
    }
    return right
}

/**
 1870. 准时到达的列车最小时速
 
 给你一个浮点数 hour ，表示你到达办公室可用的总通勤时间。要到达办公室，你必须按给定次序乘坐 n 趟列车。另给你一个长度为 n 的整数数组 dist ，其中 dist[i] 表示第 i 趟列车的行驶距离（单位是千米）。
 每趟列车均只能在整点发车，所以你可能需要在两趟列车之间等待一段时间。
 例如，第 1 趟列车需要 1.5 小时，那你必须再等待 0.5 小时，搭乘在第 2 小时发车的第 2 趟列车。
 返回能满足你准时到达办公室所要求全部列车的 最小正整数 时速（单位：千米每小时），如果无法准时到达，则返回 -1 。
 生成的测试用例保证答案不超过 107 ，且 hour 的 小数点后最多存在两位数字 。

 示例 1：
 输入：dist = [1,3,2], hour = 6
 输出：1
 解释：速度为 1 时：
 - 第 1 趟列车运行需要 1/1 = 1 小时。
 - 由于是在整数时间到达，可以立即换乘在第 1 小时发车的列车。第 2 趟列车运行需要 3/1 = 3 小时。
 - 由于是在整数时间到达，可以立即换乘在第 4 小时发车的列车。第 3 趟列车运行需要 2/1 = 2 小时。
 - 你将会恰好在第 6 小时到达。
 
 示例 2：
 输入：dist = [1,3,2], hour = 2.7
 输出：3
 解释：速度为 3 时：
 - 第 1 趟列车运行需要 1/3 = 0.33333 小时。
 - 由于不是在整数时间到达，故需要等待至第 1 小时才能搭乘列车。第 2 趟列车运行需要 3/3 = 1 小时。
 - 由于是在整数时间到达，可以立即换乘在第 2 小时发车的列车。第 3 趟列车运行需要 2/3 = 0.66667 小时。
 - 你将会在第 2.66667 小时到达
 */
func minSpeedOnTime(_ dist: [Int], _ hour: Double) -> Int {
    var left = 1, right = 10000
    while left < right {
        let mid = (left + right) >> 1
        if check(dist, hour, speed: mid) {
            right = mid
        } else {
            left = mid + 1
        }
    }
    return check(dist, hour, speed: left) ? left : -1
}

private func check(_ dist: [Int], _ hour: Double, speed: Int) -> Bool {
    var res: Double = 0, i = 0
    for d in dist {
        let cos = Double(d) / Double(speed)
        res +=  (i == dist.count - 1 ? cos : ceil(cos))
        i += 1
    }
    return res <= hour
}

/**
 1894. 找到需要补充粉笔的学生编号
 一个班级里有 n 个学生，编号为 0 到 n - 1 。每个学生会依次回答问题，编号为 0 的学生先回答，然后是编号为 1 的学生，以此类推，直到编号为 n - 1 的学生，然后老师会重复这个过程，重新从编号为 0 的学生开始回答问题。
 给你一个长度为 n 且下标从 0 开始的整数数组 chalk 和一个整数 k 。一开始粉笔盒里总共有 k 支粉笔。当编号为 i 的学生回答问题时，他会消耗 chalk[i] 支粉笔。如果剩余粉笔数量 严格小于 chalk[i] ，那么学生 i 需要 补充 粉笔。
 
 请你返回需要 补充 粉笔的学生 编号 。
 
 示例 1：
 输入：chalk = [5,1,5], k = 22
 输出：0
 解释：学生消耗粉笔情况如下：
 - 编号为 0 的学生使用 5 支粉笔，然后 k = 17 。
 - 编号为 1 的学生使用 1 支粉笔，然后 k = 16 。
 - 编号为 2 的学生使用 5 支粉笔，然后 k = 11 。
 - 编号为 0 的学生使用 5 支粉笔，然后 k = 6 。
 - 编号为 1 的学生使用 1 支粉笔，然后 k = 5 。
 - 编号为 2 的学生使用 5 支粉笔，然后 k = 0 。
 编号为 0 的学生没有足够的粉笔，所以他需要补充粉笔。
 */

// 前缀和+二分法
func chalkReplacer(_ chalk: [Int], _ k: Int) -> Int {
    // 前缀和
    var preSum = Array(repeating: 0, count: chalk.count + 1)
    for (i, c) in chalk.enumerated() {
        preSum[i + 1] = preSum[i] + c
    }
    let k = k%preSum[chalk.count]
    var left = 0, right = chalk.count
    while left < right {
        let mid = (left + right) >> 1
        if preSum[mid + 1] > k {
            right =  mid
        } else {
            left = mid + 1
        }
    }
    return left
}

/**
 1898. 可移除字符的最大数目
 
 给你两个字符串 s 和 p ，其中 p 是 s 的一个 子序列 。同时，给你一个元素 互不相同 且下标 从 0 开始 计数的整数数组 removable ，该数组是
 s 中下标的一个子集（s 的下标也 从 0 开始 计数）。
 请你找出一个整数 k（0 <= k <= removable.length），选出 removable 中的 前 k 个下标，然后从 s 中移除这些下标对应的 k 个字符。整数 k 需满足：在执行完上述步骤后， p 仍然是 s 的一个 子序列 。更正式的解释是，对于每个 0 <= i < k ，先标记出位于 s[removable[i]] 的字符，接着移除所有标记过的字符，然后检查 p 是否仍然是 s 的一个子序列。
 返回你可以找出的 最大 k ，满足在移除字符后 p 仍然是 s 的一个子序列。
 字符串的一个 子序列 是一个由原字符串生成的新字符串，生成过程中可能会移除原字符串中的一些字符（也可能不移除）但不改变剩余字符之间的相对顺序。

 示例 1：

 输入：s = "abcacb", p = "ab", removable = [3,1,0]
 输出：2
 解释：在移除下标 3 和 1 对应的字符后，"abcacb" 变成 "accb" 。
 "ab" 是 "accb" 的一个子序列。
 如果移除下标 3、1 和 0 对应的字符后，"abcacb" 变成 "ccb" ，那么 "ab" 就不再是 s 的一个子序列。
 因此，最大的 k 是 2 。
 */

func maximumRemovals(_ s: String, _ p: String, _ removable: [Int]) -> Int {
    var left = 0, right = removable.count
    while left < right {
        let mid = (left + right) >> 1
        if checkEnable(s, p, removable, mid) {
            left = mid
        } else {
            right = mid - 1
        }
    }
    return left
}

/// 检查当前位置移除完字符串后，是否符合要求
func checkEnable(_ s: String, _ p: String, _ removable: [Int], _ mid: Int) -> Bool {
    var filterStr = [Character: Int]()
    for (i, c) in s.enumerated() {
        if !removable.contains(where: { $0 == i })  && p.contains(where: { $0 == c }) {
            filterStr[c] = filterStr[c, default: 0] + 1
        }
    }
    return false
}


