//
//  差分数组.swift
//  算法
//
//  Created by 张清泉 on 2022/1/19.
//

import Foundation

/**
 差分数组的主要适用场景是频繁对原始数组的某个区间的元素进行增减。
 */
class Difference {
    /// 差分数组
    private var diff: [Int]
    
    /* 输入一个初始数组，区间操作将在这个数组上进行 */
    init(_ nums: [Int]) {
        diff = Array(repeating: 0, count: nums.count)
        if nums.count > 0 {
            diff[0] = nums[0]
            for i in 1..<nums.count {
                diff[i] = nums[i] - diff[i-1]
            }
        }
    }
    
    /* 给闭区间 [i,j] 增加 val（可以是负数）*/
    public func increment(_ i: Int, _ j: Int, _ val: Int) {
        diff[i] += val // 还原数组时，从i 往后的元素都会 + val
        if j + 1 < diff.count {
            diff[j + 1] -= val // 还原数组时，从j+1 往后的元素都会 - val
        }
    }
    
    /** 根据差分数组，还原数组*/
    public func results() -> [Int] {
        var res = Array(repeating: 0, count: diff.count)
        res[0] = diff[0]
        for i in 1..<diff.count {
            res[i] = res[i - 1] + diff[i]
        }
        return res
    }
}

/**
 1109. 航班预订统计
 
 这里有 n 个航班，它们分别从 1 到 n 进行编号。
 有一份航班预订表 bookings ，表中第 i 条预订记录 bookings[i] = [firsti, lasti, seatsi] 意味着在从 firsti 到 lasti （包含 firsti 和 lasti ）的 每个航班 上预订了 seatsi 个座位。

 请你返回一个长度为 n 的数组 answer，里面的元素是每个航班预定的座位总数。

 提示：
 1 <= n <= 2 * 104
 1 <= bookings.length <= 2 * 104
 bookings[i].length == 3
 1 <= firsti <= lasti <= n
 1 <= seatsi <= 104
 */
func corpFlightBookings(_ bookings: [[Int]], _ n: Int) -> [Int] {
    let ans = Array(repeating: 0, count: n)
    let df = Difference(ans)
    for booking in bookings {
        df.increment(booking[0] - 1, booking[1] - 1, booking[2])
    }
    return df.results()
}

/**
 1094. 拼车
 假设你是一位顺风车司机，车上最初有 capacity 个空座位可以用来载客。由于道路的限制，车 只能 向一个方向行驶（也就是说，不允许掉头或改变方向，你可以将其想象为一个向量）。

 这儿有一份乘客行程计划表 trips[][]，其中 trips[i] = [num_passengers, start_location, end_location] 包含了第 i 组乘客的行程信息：
 必须接送的乘客数量；
 乘客的上车地点；
 以及乘客的下车地点。
 这些给出的地点位置是从你的 初始 出发位置向前行驶到这些地点所需的距离（它们一定在你的行驶方向上）。

 请你根据给出的行程计划表和车子的座位数，来判断你的车是否可以顺利完成接送所有乘客的任务（当且仅当你可以在所有给定的行程中接送所有乘客时，返回 true，否则请返回 false）
 
 提示：
 你可以假设乘客会自觉遵守 “先下后上” 的良好素质
 trips.length <= 1000
 trips[i].length == 3
 1 <= trips[i][0] <= 100
 0 <= trips[i][1] < trips[i][2] <= 1000
 1 <= capacity <= 100000
 */
func carPooling(_ trips: [[Int]], _ capacity: Int) -> Bool {
    // 构造最多有1000站
    let ans = Array(repeating: 0, count: 1000)
    let df = Difference(ans)
    for trip in trips {
        df.increment(trip[1] - 1, trip[2] - 1, trip[0])
    }
    // 获取每一站车上的人数
    let res = df.results()
    for re in res {
        if re > capacity { // 超载了
            return false
        }
    }
    return true
}
