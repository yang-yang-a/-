package RegExp_NFA_DFA
import std.collection.*
import std.fs.*


struct FAnode {
    var node = Array(27, {_ => ArrayList<Int64>()})
}

//泛型栈，用于中缀转后缀存储字符；用于Thompson存储状态节点
struct Stack<T> {
    var elements = ArrayList<T>()

    //入栈
    func push(e: T) {
        elements.append(e)
    }
    //出栈
    func pop(): T {
        // if (elements.size == 0){
        //     return None
        // }
        return elements.remove(elements.size - 1)
    }
    //判断是否为空
    func isEmpty(): Bool {
        if(elements.size == 0){
            return true
        }
        else{
            return false
        }
    }
    //查看栈顶元素
    func top(): T {
        // if(elements.size == 0) {
        //     return None
        // }
        return elements[elements.size - 1]
    }
}

var nfa = ArrayList<FAnode>()
var len: Int64 = 0
var s : Stack<Int64> = Stack()

var dfa = ArrayList<FAnode>()
//DFA状态子集总个数
var p: Int64 = 0
var Dstates = ArrayList<HashSet<Int64>>() //状态子集


//用'+'表示连接运算
func Add_symbol(regexp: String): String {
    var regexp2: String = ""
    var c1: Rune
    var c2: Rune
    var i: Int64 = 0
    while(i < regexp.size - 1){
        c1 = Rune(regexp[i])
        c2 = Rune(regexp[i + 1])
        regexp2 += String(c1)
        if(c1 != r'(' && c2 != r')' && c1 != r'|' && c2 != r'|' && c2 != r'*'){
            regexp2 += '+'
        }
        i++
    }
    regexp2 += String(Rune(regexp[regexp.size - 1]))
    return regexp2
}

//定义优先级
func Priority(ch: String): Int8 {
    if(ch == '*') {return 3}
    else if(ch == '+') {return 2}
    else if(ch == '|') {return 1}
    else {return 0}
}

//加工后的正规式转为后缀表达式
func RegExp_to_Postfix(regexp2: String): String {
    var postfix: String = ""
    var s2 : Stack<String> = Stack()
    var ch: String
    for(i in regexp2){
        ch = String(Rune(i))
        if(ch <= 'z' && ch >= 'a') {postfix += ch}
        else if(ch == '(') {s2.push(ch)}
        else if(ch == ')') {
            while(s2.top() != '(') {
                postfix += s2.pop()
            }
            s2.pop()
        }
        else {
            while(!s2.isEmpty()) {
                if(Priority(s2.top()) >= Priority(ch)) {
                    postfix += s2.pop()
                }
                else {break}
            }
            s2.push(ch)
        }
    }
    //检查栈里是否还有剩余元素
    while(!s2.isEmpty()) {
        postfix += s2.pop()
    }
    return postfix
}

//分配空间
func Get_are() {
    var newnode: FAnode = FAnode()
    var newnode2: FAnode = FAnode()
    nfa.append(newnode)
    nfa.append(newnode2)
}

//处理a或b
func Do_ab(i: Int64) {
    Get_are()
    nfa[len].node[i].append(len + 1)
    s.push(len)
    s.push(len + 1)
    len += 2
}

//处理'*'
func Do_star() {
    var b: Int64 = s.pop()
    var a: Int64 = s.pop()
    Get_are()
    nfa[b].node[0].append(a)
    nfa[len].node[0].append(a)
    nfa[len].node[0].append(len + 1)
    nfa[b].node[0].append(len + 1)
    s.push(len)
    s.push(len + 1)
    len += 2

}

//处理'|'
func Do_or() {
    var a: Int64 = s.pop()
    var b: Int64 = s.pop()
    var c: Int64 = s.pop()
    var d: Int64 = s.pop()
    Get_are()
    nfa[a].node[0].append(len + 1)
    nfa[len].node[0].append(b)
    nfa[c].node[0].append(len + 1)
    nfa[len].node[0].append(d)
    s.push(len)
    s.push(len + 1)
    len += 2
}

//处理'+'
func Do_add() {
    var d: Int64 = s.pop()
    var b: Int64 = s.pop()
    var a: Int64 = s.pop()
    var c: Int64 = s.pop()
    // NFA[a][0] = b
    nfa[a].node[0].append(b)
    s.push(c)
    s.push(d)
}

//后缀表达式转为NFA（Thompson构造法）
func Postfix_to_NFA(postfix: String) {
    var ch: String
    for(i in postfix) {
        ch = String(Rune(i))
        if (ch <= 'z' && ch >= 'a') {Do_ab(Int64(i) - 97 + 1)}
        else if (ch == '*') {Do_star()}
        else if (ch == '+') {Do_add()}
        else if (ch == '|') {Do_or()}
        else {println("输入非法字符")}
    }
}

//得到开始状态q0
func Get_q0(): Int64 {
    var flag: Bool
    var q0: Int64 = -1
    for (k in 0..len) {
        flag = true
        for (i in 0..len) {
            for (j in 0..=26) {
                if (nfa[i].node[j].contains(k)) {
                    flag = false
                    break
                }
            }
        }
        if (flag) {
                q0 = k
                break
            }
    }
    return q0
}

//得到接收状态集F
func Get_F(): ArrayList<Int64> {
    var arr = ArrayList<Int64>()
    var flag: Bool
    for (i in 0..len) {
        flag = true
        for (j in 0..=26) {
            if (nfa[i].node[j].size != 0) {
                flag = false
                break
            }
        }
        if (flag) {
            arr.append(i)
        }
    }
    return arr
}

//得到输入符号集合Σ
func Get_ab(): HashSet<Int64> {
    var arr = HashSet<Int64>()
    for (i in 0..len) {
        for (j in 1..=26) {
            if (nfa[i].node[j].size > 0) {
                arr.put(j)
            }
        }
    }
    return arr
}

//计算NFA并打印
func Print_NFA(regexp: String){
    var count: Int64 = 0
    // var count2: Int64 = 0
    println("正规式：" + regexp)
    var regexp2 = Add_symbol(regexp)
    println("加工后的正规式：" + regexp2)
    var postfix = RegExp_to_Postfix(regexp2)
    println("后缀表达式：" + postfix)
    Postfix_to_NFA(postfix)
    println("NFA：")
    //打印状态集Q
    print("Q = {")
    for ( i in 0..len) {
        if (i == len - 1) {println("${i}}")}
        else {print("${i}, ")}
    }
    //打印输入符号集合Σ
    print("Σ = {")
    var ab = Get_ab()
    // var ab_count: Int64 = 0
    for (i in ab) {
        if (count == ab.size - 1) {println("${Rune(i + 96)}}")}
        else {print("${Rune(i + 96)}, ")}
        count++
    }
    //打印状态转换函数δ,ε
    print("δ = {")
    for (i in 0..len) {
        for (j in 0..=26) {
            if (nfa[i].node[j].size > 0) {
                    var str:String = ""
                    for (value in nfa[i].node[j]){
                        str += "${value},"
                    }
                    if (j == 0){print("δ(${i},ε)={${str}}, ")}
                    else {print("δ(${i},${Rune(j + 96)})={${str}}, ")}
            }
        }
    }
    println("}")
    //打印开始状态（没有入度）
    println("q0 = {${Get_q0()}}")
    //打印接收状态集合（没有出度）
    print("F = {")
    var arr = Get_F()
    for (i in arr) {
        if (i == arr[arr.size - 1]) {print(i)}
        else {print("${i}, ")}
    }
    println("}")
}

//求状态t的ε闭包
func E_closure(t: Int64): HashSet<Int64> {
    var I = HashSet<Int64>()
    I.put(t)
    for (j in nfa[t].node[0]) {
        //如果状态集里没有这个元素
        if (!I.contains(j)) {
            //加入这个元素
            I.put(j)
            //求该元素的闭包
            I.putAll(E_closure(j))
        }
    }
    return I
}
//求状态子集I的ε闭包,在I的基础上增加ε闭包集合
func E_closure(I: HashSet<Int64>): HashSet<Int64>{
    var I2 = HashSet<Int64>()
    for (i in I) {
        I2.putAll(E_closure(i))
    }
    return I2
}
//状态t的a边转换，不包括状态t
func Edge(t: Int64, a: Int64): HashSet<Int64> {
    var I = HashSet<Int64>()
    for (j in nfa[t].node[a]) {
        //如果状态集里没有这个元素
        if (!I.contains(j)) {
            //加入这个元素
            I.put(j)
            //求该元素的a边转换
            I.putAll(Edge(j, a))
        }
    }
    return I
}
//状态集I的a边转换
func Edge(I: HashSet<Int64>, a: Int64): HashSet<Int64> {
    var J = HashSet<Int64>()
    for (t in I) {
        J.putAll(Edge(t, a))
    }
    return J
}
//状态子集I的a边转换
func DFA_edge(I: HashSet<Int64>, a: Int64): HashSet<Int64> {
    return E_closure(Edge(I, a))
}


//NFA转DFA（子集构造法Subset Construction）
func NFA_to_DFA() {
    //求第一个状态子集，q0是NFA的开始状态
    Dstates.append(E_closure(Get_q0()))
    //目前做边转换的状态子集
    var j: Int64 = 0
    var ab = Get_ab()
    var flag: Bool
    while (j <= p) {
        //遍历符号集合，是a则i为1
        for (i in ab) {
            var e = DFA_edge(Dstates[j], i)
            flag = false
            var newnode: FAnode = FAnode()
            dfa.append(newnode)
            //判断是否是已有的状态子集
            for (k in 0..=p) {
                //有
                if (e == Dstates[k]) {
                    flag = true
                    //建立状态转换关系
                    dfa[j].node[i - 1].append(k)
                    break
                }
            }
            //否，添加一个新的状态子集
            if (!flag) {
                p++
                Dstates.append(e)
                dfa[j].node[i - 1].append(p)
            }
        }
        j++
    }

}
//打印DFA
func Print_DFA() {
    var count: Int64 = 0
    println("DFA:")
    //打印状态集Q
    print("Q = {")
    for ( i in 0..=p) {
        if (i == p) {println("${i}}")}
        else {print("${i}, ")}
    }
    //打印输入符号集合Σ
    print("Σ = {")
    var ab = Get_ab()
    // var ab_count: Int64 = 0
    for (i in ab) {
        if (count == ab.size - 1) {println("${Rune(i + 96)}}")}
        else {print("${Rune(i + 96)}, ")}
        count++
    }
    //打印状态转换函数δ,ε
    print("δ = {")
    for (i in 0..=p) {
        for (j in 1..=26) {
            if (nfa[i].node[j].size > 0) {
                    var str:String = ""
                    for (value in nfa[i].node[j]){
                        str += "${value},"
                    }
                    if (j == 0){print("δ(${i},ε)={${str}}, ")}
                    else {print("δ(${i},${Rune(j + 97)})={${str}}, ")}
            }
        }
    }
    println("}")
    //打印开始状态（没有入度）
    println("q0 = {0}")
    //打印接收状态集合
    var F =HashSet<Int64>()
    print("F = {")
    var arr = Get_F()
    for (i in arr) {
        for (j in 0..=p) {
            if (Dstates[j].contains(i)) {
                F.put(j)
            }
        }
    }
    var F_count: Int64 = 0
    for (i in F) {
        F_count++
        if(F_count == F.size) {println("${i}}")}
        else {print("${i}, ")}
    }
}





main(){
    for (regexp in ["a|b","aba","(a|b)*","bb(a|b)*a","(aa)*"]) {
        nfa.clear()
        dfa.clear()
        len = 0
        p = 0
        Dstates.clear()
        while(!s.isEmpty()){
            s.pop()
        }
        Print_NFA(regexp)
        NFA_to_DFA()
        Print_DFA()
        println("----------------下一个测试用例---------------")
    }
}