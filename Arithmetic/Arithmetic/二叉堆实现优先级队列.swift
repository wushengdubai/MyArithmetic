//
//  二叉堆实现优先级队列.swift
//  算法
//
//  Created by 张清泉 on 2022/1/23.
//

import Foundation

/** 学习链接：https://labuladong.gitee.io/algo/2/20/52/ */
/**
 概念：
 二叉堆是一种特殊的堆，二叉堆是完全二元树（二叉树）或者是近似完全二元树（二叉树）。二叉堆有两种：最大堆和最小堆。最大堆：父结点的键值总是大于或等于任何一个子节点的键值；最小堆：父结点的键值总是小于或等于任何一个子节点的键值。
 
 二叉堆一般用数组来表示。如果根节点在数组中的位置是1，第n个位置的子节点分别在2n和 2n+1。因此，第1个位置的子节点在2和3，第2个位置的子节点在4和5。以此类推。这种基于1的数组存储方式便于寻找父节点和子节点。
 */

/** 优先级队列 */
class PriorityQueue<Key: Comparable> {
    // 存储元素的数组
    private var pq: [Key];
    // 当前 Priority Queue 中的元素个数
    private var N = 0;
    
    init(cap: Int) {
        // 索引 0 不用，所以多分配一个空间
        pq = [Key]()
        pq.reserveCapacity(cap+1)
        pq.append(0 as! Key)
    }

    /* 返回当前队列中最大元素 */
    public func max() -> Key {
        return pq[1];
    }

    /* 插入元素 e */
    public func insert(e: Key) {
        N += 1
        // 先把元素查到末尾
        pq.append(e)
        // 然后上浮到正确位置
        swim(N)
    }

    /* 删除并返回当前队列中最大元素 */
    public func delMax() -> Key {
        // 最大堆的堆顶就是最大元素
        let max = pq[1]
        // 把这个最大元素换到最后，删除之
        exch(1, N);
        pq.removeLast();
        N -= 1
        // 让 pq[1] 下沉到正确位置
        sink(1)
        return max
    }

    /* 上浮第 k 个元素，以维护最大堆性质 */
    func swim(_ k: Int) {
        var k = k
        // 如果浮到堆顶，就不能再上浮了
        // 如果父节点比k节点小，则上浮
        while k > 1 && less(parent(k), k) {
            let parentK = parent(k)
            // 将 k 换上去
            exch(k, parentK)
            k = parentK
        }
    }

    /* 下沉第 k 个元素，以维护最大堆性质 */
    func sink(_ k: Int) {
        var k = k
        // 如果沉到堆底，就沉不下去了
        while left(k) <= N {
            // 先假设左边节点较大
            var order = left(k)
            // 如果右边节点存在，比一下大小
            let rightK = right(k)
            if rightK <= N && less(order, rightK) {
                order = rightK
            }
            // 结点 k 比俩孩子都大，就不必下沉了
            if less(order, k) { continue }
            // 否则，不符合最大堆的结构，下沉 k 结点
            exch(k, order)
            k = order
        }
    }

    /* 交换数组的两个元素 */
    func exch(_ i: Int, _ j: Int) {
        (pq[i], pq[j]) = (pq[j], pq[i])
    }

    /* pq[i] 是否比 pq[j] 小？ */
    func less(_ i: Int, _ j: Int) -> Bool {
        return pq[i] < (pq[j]);
    }

    // 父节点的索引
    public func parent(_ root: Int) -> Int {
        return root / 2;
    }
    // 左孩子的索引
    public func left(_ root: Int) -> Int {
        return root * 2;
    }
    // 右孩子的索引
    public func right(_ root: Int) -> Int {
        return root * 2 + 1;
    }
}
