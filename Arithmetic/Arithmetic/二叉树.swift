//
//  二叉树.swift
//  算法
//
//  Created by 张清泉 on 2022/2/9.
//

import Foundation

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public var next: TreeNode?
    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

extension TreeNode: Equatable {
    public static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        return lhs.val == rhs.val
    }
}


public class Node {
    public var val: Int
    public var prev: Node?
    public var next: Node?
    public var child: Node?
    public init() { self.val = 0 }
    public init(_ val: Int) {self.val = val }
    public init(_ val: Int, _ next: Node?) { self.val = val; self.next = next; }
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
        res[level].append(root!.val)
        traverse(root!.left, level+1)
        traverse(root!.right, level+1)
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
        // 后序位置，比较最大
        res = max(res, left + right + root!.val)
        
        return max(left, right) + root!.val
    }
}

/**
 543、「二叉树的直径」，计算一棵二叉树的最长直径长度。

 所谓二叉树的「直径」长度，就是任意两个结点之间的路径长度。最长「直径」并不一定要穿过根结点，比如下面这棵二叉树：
        9
         1
       2   3
     4   5
 它的最长直径是 3，即 [4,2,1,3] 或者 [5,2,1,3] 这两条「直径」的长度。
 */
// 保存最大直径长度
var maxDiamater = 0
func diameterOfBinaryTree(_ root: TreeNode?) -> Int {
    // 计算每个节点左右字数深度之和
    _ = maxDepth(root)
    return maxDiamater
}
// 计算最大深度
func maxDepth(_ root: TreeNode?) -> Int {
    if root == nil {
        return 0
    }
    let leftDepth = maxDepth(root?.left)
    let rightDepth = maxDepth(root?.right)
    // 在后序位置，计算当前节点的左右子树深度
    let tmp = leftDepth + rightDepth
    // 存储当前节点的最大直径
    maxDiamater = max(maxDiamater, tmp)
    return max(leftDepth, rightDepth) + 1
}

/**
 226. 翻转二叉树
 给你一棵二叉树的根节点 root ，翻转这棵二叉树，并返回其根节点。
 */
func invertTree(_ root: TreeNode?) -> TreeNode? {
    if root == nil { return nil }
    let tmp = root?.left
    root?.left = root?.right
    root?.right = tmp
    
    _ = invertTree(root?.left)
    _ = invertTree(root?.right)
    return root
}

/**
 105. 从前序与中序遍历序列构造二叉树
 
 给定两个整数数组 preorder 和 inorder ，其中 preorder 是二叉树的先序遍历， inorder 是同一棵树的中序遍历，请构造二叉树并返回其根节点。
 */
func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
    return build(preorder, 0, preorder.count-1, inorder, 0, inorder.count-1)
}
func build(_ preorder: [Int], _ preS: Int, _ preE: Int,
           _ inorder: [Int], _ inS: Int, _ inE: Int) -> TreeNode? {
    if preS > preE { return nil }
    let rootVal = preorder[preS]
    // rootVal 在中序遍历数组中的索引
    var index = 0
    for i in inS...inE {
        if inorder[i] == rootVal {
            index = i
            break
        }
    }
    
    let root = TreeNode(rootVal)
    root.left = build(preorder, preS+1, preS+(index-inS), inorder, inS, index-1)
    root.right = build(preorder, preS+1+(index-inS), preE, inorder, index+1, inE)
    return root
}

/**
 889. 根据前序和后序遍历构造二叉树
 给定两个整数数组，preorder 和 postorder ，其中 preorder 是一个具有 无重复 值的二叉树的前序遍历，postorder 是同一棵树的后序遍历，重构并返回二叉树。

 如果存在多个答案，您可以返回其中 任何 一个。
 因为前序遍历的第二个数字，可能是左子树的根节点也可能是右子树的根节点。
 */
func constructFromPrePost(_ preorder: [Int], _ postorder: [Int]) -> TreeNode? {
    return buildPrePost(preorder, 0, preorder.count-1, postorder, 0, postorder.count-1)
}
func buildPrePost(_ preorder: [Int], _ preS: Int, _ preE: Int,
                  _ postorder: [Int], _ postS: Int, _ postE: Int) -> TreeNode?  {
    if preS > preE { return nil }
    if preS == preE { return TreeNode(preorder[preS]) }
    
    let rootVal = preorder[preS]
    // 左子树根节点
    let leftRootVal = preorder[preS+1]
    // leftRootVal 在后序遍历数组中的索引找到左子树根节点
    var index = 0
    for i in postS...postE {
        if leftRootVal == postorder[i] {
            index = i
            break
        }
    }
    // 左子树的元素个数
    let leftSize = index - postS + 1
    let root = TreeNode(rootVal)
    // 递归构造左右子树
    // 根据左子树的根节点索引和元素个数推导左右子树的索引边界
    root.left = buildPrePost(preorder, preS+1, preS+leftSize, postorder, postS, index)
    root.right = buildPrePost(preorder, preS+1+leftSize, preE, postorder, index+1, postE-1)
    return root
}


/**
 116. 填充每个节点的下一个右侧节点指针
 给定一个 完美二叉树 ，其所有叶子节点都在同一层，每个父节点都有两个子节点。二叉树定义如下：
 struct Node {
   int val;
   Node *left;
   Node *right;
   Node *next;
 }
 填充它的每个 next 指针，让这个指针指向其下一个右侧节点。如果找不到下一个右侧节点，则将 next 指针设置为 NULL。

 初始状态下，所有 next 指针都被设置为 NULL。
 */
func connect(_ root: TreeNode?) -> TreeNode? {
    if root == nil { return nil }
    connectRight(root?.left, node2: root?.right)
    return root
}
func connectRight(_ node1: TreeNode?, node2: TreeNode?) {
    if node1 == nil || node2 == nil { return }
    // 前序位置填充
    node1?.next = node2
    
    // 同一个父节点
    connectRight(node1?.left, node2: node1?.right)
    connectRight(node2?.left, node2: node2?.right)
    // 链接跨越父节点的两个节点
    connectRight(node1?.right, node2: node2?.left)
}

/**
 114. 二叉树展开为链表
 给你二叉树的根结点 root ，请你将它展开为一个单链表：

 展开后的单链表应该同样使用 TreeNode ，其中 right 子指针指向链表中下一个结点，而左子指针始终为 null 。
 展开后的单链表应该与二叉树 先序遍历 顺序相同。
 */
func flatten(_ root: TreeNode?) {
    if root == nil { return }
    flatten(root?.left)
    flatten(root?.right)
    
    // 后续遍历位置
    // 1、左右子树已经被拉平成一条链表
    let left = root?.left
    let right = root?.right
    
    // 2、将左子树作为右子树
    root?.left = nil
    root?.right = left
    
    // 3、将原先的右子树接到当前右子树的末端
    var p = root
    while p?.right != nil {
        p = p?.right
    }
    p?.right = right
}

/**
 654. 最大二叉树
 给定一个不重复的整数数组 nums 。 最大二叉树 可以用下面的算法从 nums 递归地构建:

 创建一个根节点，其值为 nums 中的最大值。
 递归地在最大值 左边 的 子数组前缀上 构建左子树。
 递归地在最大值 右边 的 子数组后缀上 构建右子树。
 返回 nums 构建的 最大二叉树 。
 */
func constructMaximumBinaryTree(_ nums: [Int]) -> TreeNode? {
    if nums.count == 0 { return nil }
    return findMax(nums, 0, nums.count-1)
}
func findMax(_ nums: [Int], _ left: Int, _ right: Int) -> TreeNode? {
    if right < left { return nil }
    var max = nums[left], maxIndex = left
    for i in left...right {
        if nums[i] > max {
            max = nums[i]
            maxIndex = left
        }
    }
    let root = TreeNode(max)
    root.left = findMax(nums, left, maxIndex - 1)
    root.right = findMax(nums, maxIndex + 1, right)
    return root
}

/**
 652. 寻找重复的子树
 
 给定一棵二叉树 root，返回所有重复的子树。
 对于同一类的重复子树，你只需要返回其中任意一棵的根结点即可。
 如果两棵树具有相同的结构和相同的结点值，则它们是重复的。
 */
func findDuplicateSubtrees(_ root: TreeNode?) -> [TreeNode?] {
    // 记录所有子树以及出现的次数
    var memo = [String: Int]()
    // 记录重复子树
    var ans = [TreeNode?]()
    
    func traverse(_ root: TreeNode?) -> String {
        // 对于空节点，可以用一个特殊字符表示
        if root == nil { return "#" }
        // 将左右子树序列化成字符串
        let left = traverse(root?.left)
        let right = traverse(root?.right)
        /* 后序遍历代码位置 */
        // 左右子树加上自己，就是以自己为根的二叉树序列化结果
        let subTree = left + "," + right + "," + "\(root!.val)"
        //
        let count = memo[subTree, default: 0]
        if count == 1 {
            // 多次重复也只会被加入结果集一次
            ans.append(root)
        }
        memo[subTree] = count + 1
        return subTree
    }
    
    _ = traverse(root)
    return ans
}
 
/**
 297. 二叉树的序列化与反序列化
 
 */
var tree = ""
func serialize(_ root: TreeNode?) -> String  {
    traverse1(root)
    return tree
}

func traverse1(_ root: TreeNode?){
    if root == nil {
        tree = tree + "#" + ","
        return
    }
    tree = tree + "\(root!.val)" + ","
    traverse1(root?.left)
    traverse1(root?.right)
    
}
/** 层序遍历*/
func traverse2(_ root: TreeNode?) -> String {
    if root == nil { return "" }
    var queue = [root], s = ""
    
    while !queue.isEmpty {
        let node = queue.removeFirst()
        if node == nil {
            s = s + "#" + ","
            continue
        }
        s = s + "\(node!.val)" + ","
        queue.append(node?.left)
        queue.append(node?.right)
    }
    return s
}

func deserialize(_ data: String) -> TreeNode? {
    var nodes = data.split(separator: ",").map { s in
        String(s)
    }
    return deserialize1(&nodes)
}
func deserialize1(_ nodes: inout [String]) -> TreeNode? {
    if nodes.isEmpty { return nil }
    
    let node = nodes.removeFirst()
    if node == "#" { return nil }
    let root = TreeNode(Int(node)!)
    root.left = deserialize1(&nodes)
    root.right = deserialize1(&nodes)
    
    return root
}

/**
 236. 二叉树的最近公共祖先
 给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。
 */
func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
    if root == nil { return nil }
    if p == nil { return q }
    if q == nil { return p }
    // 在二叉树中找到了对应节点
    if root == p || root == q { return root }
    
    let left = lowestCommonAncestor(root?.left, p, q)
    let right = lowestCommonAncestor(root?.right, p, q)
    
    // 1.如果p和q都在以root为根的树中，那么left和right一定分别是p和q
    if left != nil && right != nil { return root }
    
    // 2.如果p和q都不在以root为根的树中，直接返回null
    if left == nil && right == nil { return nil }
    
    // 3.如果p和q只有一个存在于root为根的树中，函数返回该节点。
    return left == nil ? right : left
}

