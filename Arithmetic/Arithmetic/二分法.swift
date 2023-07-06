//
//  二分法.swift
//  算法
//
//  Created by 张清泉 on 2022/1/15.
//

import Foundation

// 蓝红划分，二分法模板：https://www.bilibili.com/video/BV1d54y1q7k7?spm_id_from=333.999.0.0

/**
 34. 在排序数组中查找元素的第一个和最后一个位置
 给定一个按照升序排列的整数数组 nums，和一个目标值 target。找出给定目标值在数组中的开始位置和结束位置。
 如果数组中不存在目标值 target，返回 [-1, -1]。

 进阶：
 你可以设计并实现时间复杂度为 O(log n) 的算法解决此问题吗？
 */
func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
    let cnt = nums.count
    if cnt == 0 { return [-1, -1] }
    var left = -1, right = cnt
    while left + 1 != right {
        let mid = (left + right)/2
        if nums[mid] < target { // 小于target区域
            left = mid
        } else {
            right = mid // 大于target区域
        }
    }
    
    if right != cnt && nums[right] == target {
        while right + 1 < cnt {
            if nums[right + 1] != target {
                break
            }
            right += 1
        }
        return [left + 1, right]
    } else {
        return [-1, -1]
    }
}


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
    
    let i = star1 + min(len1, k/2) - 1
    let j = star2 + min(len2, k/2) - 1
    if nums1[i] > nums2[j] { // 比较二者, 丢弃较小值部分
        return getkth(nums1, star1: star1, end1: end1, nums2, star2: j + 1, end2: end2, k: k - (j - star2 + 1))
    } else {
        return getkth(nums1, star1: i + 1, end1: end1, nums2, star2: star2, end2: end2, k: k - (i - star1 + 1))
    }
}

/**
 33、搜索旋转排序数组
 整数数组 nums 按升序排列，数组中的值 互不相同 。

 在传递给函数之前，nums 在预先未知的某个下标 k（0 <= k < nums.length）上进行了 旋转，使数组变为 [nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]（下标 从 0 开始 计数）。例如， [0,1,2,4,5,6,7] 在下标 3 处经旋转后可能变为 [4,5,6,7,0,1,2] 。

 给你 旋转后 的数组 nums 和一个整数 target ，如果 nums 中存在这个目标值 target ，则返回它的下标，否则返回 -1 。
 
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
        let m = (l + r)/2
        if nums[m] >= nums[0] { // mid在左边
            // targe在左边前半部分
            if nums[m] > target && nums[0] <= target {
                r = m
            } else {
                l = m
            }
        } else { // mid 在右边
            if nums[m] < target && nums[0] > target { // targe在右边后半部分
                l = m
            } else {
                r = m
            }
        }
    }
    return nums[r == cnt ? cnt - 1 : r] == target ? r : -1
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
        // rw未缩小时，要取cnt-1
        if nums[m] <= nums[r == cnt ? cnt - 1 : r] {  // 说明中间位于右侧，最小点在中间点或者左边
            r = m
        } else { // 中加点位于左侧，说明拐点在右侧
            l = m
        }
    }
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
        if arr[m] <= arr[m+1 < cnt ? m+1 : m] { // mid 在递增序列
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
    var l = -1, r = nums.count
    while l + 1 != r {
        let m = (l + r) >> 1
        if nums[m] >= nums[m + 1 == nums.count ? m : m+1] {
            r = m
        } else {
            l = m
        }
    }
    return r
}

/// 遍历二叉树深度
class TraverseDepth {
    // 记录最终最大深度
    var res: Int = 0
    // 记录单节点深度
    var depth: Int = 0
    
    func maxDepth(_ root: TreeNode?) -> Int {
        traverse(root)
        return res
    }
    
    // 递归遍历
    func traverse(_ root: TreeNode?) {
        if root == nil {
            res = max(res, depth)
            return
        }
        // 前序遍历位置
        depth += 1
        traverse(root!.left)
        traverse(root!.right)
        // 后序遍历位置
        depth -= 1
    }
    
    func maxDepth2(_ root: TreeNode?) -> Int {
        if root == nil {
            return 0
        }
        
        // 递归计算左右字数的最大深度
        var leftMax = maxDepth2(root!.left)
        var rightMax = maxDepth2(root!.right)
        
        // 返回左右字数最大深度+根节点1
        return max(leftMax, rightMax) + 1
    }
}


// 124. 二叉树中的最大路径和
class MaxPathSum {
    var res: Int = Int.min
    
    func maxPathSum(_ root: TreeNode?) -> Int {
        if root == nil {
            return 0
        }
        
        var left  = max(0, maxPathSum(root!.left))
        var right = max(0, maxPathSum(root!.right))
        // 后序位置
        res = max(res, left + right + root!.val)
        
        return max(left, right) + root!.val
    }
}

/// 二叉树前序遍历
class PreorderTraverse {
    
    var res = [Int]()
    
    func preorderTraverse(_ root: TreeNode?) -> [Int] {
        traverse1(root)
        return res
    }
    
    // 前序遍历
    func traverse1(_ root: TreeNode?) {
        if root == nil { return }
        res.append(root!.val)
        traverse1(root!.left)
        traverse1(root!.right)
    }
    
    // 前序遍历, 不定义外部变量
    func traverse2(_ root: TreeNode?) -> [Int]  {
        var res = [Int]()
        if root == nil { return res }
        res.append(root!.val)
        
        res.append(contentsOf:traverse2(root!.left))
        res.append(contentsOf:traverse2(root!.right))
        return res
    }
}

/// 计算二叉树的最大直径
class MaxDiameter {
    var maxDiameter = 0
    
    func diameterOfTreeNode(_ root: TreeNode?) -> Int {
        
        return maxDiameter
    }
    
    // 后序遍历
    func maxDiameter(_ root: TreeNode?) -> Int {
        if root == nil {  return 0 }
        
        var left = maxDiameter(root!.left)
        var right = maxDiameter(root!.right)
        // 在后序位置，计算当前节点的左右子树深度
        let tmp = left + right
        // 存储当前节点的最大直径
        maxDiameter = max(maxDiameter, tmp)
        
        // 返回左/右子树最大深度
        return max(left, right) + 1
    }
}

/// 层序遍历
class LevelTraverse {
    
    
    func levelTraverse1(_ root: TreeNode?) {
        if root == nil { return }
        // 存储每层的节点
        var queue = [TreeNode]();
        queue.append(root!)
        
        while !queue.isEmpty {
            for _ in 0..<queue.count {
                let node = queue.removeFirst()
                if node.left != nil {
                    queue.append(node.left!)
                }
                
                if node.right != nil {
                    queue.append(node.right!)
                }
            }
        }
    }
    
    
    var res = [[Int]]()
    /// 递归方式 获取每层元素
    func levelTraverse2(_ root: TreeNode?) -> [[Int]] {
        traverse(root, 0)
        return res
    }
    
    func traverse(_ root: TreeNode?, _ level: Int) {
        if root == nil { return }
        
        if res.count <= level {
            res.append([Int]())
        }
        // 前序位置，添加层节点
        res[0].append(root!.val)
        traverse(root!.left, level+1)
        traverse(root!.right, level+1)
    }
}
