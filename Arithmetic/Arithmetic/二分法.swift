//
//  二分法.swift
//  算法
//
//  Created by 张清泉 on 2022/1/15.
//

import Foundation

/**
 蓝红划分，二分法模板：https://www.bilibili.com/video/BV1d54y1q7k7?spm_id_from=333.999.0.0
 
 l = -1,  r = count
 
 while l + 1 != r {
    let mid = l + (r - l) / 2
    if  isBlue {
        l = m
    } else {
        r = m
    }
    // 根据具体问题返回
    return l or r
 }
 
 l为蓝色边界    r为红色边界
 不会发生溢出：l和r 可推导出始终处于[0, count)之间  r最大 = count - 2 r最大=count 所有m最大=count-1;  l最小=-1 r最小=1所有m最小为0
 不会进入死循环 l + 1 == r，直接退出循环 ； l + 2 == r  推导出 mid = l + 1， 下一次循环也会退出;
 isBlue是数据处于蓝色边界的条件，需要根据具体问题定义
 */
//



/**
 34. 在排序数组中查找元素的第一个和最后一个位置
 给定一个按照升序排列的整数数组 nums，和一个目标值 target。找出给定目标值在数组中的开始位置和结束位置。
 如果数组中不存在目标值 target，返回 [-1, -1]。

 进阶：
 你可以设计并实现时间复杂度为 O(log n) 的算法解决此问题吗？
 */
func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
    let l = searchLeft(nums, target)
    let r = searchLeft(nums, target + 1)
    return l == r ? [-1, -1] : [l, r - 1]
}


private func searchLeft(_ nums: [Int], _ target: Int) -> Int {
    var left = 0, right = nums.count - 1
    while left < right {
        let mid = left + (right - left) / 2
        if nums[mid] < target {
            left = mid + 1
        } else {
            right = mid
        }
    }
    return left
}
//func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
//    let c = nums.count
//    if c == 0 { return [-1, -1] }
//    var left = 0, right = c - 1
//    while left <= right {
//        // 使用这种求中位数，放在（left + right）大数溢出
//        let mid = left + (right - left)/2
//        if nums[mid] < target { // 小于target区域
//            left = mid + 1
//        } else {
//            right = mid - 1 // 大于等于target区域
//        }
//    }
//
//    if left < c && nums[left] == target {
//        right = left
//        while right + 1 < c && nums[right + 1] == target  {
//            right += 1
//        }
//        return [left, right]
//    } else {
//        return [-1, -1]
//    }
//}


/**
 4. 寻找两个正序数组的中位数
 给定两个大小分别为 m 和 n 的正序（从小到大）数组 nums1 和 nums2。请你找出并返回这两个正序数组的 中位数 。

 算法的时间复杂度应该为 O(log (m+n)) 。
 */
func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
    let n = nums1.count, m = nums2.count
    let left = (n + m + 1)/2
    let right = (n + m + 2)/2
    // 将偶数和奇数的情况合并，如果是奇数，会求两次同样的 k 。
    return Double(getkth(nums1, star1: 0, end1: n-1, nums2, star2: 0, end2: m-1, k: left) + getkth(nums1, star1: 0, end1: n-1, nums2, star2: 0, end2: m-1, k: right)) * 0.5
}
// 从两个数组中找第K小的值
func getkth(_ nums1: [Int], star1: Int, end1: Int, _ nums2: [Int], star2: Int, end2: Int, k: Int) -> Int {
    let len1 = end1 - star1 + 1, len2 = end2 - star2 + 1
    // 让 len1 的长度小于 len2，这样就能保证如果有数组空了，一定是 len1
    if len1 > len2 {
        return getkth(nums2, star1: star2, end1: end2, nums1, star2: star1, end2: end1, k: k)
    }
    
    // base case
    if len1 == 0 { // len1数组空了，返回len2数组中的第K小的值即可
        return nums2[star2 + k - 1]
    }
    if k == 1 { // 当递归到k = 1时，返回数组中较小值，即为第K小的值
        return min(nums1[star1], nums2[star2])
    }
    
    let i = star1 + min(len1, k/2) - 1// nums1中第 k/2 位
    let j = star2 + min(len2, k/2) - 1 // nums2中第 k/2 位
    if nums1[i] > nums2[j] { // 比较二者, 丢弃较小值部分 即2分法去除k/2个数据
        return getkth(nums1, star1: star1, end1: end1, nums2, star2: j + 1, end2: end2, k: k - (j - star2 + 1))
    } else {
        return getkth(nums1, star1: i + 1, end1: end1, nums2, star2: star2, end2: end2, k: k - (i - star1 + 1))
    }
}

/**
 162、寻找数组元素的峰值
 峰值元素是指其值严格大于左右相邻值的元素。
 给你一个整数数组 nums，找到峰值元素并返回其索引。数组可能包含多个峰值，在这种情况下，返回 任何一个峰值 所在位置即可。
 你可以假设 nums[-1] = nums[n] = -∞ 。

 你必须实现时间复杂度为 O(log n) 的算法来解决此问题。
 
 提示：
 1 <= nums.length <= 1000
 -231 <= nums[i] <= 231 - 1
 对于所有有效的 i 都有 nums[i] != nums[i + 1]
 */
func findPeakElement(_ nums: [Int]) -> Int {
    if nums.count == 1 { return nums[0] }
    var l = 0, r = nums.count - 1
    while l < r {
        let m = l + (r - l)/2
        if nums[m] > nums[m + 1] {
            r = m
        } else {
            l = m + 1
        }
    }
    return l
}

/**
 33、搜索旋转排序数组
 整数数组 nums 按升序排列，数组中的值 互不相同 。

 在传递给函数之前，nums 在预先未知的某个下标 k（0 <= k < nums.length）上进行了 旋转，使数组变为 [nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]（下标 从 0 开始 计数）。例如， [0,1,2,4,5,6,7] 在下标 3 处经旋转后可能变为 [4,5,6,7,0,1,2] 。

 给你 旋转后 的数组 nums 和一个整数 target ，如果 nums 中存在这个目标值 target ，则返回它的下标，否则返回 -1 。
 你必须设计一个时间复杂度为 O(log n) 的算法解决此问题。
 
 提示：
 1 <= nums.length <= 5000
 -10^4 <= nums[i] <= 10^4
 nums 中的每个值都 独一无二
 题目数据保证 nums 在预先未知的某个下标上进行了旋转
 -10^4 <= target <= 10^4
 */
func searchRotateArray(_ nums: [Int], _ target: Int) -> Int {
    let cnt = nums.count
    var l = -1, r = cnt
    
    while l + 1 != r {
        let m = l + (r - l)/2
        if target >= nums[0] { // target在左半部分
            // m点在右边
            if nums[m] < nums[0] {
                r = m
            } else {
                // m点在左边
                if nums[m] <= target {
                    l = m
                } else {
                    r = m
                }
            }
        } else { // target 在右半部分
            if nums[m] >= nums[0] { // m点在左边
                l = m
            } else { // m点在右边
                if nums[m] <= target {
                    l = m
                } else {
                    r = m
                }
            }
        }
    }
    
    return nums[l] == target ? l : -1
}

/** 先找到拐点，在继续二分法找目标值*/
func searchRotateArray1(_ nums: [Int], _ target: Int) -> Int {
    let cnt = nums.count
    var l = -1, r = cnt
    // 找到旋转点,最终值为r
    while l + 1 != r {
        let m = (l+r)/2
        // r未缩小时，要取cnt-1
        if nums[m] <= nums[r == cnt ? cnt - 1 : r] {  // 说明中间位于右侧，最小点在中间点的左边
            r = m
        } else { // 中加点位于左侧，说明拐点在右侧
            l = m
        }
    }
    
    // 二分法找到目标值
    let inLeft = target > nums[cnt-1] // 判断目标值是否在旋转数组中的左侧范围
    if inLeft {
        l = -1
        r += 1
    } else {
        l = r-1
        r = cnt
    }
    
    while l + 1 != r {
        let m = (l+r)/2
        if nums[m] < target {
            l = m
        } else {
            r = m
        }
    }
    return nums[r == cnt ? cnt - 1 : r] == target ? r : -1
}

/**
 81. 搜索旋转排序数组 II
 已知存在一个按非降序排列的整数数组 nums ，数组中的值不必互不相同。
 在传递给函数之前，nums 在预先未知的某个下标 k（0 <= k < nums.length）上进行了 旋转 ，使数组变为 [nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]（下标 从 0 开始 计数）。例如， [0,1,2,4,4,4,5,6,6,7] 在下标 5 处经旋转后可能变为 [4,5,6,6,7,0,1,2,4,4] 。

 给你 旋转后 的数组 nums 和一个整数 target ，请你编写一个函数来判断给定的目标值是否存在于数组中。如果 nums 中存在这个目标值 target ，则返回 true ，否则返回 false 。
 */
func search(_ nums: [Int], _ target: Int) -> Bool {
    let cnt = nums.count
    var l = 0, r = cnt - 1
    while l <= r {
        let m = l + (r - l)/2
        if nums[m] == target { return true }
        if nums[l] == nums[m] { // 无法分清m点处于左边还是右边
            l += 1
            continue
        }
        if nums[m] > nums[0] { // mid在旋转点的左边
            // targe在左边前半部分
            if nums[m] > target && nums[l] <= target  {
                r = m - 1
            } else { // targe在左边后半部分
                l = m + 1
            }
        } else { // mid 在右边
            if nums[m] < target && nums[r] >= target { // targe在右边后半部分
                l = m + 1
            } else { // targe在右边前半部分
                r = m - 1
            }
        }
    }
    return false
}

/**
 153. 寻找旋转排序数组中的最小值
 已知一个长度为 n 的数组，预先按照升序排列，经由 1 到 n 次 旋转 后，得到输入数组。例如，原数组 nums = [0,1,2,4,5,6,7] 在变化后可能得到：
 若旋转 4 次，则可以得到 [4,5,6,7,0,1,2]
 若旋转 7 次，则可以得到 [0,1,2,4,5,6,7]
 注意，数组 [a[0], a[1], a[2], ..., a[n-1]] 旋转一次 的结果为数组 [a[n-1], a[0], a[1], a[2], ..., a[n-2]] 。
 
 提示：
 n == nums.length
 1 <= n <= 5000
 -5000 <= nums[i] <= 5000
 nums 中的所有整数 互不相同
 nums 原来是一个升序排序的数组，并进行了 1 至 n 次旋转
 */
func findMin(_ nums: [Int]) -> Int {
    let cnt = nums.count
    var l = -1, r = cnt
    while l + 1 != r {
        let m = (l+r)/2
        // r未缩小时，要取cnt-1
        if nums[m] > nums[r == cnt ? cnt - 1 : r] {
            // 表明中间点位于旋转点左侧，即最小值在右侧
            l = m
        } else {
            // 中间点位于旋转点右侧，即最小值在左侧
            r = m
        }
    }
    // 最小值最终落在r上
    return nums[r]
}


/**
 852. 山脉数组的峰顶索引
 符合下列属性的数组 arr 称为 山脉数组 ：
 arr.length >= 3
 存在 i（0 < i < arr.length - 1）使得：
 arr[0] < arr[1] < ... arr[i-1] < arr[i]
 arr[i] > arr[i+1] > ... > arr[arr.length - 1]
 给你由整数组成的山脉数组 arr ，返回任何满足 arr[0] < arr[1] < ... arr[i - 1] < arr[i] > arr[i + 1] > ... > arr[arr.length - 1] 的下标 i 。
 
 提示：
 3 <= arr.length <= 104
 0 <= arr[i] <= 106
 题目数据保证 arr 是一个山脉数组
 */
func peakIndexInMountainArray(_ arr: [Int]) -> Int {
    let cnt = arr.count
    var l = -1, r = cnt
    while l + 1 != r {
        let m = (l + r)/2
        if arr[m] < arr[m+1 < cnt ? m+1 : m] { // mid 在递增序列
            l = m
        } else { // mid 在递减序列中
            r = m
        }
    }
    return r
}

/**
 1095. 山脉数组中查找目标值
 给你一个 山脉数组 mountainArr，请你返回等于 target 最小 的下标 index 值。

 如果不存在这样的下标 index，就请返回 -1。
 */
func findInMountainArray(_ target: Int, _ mountainArr: [Int]) -> Int {
    /** 找到峰值*/
    let peak = peakIndexInMountainArray(mountainArr)
    var l = -1, r = peak + 1
    while l + 1 != r { // 二分前半段递增数组
        let m = (l + r)/2
        if mountainArr[m] < target {
            l = m
        } else {
            r = m
        }
    }
    if mountainArr[r] == target {
        return r
    } else {
        // 二分递减数组
        l = peak
        r = mountainArr.count
        while l + 1 != r {
            let m = (l + r)/2
            if mountainArr[m] <= target {
                r = m
            } else {
                l = m
            }
        }
        return mountainArr[r] == target ? r : -1
    }
}

/**
 69、求算术平方根
 */
func mySqrt(_ x: Int) -> Int {
    if x == 0 { return x }
    var l = -1, r = x + 1
    while l + 1 != r {
        let m = (l + r) >> 1
        if m * m > x {
            r = m
        } else {
            l = m
        }
    }
    return l
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
    var left = -1, right = chalk.count
    while left + 1 != right {
        let mid = (left + right) >> 1
        if preSum[mid + 1] < k {
            // 说明中点位置不需要补充粉笔
            left =  mid
        } else {
            right = mid
        }
    }
    return right
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
