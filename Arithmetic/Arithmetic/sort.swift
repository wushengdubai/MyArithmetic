//
//  sort.swift
//  算法
//
//  Created by 张清泉 on 2022/1/15.
//

import Foundation

/**
 1. 冒泡排序 -- 稳定(a=b,且a在b前面，不会对a b顺序造成破坏）
 循环比较相邻值，最小值放前面
 时间复杂度：O(n²)
 空间复杂度：O(1)
 */
func bubbleSort(_ nums: inout [Int]) {
    let len = nums.count
    for _ in 0..<len {
        for i in 0..<len-1 {
            if nums[i] > nums[i + 1] {
                let temp = nums[i]
                nums[i] = nums[i+1]
                nums[i+1] = temp
            }
        }
    }
}

/**
 2、选择排序 -- 不稳定
 每次选择最小值插入最前面
 时间复杂度：O(n²)
 空间复杂度：O(1) 
 */
func selectionSort(_ nums: inout [Int]) {
    var minIndex = 0, temp = 0
    for i in 0..<nums.count {
        minIndex = i
        for j in i+1..<nums.count {
            if nums[j] < nums[minIndex] {
                minIndex = j // 找到最小值
            }
        }
        temp = nums[i]
        nums[i] = nums[minIndex]
        nums[minIndex] = temp
    }
}

/**
 3、插入排序 -- 稳定
 
 时间复杂度：O(n²)
 空间复杂度：O(1)
 */
func insertionSort(_ nums: inout [Int]) {
    let len = nums.count
    var preIndex = 0, cur = 1
    for i in 1..<len {
        preIndex = i - 1
        cur = nums[i]
        while preIndex >= 0 && nums[preIndex] > cur {
            // 当preIndex值大于cur, 那么preIndex值后移
            nums[preIndex+1] = nums[preIndex]
            preIndex -= 1
        }
        // 插入cur到合适位置
        nums[preIndex+1] = cur
    }
}

/**
 4、希尔排序 -- 不稳定
 1959年Shell发明，第一个突破O(n^2)的排序算法，是简单插入排序的改进版。
 它与插入排序的不同之处在于，它会优先比较距离较远的元素。希尔排序又叫缩小增量排序。
 
 时间复杂度：O(nlog²n)
 空间复杂度：O(1)
 */
func shellSort(_ nums: inout [Int]) {
    // 增量gap，并逐步缩小增量
    var gap = nums.count/2 // 5 2
    while gap > 0 {
        // 从第gap个元素，组个对其组内元素进行插入排序
        for i in gap..<nums.count { //2..<10
            var j = i
            // 移动元素
            let tmp = nums[j] // 存储将要移动的元素
            if nums[j] < nums[j - gap] {
                while j - gap >= 0 && tmp < nums[j - gap] {
                    nums[j] = nums[j - gap]
                    j -= gap
                }
                nums[j] = tmp // 插入移动的元素
            }
            
            // 交换元素发
//            while j - gap >= 0 && nums[j] < nums[j - gap] {
//                nums.swapAt(j, j-gap)
//                j -= gap
//            }
        }
        // 缩小gap
        gap = gap/2
    }
}

/**
 5、归并排序 -- 稳定
 是在分治算法基础上设计出来的一种排序算法。
 把长度为n的输入序列分成两个长度为n/2的子序列；
 对这两个子序列分别采用归并排序；
 将两个排序好的子序列合并成一个最终的排序序列。
 
 时间复杂度：O(nlog n)
 空间复杂度：O(n)
 */
func mergeSort(_ nums: inout [Int]) {
    // 采用自上而下的递归法
    let len = nums.count
    if len < 2 { return }
    var result = Array(repeating: 0, count: len)
    mergeSortRecursive(&nums, &result, 0, len - 1)
}
func mergeSortRecursive(_ nums: inout [Int], _ result: inout [Int], _ begin: Int, _ end: Int) { // [-1,0,1,2,-1,-4]
    if begin >= end { return }
    let len = end - begin
    let mid = begin + len >> 1
    // 开始分割
    var b1 = begin, e1 = mid, b2 = mid+1, e2 = end
    mergeSortRecursive(&nums, &result, b1, e1)
    mergeSortRecursive(&nums, &result, b2, e2)
    var k = begin
    while b1 <= e1 && b2 <= e2 {
        if nums[b1] < nums[b2] {
            result[k] = nums[b1]
            b1 += 1
        } else {
            result[k] = nums[b2]
            b2 += 1
        }
        k += 1
    }
    while b1 <= e1 {
        result[k] = nums[b1]
        k += 1
        b1 += 1
    }
    while b2 <= e2 {
        result[k] = nums[b2]
        k += 1
        b2 += 1
    }
    // 重新赋值回原数组中
    for i in begin...end {
        nums[i] = result[i]
    }
}

/**
 6、快速排序 -- 不稳定
 快速排序使用分治法来把一个串（list）分为两个子串（sub-lists）。具体算法描述如下：
 - 从数列中挑出一个元素，称为 “基准”（pivot）；
 - 重新排序数列，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆在基准的后面（相同的数
 可以到任一边）。在这个分区退出之后，该基准就处于数列的中间位置。这个称为分区（partition）操作；
 - 递归地（recursive）把小于基准值元素的子数列和大于基准值元素的子数列排序。
 
 时间复杂度：最坏 O(n²)
           平均 O(nlogn)
 空间复杂度：O(log n)
 */
func quickSort(_ nums: inout [Int]) {
    quickSortRecursive(&nums, 0, nums.count - 1)
}

func quickSortRecursive(_ nums: inout [Int], _ begain: Int, _ end: Int) {
    if begain < end {
        let key = nums[begain] // 挑选基准值
        var i = begain, j = end
        while (i < j) {
            while (i<j && nums[j] > key) { // 右边大于基准值的，不交换，只移动指针
                j -= 1
            }
            if i<j { // 小于或等于基准值，交换
                nums[i] = nums[j]
                i += 1
            }
            while i<j && nums[i] < key {// 左边小于基准值的不交换
                i += 1
            }
            if i<j { // 左边大于基准值，交换
                nums[j] = nums[i]
                j -= 1
            }
        }
        nums[i] = key // 找到基准位置i
        quickSortRecursive(&nums, begain, i - 1)
        quickSortRecursive(&nums, i+1, end)
        
    }
}
