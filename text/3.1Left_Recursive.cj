package Task3_Core_algorithm_of_syntax_analysis
import std.collection.*

//Vt终结符号，Vn非终结符号
//------------------------任务3.1 上下⽂⽆关⽂法左递归消去算法的实现------------------------

//文法的数据结构：HashMap，键存产生式左部，值是哈希集合，存产生式右部
var Rmap = HashMap<String, HashSet<String>>()
//存储非终结符号集合
var Vnarr = ArrayList<String>()

//判断是否存在直接左递归，存在返回true
func Is_DLeft(Vn: String, P: HashSet<String>): Bool {
    var count: Int64 = 0
    for (rule in P) {
        if (String(Rune(rule[0])) == Vn) {
            count++
        }
    }
    //如果还存在不以Vn开头的产生式则是直接左递归
    if (count > 0 && P.size > count) {return true}
    else {return false}
}

//判断是否有间接左递归
func Is_IDLeft(): Bool {
    for (i in 0..Vnarr.size-1) {
        for (j in i+1..Vnarr.size) {
            for (rule in Rmap[Vnarr[j]]) {
                if (rule[0..1] == Vnarr[i]) {
                    return true
                }
            }
        }
    }
    return false
}

//识别文法存入Rmap，得到非终结符号集合Vnarr
func Get_Rmap(s: String) {
    clear()
    //替换ε为e，ε做字符串操作会报错
    var str = s.replace("ε","#")
    //对非终结符集以出现顺序进行排序（识别文法）
    //去掉空格
    var grammar_rules: String = ""
    for (i in str) {
        if (Rune(i) != r" ") {
            grammar_rules += String(Rune(i))
        }
    }
    for (rule in grammar_rules.split("\n")) {
        var left = rule.split("->")[0]
        var right= rule.split("->")[1]
        //如果该非终结符号没有出现过则创建哈希
        if (Rmap.contains(left)) {}
        else {
            Rmap[left] = HashSet<String>()
            Vnarr.append(left)
        }
        for (r in right.split("|")) {
            Rmap[left].put(r)
        }
    }
}

func Print_Rmap(Rmap: HashMap<String, HashSet<String>>) {
    for ((k,v) in Rmap) {
        var count: Int64 = 0
        print("${k} -> ")
        for (r in v) {
            var rule = r.replace("#","ε")
            print(rule)
            count++
            if (count < v.size) {
                print(" | ")
            }
            else {
                println()
            }
        }
    }
}

func clear() {
    Rmap.clear()
    Vnarr.clear()
    FIRST.clear()
    FOLLOW.clear()
}

//消去左递归算法
func Get_Left_Recursive() {
    //存储经过算法后的文法
    var LRmap = HashMap<String, HashSet<String>>()
    //存储临时的文法
    var LRmap2 = HashMap<String, HashSet<String>>()
    LRmap.putAll(Rmap)
    //如果有间接左递归，则转换为直接左递归
    if (Is_IDLeft()) {
        for (i in 0..Vnarr.size-1) {
            for (j in i+1..Vnarr.size) {
                for (rule in LRmap[Vnarr[i]]) {
                    if (String(Rune(rule[0])) == Vnarr[j]) {
                        LRmap[Vnarr[i]].remove(rule)
                        for (rule2 in LRmap[Vnarr[j]]) {
                            //用间接递归的产生式右部替代
                            LRmap[Vnarr[i]].put("${rule2}${rule[1..]}")
                        }
                        break
                    }
                }
            }
        }
        println("\n消除间接左递归后：")
        Print_Rmap(LRmap)
    }
    else {
        println("\n没有间接左递归")
    }
    var flag: Bool = false
    //识别直接左递归
    for ((k, v) in LRmap) {
        //有直接左递归
        if (Is_DLeft(k, v)) {
            flag = true
            LRmap2[k] = HashSet<String>()
            LRmap2["${k}'"] = HashSet<String>()
            for (rule in v) {
                //如果产生式右部开头是产生式左部
                if (String(Rune(rule[0])) == k) {
                    LRmap2["${k}'"].put("${rule[1..]}${k}'")
                }
                //β，不以k开头
                else {
                    LRmap2[k].put("${rule}${k}'")
                }
            }
            LRmap2["${k}'"].put("#")
            Vnarr.append("${k}'")
        }
        else {
            LRmap2.put(k, v)
        }
    }
    if (flag) {
        //将LRmap2的值放入LRmap
        LRmap.clear()
        LRmap.putAll(LRmap2)
        LRmap2.clear
        println("\n消除直接左递归后：")
        Print_Rmap(LRmap)
    }
    else {
        println("\n没有直接左递归")
    }

    //化简文法
    //存储可以由开始符号推出的非终结符号
    var Vnarr2 = ArrayList<String>(Vnarr[0])
    //用数组模拟简单队列
    var Vnqueue = ArrayList<String>(Vnarr[0])
    while(Vnqueue.size > 0) {
        var Vn = Vnqueue.remove(0)
        // println("Vn${Vn}")
        // println("size=${Vnqueue.size}")
        for (rule in LRmap[Vn]) {
            // println("rule=${rule}")
            for (i in 0..=rule.size-1) {
                var ch: String
                if (i < rule.size-1 && rule[i+1..i+2] == "'") {
                    ch = rule[i..i+1]+"'"
                }
                else {
                    ch = rule[i..i+1]
                }
                //如果是非终结符号
                if (Vnarr.contains(ch) && !Vnarr2.contains(ch)) {
                    Vnarr2.append(ch)
                    Vnqueue.append(ch)
                    // println("Vnqueue${Vnqueue}")
                }
            }
        }
    }
    // println(Vnarr2)
    //如果没有化简
    if (Vnarr2.size == Vnarr.size) {
        //do nothing
    }
    else {
        for (Vn in Vnarr) {
            if (!Vnarr2.contains(Vn)) {
                LRmap.remove(Vn)
            }
        }
        println("\n化简后：")
        Print_Rmap(LRmap)
    }
}






