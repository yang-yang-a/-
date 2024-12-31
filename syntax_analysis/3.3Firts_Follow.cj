package Task3_Core_algorithm_of_syntax_analysis
import std.collection.*

var FIRST = HashMap<String, HashSet<String>>()
var FOLLOW = HashMap<String, HashSet<String>>()
//终结符号集合
var Vtset = HashSet<String>()

func init_FIRST() {
    //将每个终结符号a加入FIRST(a)
    for ((k, v) in Rmap) {
        for (rule in v) {
            FIRST[rule] = HashSet<String>()
            var i: Int64 = 0
            while (i < rule.size) {
                var ch = rule[i..i+1]
                //处理id
                if (i < rule.size-2 && rule[i+1..i+2] == "`") {
                    ch = rule[i..i+1] + rule[i+2..i+3]
                    i = i + 3
                }
                if (!Vnarr.contains(ch) && ch != "'") {
                    FIRST.put(ch, HashSet(ch))
                    Vtset.put(ch)
                    i++
                }
                else {i++}
            }
        }
    }
    for (Vn in Vnarr) {
        FIRST[Vn] = HashSet<String>()
        //如果可以推出ε，把ε加入FIRST
        if (Rmap[Vn].contains("#")) {
            FIRST[Vn].put("#")
        }
    }
    // println("非终结符号集合为${Vnarr}")
    // println("终结符号集合为${Vtset}")
}

//求产生式右部的FIRST集
// func Get_firstright(rule: String): HashSet<String> {
//     var i: Int64 = 0
//     while (i < rule.size) {
//         var ch = ""
//         //处理id
//         if (i < rule.size-2 && rule[i+1..i+2] == "`") {
//             ch = rule[i..i+1] + rule[i+2..i+3]
//             i = i + 3
//         }
//         else {
//             ch = rule[i..i+1]
//             i++
//         }
//         //如果产生式为A -> aα则将a加⼊FIRST(A)是否可以合并
//         if (Vtset.contains(ch)) {
//             FIRST[rule].put(ch)
//             break
//         }
//         //如果是非终结符号
//         else {
//             //能推出ε
//             var first = Get_firstVn(ch)
//             if (first.contains("#")) {
//                 if (i == rule.size) {
//                     FIRST[rule].putAll(first)
//                 }
//                 else {
//                     first.remove("#")
//                     FIRST[rule].putAll(first)
//                 }
//             }
//             //不能推出，退出for循环
//             else {
//                 FIRST[rule].putAll(first)
//                 break
//             }
//         }
//     }
//     return FIRST[rule]
// }

func Get_firstVn(Vn: String): HashSet<String> {
    for (rule in Rmap[Vn]) {
        var i: Int64 = 0
        while (i < rule.size) {
            var ch = ""
            //处理id
            if (i < rule.size-2 && rule[i+1..i+2] == "`") {
                ch = rule[i..i+1] + rule[i+2..i+3]
                i = i + 2
            }
            else {
                ch = rule[i..i+1]
            }
            //如果产生式为A -> aα则将a加⼊FIRST(A)是否可以合并
            if (Vtset.contains(ch)) {
                FIRST[Vn].put(ch)
                break
            }
            //如果是非终结符号
            else {
                var first = Get_firstVn(ch)
                //如果能推出ε
                if (first.contains("#")) {
                    if (i == rule.size-1) {
                        FIRST[Vn].putAll(first)
                    }
                    else {
                        first.remove("#")
                        FIRST[Vn].putAll(first)
                    }
                }
                //不能推出，退出for循环
                else {
                    FIRST[Vn].putAll(first)
                    break
                }
            }
            i++
        }
    }
    return FIRST[Vn]
}

func Get_FIRST() {
    init_FIRST()
    var set = HashSet<String>()
    println("\nFIRST集：")
    //对于每个非终结符A
    for (Vn in Vnarr) {
        Get_firstVn(Vn)
        for (rule in FIRST[Vn]) {
            var rule2 = rule
            rule2 = rule2.replace("#", "ε")
            set.put(rule2)
        }
        println("FIRST(${Vn}) = ${set}")
        set.clear()
        //得到产生式右部的FIRST集
        // for (rule in Rmap[Vn]) {
        //     Get_firstright(rule)
        //     // println("FIRST(${rule}) = ${FIRST[rule]}")
        // }
    }
}



func init_FOLLOW() {
    //将$加入FOLLOW(开始符号)
    FOLLOW.put(Vnarr[0], HashSet("$"))
    for (i in 1..Vnarr.size) {
        FOLLOW[Vnarr[i]] = HashSet<String>()
    }
}

func Get_FOLLOW() {
    init_FOLLOW()
    var changed: Bool = true
    while (changed) {
        changed = false
        for ((k, v) in Rmap) {
            for (rule in v) {
                var i: Int64 = 0
                while (i < rule.size) {
                    var ch = rule[i..i+1]
                    while (i < rule.size-1 && rule[i+1..i+2] == "'") {
                        ch += "'"
                        i++
                    }
                    //终结符号则跳过
                    if (!Vnarr.contains(ch)) {
                        i++
                        continue
                    }
                    //是非终结符号
                    else {
                        // println("ch=${ch}")
                        var followch = FOLLOW[ch].clone()
                        // println("followch=${followch}")
                        //如果是最后一个字符
                        if (i == rule.size-1) {
                            // var follow = FOLLOW[k]
                            FOLLOW[ch].putAll(FOLLOW[k])
                            
                        }
                        else {
                            //求下一个字符
                            var j = i+1
                            var nextch = rule[j..j+1]
                            while (j < rule.size-1 && rule[j+1..j+2] == "'") {
                                nextch += "'"
                                j++
                            }
                            //处理id
                            while (j < rule.size-2 && rule[j+1..j+2] == "`") {
                                nextch += rule[j+2..j+3]
                                j = j + 2
                            }
                            // println("nextch=${nextch}")
                            var first = FIRST[nextch].clone()
                            first.remove("#")
                            FOLLOW[ch].putAll(first)
                            //如果下一个字符可以推出ε
                            if (FIRST[nextch].contains("#")) {
                                FOLLOW[ch].putAll(FOLLOW[k])
                            }
                        }
                        // println(FOLLOW[ch])
                        // println(followch)
                        if (FOLLOW[ch] != followch) {
                            changed = true
                            // println("break")
                            break
                        }
                    }
                    i++
                }
            }
        }
    }
    //打印FOLLOW集
    println("\nFOLLOW集：")
    for (k in FOLLOW.keys()) {
        println("FOLLOW(${k}) = ${FOLLOW[k]}")
    }
}

