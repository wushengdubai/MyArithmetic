//
//  TreeNode.swift
//  Arithmetic
//
//  Created by qingquan on 2023/4/24.
//

import Foundation

// Definition for a binary tree node.
public class TreeNode {
    var val: Int
    var left: TreeNode?
    var right: TreeNode?
    init() { self.val = 0; self.left = nil; self.right = nil; }
    init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
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
    
}
