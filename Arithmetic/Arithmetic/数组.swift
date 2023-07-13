//
//  数组.swift
//  算法
//
//  Created by 张清泉 on 2022/2/17.
//

import Foundation

/**
 659. 分割数组为连续子序列
 
 给你一个按升序排序的整数数组 num（可能包含重复数字），请你将它们分割成一个或多个长度至少为 3 的子序列，其中每个子序列都由连续整数组成。

 如果可以完成上述分割，则返回 true ；否则，返回 false 。
 */
func isPossible(_ nums: [Int]) -> Bool {
    var freq = [Int: Int](), need = [Int: Int]()
    // 统计 nums 中每个元素出现的频率
    for v in nums {
        freq[v, default: 0] += 1
    }
    for v in nums {
        if freq[v] == 0 {
            // 已经被用到其他子序列中
            continue
        }
        // 先判断 v 是否能接到其他子序列后面
        if  need.keys.contains(v) && need[v]! > 0  {
            // v 可以接到之前的某个序列后面
            freq[v]! -= 1
            // 对 v 的需求减一
            need[v]! -= 1
            // 对 v + 1 的需求加一
            need[v + 1, default: 0] += 1
        } else if freq[v, default: 0] > 0
                && freq[v + 1, default: 0] > 0
                && freq[v + 2, default: 0] > 0 {
            // 将 v 作为开头，新建一个长度为 3 的子序列 [v,v+1,v+2]
            freq[v]! -= 1
            freq[v + 1]! -= 1
            freq[v + 2]! -= 1
            // 对 v + 3 的需求加一
            need[v + 3, default: 0] += 1
        } else {
            return false
        }
    }
    return true
}

/**
 1. 两数之和
 */
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    let nums = nums.sorted()
    var l = 0, r = nums.count - 1
    while l < r {
        let sum = nums[l] + nums[r]
        if sum < target {
            l += 1
        } else if sum > target {
            r -= 1
        } else {
            return [l, r]
        }
    }
    return []
}
/** 返回所有符合两数之和的所有数字，不能包含重复数据 */
func twoSums(_ nums: [Int], _ target: Int) -> [[Int]] {
    let nums = nums.sorted()
    var l = 0, r = nums.count - 1
    var ans = [[Int]]()
    while l < r {
        let left = nums[l], right = nums[r]
        let sum = left + right
        if sum < target {
            l += 1
            while l < r && nums[l] == left { l += 1 }
        } else if sum > target {
            r -= 1
            while l < r && nums[r] == right { r -= 1 }
        } else {
            ans.append([nums[l], nums[r]]) // 记录所有的符合数组
            // 跳过所有重复的元素
            while l < r && nums[l] == left { l += 1 }
            while l < r && nums[r] == right { r -= 1 }
        }
    }
    return ans
}

/**
 15、三数之和
 
 给你一个包含 n 个整数的数组 nums，判断 nums 中是否存在三个元素 a，b，c ，使得 a + b + c = 0 ？请你找出所有和为 0 且不重复的三元组。

 注意：答案中不可以包含重复的三元组。[-1,0,1,2,-1,-4]
 */
func threeSum(_ nums: [Int]) -> [[Int]] {
    let nums = nums.sorted()
    var i = 0
    var ans = [[Int]]()
    
    while i < nums.count {
        // 穷举 threeSum 的第一个数
        let turples = twoSumTarget(nums, i+1, nums[i])
        turples.forEach { turple in
            var turple = turple
            turple.append(nums[i])
            ans.append(turple)
        }
        i += 1
        // 跳过重复的第一个元素
        while i < nums.count - 1 && nums[i] == nums[i+1] { i += 1}
    }
    return ans
}
/** 返回所有符合两数之和的所有数字，不能包含重复数据 */
func twoSumTarget(_ nums: [Int], _ start: Int, _ target: Int) -> [[Int]] {
    var l = start, r = nums.count - 1
    var ans = [[Int]]()
    while l < r {
        let left = nums[l], right = nums[r]
        let sum = left + right
        if sum < target {
            l += 1
            while l < r && nums[l] == left { l += 1 }
        } else if sum > target {
            r -= 1
            while l < r && nums[r] == right { r -= 1 }
        } else {
            ans.append([nums[l], nums[r]]) // 记录所有的符合数组
            // 跳过所有重复的元素
            while l < r && nums[l] == left { l += 1 }
            while l < r && nums[r] == right { r -= 1 }
        }
    }
    return ans
}

/**
 18. N数之和
 注意 nums 一定要是排序好的数组
 n 为多少数之和
 */
func nSumTarget(_ nums: [Int], _ n: Int, _ start: Int, _ target: Int) -> [[Int]] {
    let sz = nums.count
    var ans = [[Int]]()
    // 至少是 2Sum，且数组大小不应该小于 n
    if n < 2 || sz < n { return ans }
    
    // base case
    if n == 2 {
        // 求两数之和
        var l = start, r = sz - 1
        while l < r {
            let left = nums[l], right = nums[r]
            let sum = left + right
            if sum < target {
                l += 1
                while l < r && nums[l] == left { l += 1 }
            } else if sum > target {
                r -= 1
                while l < r && nums[r] == right { r -= 1 }
            } else {
                ans.append([nums[l], nums[r]]) // 记录所有的符合数组
                // 跳过所有重复的元素
                while l < r && nums[l] == left { l += 1 }
                while l < r && nums[r] == right { r -= 1 }
            }
        }
    } else {
        // n > 2 时，递归计算 (n-1)Sum 的结果
        var i = 0
        while i < sz {
            // 穷举 nSum 的第一个数
            let turples = nSumTarget(nums, n-1, i+1, target - nums[i])
            turples.forEach { t in
                var turple = t
                turple.append(nums[i])
                ans.append(turple)
            }
            i += 1
            while i < sz - 1 && nums[i] == nums[i + 1] { i += 1 }
        }
    }
    return ans
}

/**
 给定一个数组，它的第 i 个元素是一支给定股票第 i 天的价格。
 如果你最多只允许完成一笔交易（即买入和卖出一支股票一次），设计一个算法来计算你所能获取的最大利润。

 注意：你不能在买入股票前卖出股票。
 */
func maxProfit(_ prices: [Int]) -> Int {
    if prices.count < 2 { return 0 }
    var minPrice = prices[0], result = 0
    
    for i in prices {
        result = max(result, i - minPrice)
        minPrice = min(minPrice, i)
    }
    return result
    
}
