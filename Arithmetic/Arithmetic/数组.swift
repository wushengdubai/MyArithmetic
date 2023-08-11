//
//  数组.swift
//  算法
//
//  Created by 张清泉 on 2022/2/17.
//

import Foundation


/**
 1870. 准时到达的列车最小时速
 
 给你一个浮点数 hour ，表示你到达办公室可用的总通勤时间。要到达办公室，你必须按给定次序乘坐 n 趟列车。另给你一个长度为 n 的整数数组 dist ，其中 dist[i] 表示第 i 趟列车的行驶距离（单位是千米）。
 每趟列车均只能在整点发车，所以你可能需要在两趟列车之间等待一段时间。
 例如，第 1 趟列车需要 1.5 小时，那你必须再等待 0.5 小时，搭乘在第 2 小时发车的第 2 趟列车。
 返回能满足你准时到达办公室所要求全部列车的【最小正整数 时速】（单位：千米每小时），如果无法准时到达，则返回 -1 。
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
    var left = 1, right = 10000000
    while left < right {
        let mid = left + (right - left) >> 1
        if check(dist, hour, speed: mid) {
            right = mid
        } else {
            left = mid + 1
        }
    }
    return check(dist, hour, speed: left) ? left : -1
}

private func check(_ dist: [Int], _ hour: Double, speed: Int) -> Bool {
    var res: Double = 0
    for (i, d) in dist.enumerated() {
        let cos = Double(d) / Double(speed)
        res +=  (i == dist.count - 1 ? cos : ceil(cos))
    }
    return res <= hour
}

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

/**
 11. 盛最多水的容器
 
 给定一个长度为 n 的整数数组 height 。有 n 条垂线，第 i 条线的两个端点是 (i, 0) 和 (i, height[i]) 。
 找出其中的两条线，使得它们与 x 轴共同构成的容器可以容纳最多的水。
 返回容器可以储存的最大水量。
 说明：你不能倾斜容器。
 */
func maxArea(_ height: [Int]) -> Int {
    var i = 0, j = height.count - 1, res = 0
    while i < j {
        if height[i] < height[j] {
            res = max(res, height[i] * (j - i))
            i += 1
        } else {
            res = max(res, height[j]*(j-i))
            j -= 1
        }
    }
    return res
}
