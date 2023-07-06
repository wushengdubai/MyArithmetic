//
//  Numbers.swift
//  Algorithm
//
//  Created by 张清泉 on 2023/7/6.
//  Copyright © 2023 张清泉. All rights reserved.
//

import Foundation

class Numbers {
    /// 371.两整数之和，不使用
    func getSum(_ a: Int, _ b: Int) -> Int {
        var b = b, a = a
        while b != 0 {
            let tmp = a ^ b
            b = (a & b) << 1
            a = tmp
        }
        return a
    }

    //print("getSum：\(getSum(3, 7))")

    /// 191. 二进制数中1的个数
    func hammingWeight(_ n: Int) -> Int {
        var n = n, res = 0
        while n > 0 {
            n &= (n - 1)
            res += 1
        }
        return res
    }
}
