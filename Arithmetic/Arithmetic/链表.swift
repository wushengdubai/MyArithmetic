//
//  链表.swift
//  算法
//
//  Created by 张清泉 on 2022/1/19.
//

import Foundation

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
    
    public init(_ vals: [Int]) {
        self.val = vals[0]
        var head: ListNode? = self
        for i in 1..<vals.count {
            head?.next = ListNode(vals[i])
            head = head?.next
        }
    }
}

extension ListNode: Comparable {
    public static func < (lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs.val < rhs.val
    }

    public static func == (lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs.val == rhs.val
    }
}

/**
 2。两个链表相加
 给你两个 非空 的链表，表示两个非负的整数。它们每位数字都是按照 逆序 的方式存储的，并且每个节点只能存储 一位 数字。
 请你将两个数相加，并以相同形式返回一个表示和的链表。
 你可以假设除了数字 0 之外，这两个数都不会以 0 开头。、
 
 例子：
 l1 = [2, 4, 3]  l2 = [5, 6, 4]
 l1 + l2 = 342 + 465 = 807
 */
func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    if l1 == nil && l2 == nil { return nil }
    //  循环相加
    let dummy: ListNode = ListNode()
    var cur: ListNode? = dummy
    var l1 = l1, l2 = l2
    // 进位值
    var carry: Int = 0
    
    while l1 != nil || l2 != nil {
        let x = l1?.val ?? 0
        let y = l2?.val ?? 0
        var sum = x + y + carry
        
        carry = sum % 10
        sum = sum / 10
        
        // 移动cur指针
        cur?.next = ListNode(sum)
        cur = cur?.next
        
        // 移动l1  l2指针
        l1 = l1?.next
        l2 = l2?.next
    }
    
    if carry == 1 { cur?.next = ListNode(1) }
    
    return dummy.next
}

/**
 21. 合并两个有序链表
 将两个升序链表合并为一个新的 升序 链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。
 */
func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    let dump = ListNode()
    var cur1 = l1, cur2 = l2, cur = dump
    while cur1 != nil && cur2 != nil {
        if cur1!.val < cur2!.val {
            cur.next = cur1
            cur1 = cur1?.next
        } else {
            cur.next = cur2
            cur2 = cur2?.next
        }
        cur = cur.next!
    }
    cur.next = cur1 == nil ? cur2 : cur1
    return dump.next
    
    // 递归方式
//    if l1 == nil { return l2 }
//    if l2 == nil { return l1 }
//    
//    if l1!.val < l2!.val {
//        l1?.next = mergeTwoLists(l1?.next, l2)
//        return l1
//    } else {
//        l2?.next = mergeTwoLists(l1, l2?.next)
//        return l2
//    }
}

/**
 23. 合并K个升序链表
 给你一个链表数组，每个链表都已经按升序排列。
 请你将所有链表合并到一个升序链表中，返回合并后的链表。
 */
func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
    if lists.isEmpty { return nil }
    
    return merge(lists, 0, lists.count - 1)
}
// 递归法合并
func merge(_ lists: [ListNode?], _ l: Int, _ r: Int) -> ListNode? {
    // 如果左右位置相等，则直接返回，不需要合并，否则都是合并2个链表
    if l == r { return lists[l] }
    let mid = l + (r - l)/2
    let l1 = merge(lists, 0, mid)
    let l2 = merge(lists, mid + 1, r)
    return mergeTwoLists(l1, l2)
}
// 遍历法，合并K个升序链表
func mergeKLists1(_ lists: [ListNode?]) -> ListNode? {
    let dummy = ListNode()
    var cur = dummy
    var lists = lists
    while (true) {
        var minIndex = -1
        for i in 0..<lists.count {
            let node = lists[i]
            if node == nil {
                continue
            }
            
            if minIndex == -1 || lists[minIndex]!.val > node!.val {
                minIndex = i
            }
        }
        if minIndex == -1 { break } // 都是空链表
        cur.next = lists[minIndex]
        cur = cur.next!
        lists[minIndex] = lists[minIndex]?.next
    }
    return dummy.next
}

/**
 328.奇偶链表
 给定单链表的头节点 head ，将所有索引为奇数的节点和索引为偶数的节点分别组合在一起，然后返回重新排序的列表。
 第一个节点的索引被认为是 奇数 ， 第二个节点的索引为 偶数 ，以此类推。
 请注意，偶数组和奇数组内部的相对顺序应该与输入时保持一致。
 你必须在 O(1) 的额外空间复杂度和 O(n) 的时间复杂度下解决这个问题。
 */
func oddEvenList(_ head: ListNode?) -> ListNode? {
    if head == nil { return head }
    // odd 奇链表 even 偶链表
    var odd = head, even = head?.next
    let evenH = even // 记录偶链表头结点
    
    while even != nil && even?.next != nil {
        odd?.next = even?.next
        odd = even?.next
        even?.next = odd?.next
        even = odd?.next
    }
    odd?.next = evenH // 链接奇偶链表
    return head
}

/**
 链表翻转
 */
func reverse(_ head: ListNode?) -> ListNode? {
    if head?.next == nil {
        return head
    }
    let node = reverse(head?.next)
    // head为3，node为4
    head?.next?.next = head // 4 -> 3    3 -> 2    2 -> 1
    head?.next = nil        // 3 -> nil  2 -> nil  1 -> nil
    return node
}
func reverse1(_ head: ListNode?) -> ListNode? {
    if head?.next == nil {
        return head
    }
    var cur = head, prev: ListNode? = nil
    while cur != nil {
        let tmp = cur?.next
        cur?.next = prev
        prev = cur
        cur = tmp
    }
    return prev
}

/**
 92. 反转部分节点的链表
 给你单链表的头指针 head 和两个整数 left 和 right ，其中 left <= right 。请你反转从位置 left 到位置 right 的链表节点，返回 反转后的链表
 */
func reverseBetween(_ head: ListNode?, _ left: Int, _ right: Int) -> ListNode? {
    if left == 1 {
        // 反转前left个节点
        return reverseN(head, right)
    }
    // 前进到反转的起点触发 base case
    head?.next = reverseBetween(head?.next, left-1, right-1)
    return head
}

var successor: ListNode? = nil // 后继节点：记录在反转前N个节点时，第N+1个节点
// 反转以Head为起始的N个节点，返回新的头结点
func reverseN(_ head: ListNode?, _ n: Int) -> ListNode? {
    if n == 1 {
        // 记录后继节点
        successor = head?.next
        return head
    }
    // 以 head.next 为起点，需要反转前 n - 1 个节点
    let last = reverseN(head?.next, n-1)
    head?.next?.next = head
    // 让反转之后的 head 节点和后继节点连起来
    head?.next = successor
    return last
}

/**
 25. K 个一组翻转链表
 
 给你一个链表，每 k 个节点一组进行翻转，请你返回翻转后的链表。
 k 是一个正整数，它的值小于或等于链表的长度。
 如果节点总数不是 k 的整数倍，那么请将最后剩余的节点保持原有顺序。

 进阶：
 你可以设计一个只使用常数额外空间的算法来解决此问题吗？
 你不能只是单纯的改变节点内部的值，而是需要实际进行节点交换。
 */
func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
    if head == nil { return head }
    // 区间 [a, b) 包含 k 个待反转元素
    var a = head, b = head, i = 0
    while i < k {
        i += 1
        // 不足 k 个，不需要反转，base case
        if b == nil { return head }
        b = b?.next
    }
    
    // 反转前 k 个元素
    let newHead = reverseAtoB(a, b)
    // 递归反转后续链表并连接起来
    a?.next = reverseKGroup(b, k)
    return newHead
}
// 反转链表 [A, B) 区间节点，注意是左闭右开
func reverseAtoB(_ a: ListNode?, _ b: ListNode?) -> ListNode? {
    var prev: ListNode? = nil, cur = a, nxt = a
    while cur != b {
        nxt = cur?.next
        cur?.next = prev
        prev = cur
        cur = nxt
    }
    // 返回反转后的头结点
    return prev
}

/**
 234. 判断是否是回文链表
 */
var cur: ListNode?
func isPalindromeList(_ head: ListNode?) -> Bool {
    cur = head
    return reverseList(head)
}
func reverseList(_ head: ListNode?) -> Bool {
    if head == nil { return true }
    let res = reverseList(head?.next)
    // 递归完后，此时head指向链表尾部
    if head?.val != cur?.val { return false }
    cur = cur?.next
    return res
}


/**
 430、扁平化多级双向链表
 
 你会得到一个双链表，其中包含的节点有一个下一个指针、一个前一个指针和一个额外的 子指针 。这个子指针可能指向一个单独的双向链表，也包含这些特殊的节点。这些子列表可以有一个或多个自己的子列表，以此类推，以生成如下面的示例所示的 多层数据结构 。

 给定链表的头节点 head ，将链表 扁平化 ，以便所有节点都出现在单层双链表中。让 curr 是一个带有子列表的节点。子列表中的节点应该出现在扁平化列表中的 curr 之后 和 curr.next 之前 。

 返回 扁平列表的 head 。列表中的节点必须将其 所有 子指针设置为 null
 */
func flatten(_ head: Node?) -> Node? {
    // 记录分支尾结点
    var trail: Node?
    func flat(_ head: Node?) {
        var cur = head
        if head?.child != nil {
            let next = cur?.next
            // 把分支接入主干
            cur?.next = cur?.child
            // 获取分支尾节点
            flat(cur?.child)
            // 删除分支
            cur?.child = nil
            // 接入主干下一个节点
            trail?.next = next
            next?.prev = trail
            // 把指针移到分支尾结点
            cur = trail
        }
        if head?.next == nil {
            trail = head
            return
        }
        // 后移指针
        cur = cur?.next
        flat(cur)
    }
    
    flat(head)
    return head
}
