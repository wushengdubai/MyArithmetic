//
//  前缀合数组.swift
//  算法
//
//  Created by 张清泉 on 2022/1/19.
//

import Foundation

/**
 303、一维数组前缀和
 
 给定一个整数数组  nums，求出数组从索引 i 到 j（i ≤ j）范围内元素的总和，包含 i、j 两点。

 实现 NumArray 类：
 NumArray(int[] nums) 使用数组 nums 初始化对象
 int sumRange(int i, int j) 返回数组 nums 从索引 i 到 j（i ≤ j）范围内元素的总和，包含 i、j 两点（也就是 sum(nums[i], nums[i + 1], ... , nums[j])）
 */
class NumArray {
    // 构造前缀和
    private var preSum: [Int]

    init(_ nums: [Int]) {
        preSum = Array(repeating: 0, count: nums.count + 1)
        for i in 1...nums.count {
            preSum[i] = preSum[i - 1] + nums[i - 1]
        }
    }
    
    func sumRange(_ left: Int, _ right: Int) -> Int {
        return preSum[right + 1] - preSum[left]
    }
}

/**
 304、二维数组前缀和
 
 给定一个二维矩阵 matrix，以下类型的多个请求：
 计算其子矩形范围内元素的总和，该子矩阵的 左上角 为 (row1, col1) ，右下角 为 (row2, col2) 。
 
 实现 NumMatrix 类：
 NumMatrix(int[][] matrix) 给定整数矩阵 matrix 进行初始化
 int sumRegion(int row1, int col1, int row2, int col2) 返回 左上角 (row1, col1) 、右下角 (row2, col2) 所描述的子矩阵的元素 总和 。
 */
class NumMatrix {
    private var preSum: [[Int]]
    
    init(_ matrix: [[Int]]) {
        let m = matrix.count, n = matrix[0].count
        preSum = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
        for i in 1...m {
            for j in 1...n {
                // 计算每个矩阵 [0, 0, i, j] 的元素和
                preSum[i][j] = preSum[i-1][j] + preSum[i][j-1] + matrix[i-1][j-1] - preSum[i-1][j-1]
            }
        }
    }
    
    func sumRegion(_ row1: Int, _ col1: Int, _ row2: Int, _ col2: Int) -> Int {
        // ⽬标矩阵之和由四个相邻矩阵运算获得
        return preSum[row2+1][col2+1] - preSum[row1][col2+1] - preSum[row2+1][col1] +
        preSum[row1][col1];
    }
}

/**
 560、和为 K 的子数组
 给你一个整数数组 nums 和一个整数 k ，请你统计并返回该数组中和为 k 的连续子数组的个数。
 */
func subarraySum(_ nums: [Int], _ k: Int) -> Int {
    let n = nums.count
    // 默认元素之和为0，有一个
    var preSum = [0: 1]
    var ans = 0, sumi = 0 // sumi表示前i个元素之和
    for i in 0..<n {
        // 计算前i个元素之和
        sumi += nums[i]
        // 这是我们想找的前缀和 nums[0..j]
        let sumj = sumi - k
        // 如果前面有这个前缀和，则直接更新答案
        if let cnt = preSum[sumj] {
            ans += cnt
        }
        preSum[sumi] = (preSum[sumi] ?? 0) + 1
    }
    return ans
}
/** 非最优解 暴力遍历 */
func subarraySum1(_ nums: [Int], _ k: Int) -> Int {
    let n = nums.count
    var preSum = Array(repeating: 0, count: n+1)
    for i in 0..<n {
        // 构造前缀和数组
        preSum[i+1] = preSum[i] + nums[i]
    }
    var ans = 0
    
    // 穷举所有子数组
    for i in 1...n {
        for j in 0..<i {
            // 子数组nums[j..i-1]的元素和
            if preSum[i] - preSum[j] == k {
                ans += 1
            }
        }
    }
    return ans
}
