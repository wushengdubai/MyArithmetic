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
    
    
    /**
     1716、Hercy 想要为购买第一辆车存钱。他 每天 都往力扣银行里存钱。

     最开始，他在周一的时候存入 1 块钱。从周二到周日，他每天都比前一天多存入 1 块钱。在接下来每一个周一，他都会比 前一个周一 多存入 1 块钱。

     给你 n ，请你返回在第 n 天结束的时候他在力扣银行总共存了多少块钱
     */
    func totalMoney(_ n: Int) -> Int {
        let week = n / 7 + 1 // 实际周数
        let lastDay = n % 7 // 剩余的天数
        print(week, lastDay)
        var money = 0 // 总存金额
        if week > 1 {
            for i in 1..<week {
                money += (i + i + 6) * 7 / 2
                print("money", money)
            }
        }
        var i = 0
        while i < lastDay {
            money += week + i
            i += 1
        }
        return money
    }
    
    // 7. 整数反转
    func reverse(_ x: Int) -> Int {
        let flag = x >= 0 ? 1 : -1
        var x = x * flag
        var res = 0
        while x != 0 {
            res = res * 10 + x % 10
            if res > Int32.max || res < Int32.min { return 0 }
            x = x/10
        }
        return res * flag
    }
    
    // 9。是否是回文数字
    func isPalindrome(_ x: Int) -> Bool {
        if x < 0 { return false }
        
        var res = 0, l = x
        while l != 0 {
            res = res * 10 + l % 10
            l = l/10
        }
        
        return res == x
    }
}
