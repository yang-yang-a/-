package Task3_Core_algorithm_of_syntax_analysis
import std.collection.*

//------------------------任务3.2: ⽂法左公共因⼦提取⽅法及实现------------------------
//Tire树（用来查找字符串前缀）
class Trienode {
    var childmap:  HashMap<String, Trienode>
    var childnum: Int64 //有几个子节点     
    var isend: Bool         

    public init() {
        childmap = HashMap()
        childnum = 0
        isend = false
    }
}

func Has_prefix(map: HashMap<String, HashSet<String>>): Bool {
    var arr = ArrayList<String>()
    for ((k, v) in map) {
        for (rule in v) {
            if (arr.contains(rule[0..1])) {
                return true
            }
            else {
                arr.append(rule[0..1])
            }
        }
        arr.clear()
    }
    return false
}

func Has_prefix(v: HashSet<String>): Bool {
    var arr = ArrayList<String>()
    for (rule in v) {
        if (arr.contains(rule[0..1])) {
            return true
        }
        else {
            arr.append(rule[0..1])
        }
    }
    return false
}

func Build_trie(word: String, root: Trienode) {
    var p = root
    for (w in word) {
        //检查根节点是否有指向该字符的子节点
        //没有，则创建，移动到该节点
        var ch = String(Rune(w))
        if (!p.childmap.contains(ch)) {
            p.childmap[ch] = Trienode()
            p.childnum++
            p = p.childmap[ch]

        }
        //有，移动到该节点
        else {
            p = p.childmap[ch]
        }
    }
    p.isend = true
}

func Remove_left() {
    var CRmap = HashMap<String, HashSet<String>>()
    //临时
    var CRmap2 = HashMap<String, HashSet<String>>()
    CRmap.putAll(Rmap)
    //处理嵌套公共前缀
    while(Has_prefix(CRmap)) {
        for ((k, v) in CRmap) { 
            //如果有前缀
            if (Has_prefix(v)) {
                //对每一条产生式创建一个Trie树，得到前缀
                var root: Trienode = Trienode()
                for (rule in v) {
                    Build_trie(rule, root)
                }

                //得到公共前缀数组
                var prefixarr = ArrayList<String>()
                var str: String = ""
                for (ch1 in root.childmap.keys()) {
                    var p = root.childmap[ch1]
                    str += ch1
                    while (p.childnum == 1) {
                        if (p.isend) {
                            break
                        }
                        var a = p.childmap.keys()
                        var b = a.toArray()
                        str += b[0] 
                        p = p.childmap[b[0]]
                    }
                    if (p.childnum < 1) {
                        str = ""
                    }
                    else {
                        prefixarr.append(str)
                        str = ""
                    }
                }
                // println("左公共因子为${prefixarr}")

                //得到消去公共前缀的文法
                CRmap2[k] = HashSet<String>()
                //分配空间
                for (i in 0..prefixarr.size) {
                    CRmap2["${k}"+"'"*(i+1)] = HashSet<String>()
                }            
                for (rule in v) {
                    var cp: Bool = false //判断是否有前缀
                    for (i in 0..prefixarr.size) {
                        //更新k，引入k'
                        var index = prefixarr[i].size
                        CRmap2[k].put("${prefixarr[i]}${k}"+"'"*(i+1))
                        //匹配前缀，更新k'，加入后缀
                        if (rule.startsWith(prefixarr[i])) {
                            cp = true
                            if (rule[index..] == "") {
                                CRmap2["${k}"+"'"*(i+1)].put("#")
                            }
                            else {
                                CRmap2["${k}"+"'"*(i+1)].put(rule[index..])
                            }
                        }
                    }
                    if (!cp) {
                        CRmap2[k].put(rule)
                    } 
                }
                
            }
            else {
                CRmap2.put(k, v)
            }
        }
        CRmap.clear()
        CRmap.putAll(CRmap2)
        CRmap2.clear()
        println("\n提取左公共因子后：")
        Print_Rmap(CRmap)
    }
}
