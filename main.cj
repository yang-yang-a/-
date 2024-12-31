package Task3_Core_algorithm_of_syntax_analysis
import std.collection.*

main(): Int64 {
    println("\n---------------测试用例1---------------")
    var grammar_rules: String = """
    S -> S+T | T
    T -> T*F | F
    F -> (E) | id"""
    println(grammar_rules)
    Get_Rmap(grammar_rules)
    Get_Left_Recursive()

    println("\n---------------测试用例2---------------")
    var grammar_rules2: String = """
    S -> Ac | c
    A -> Bb | b
    B -> Sa | a"""
    println(grammar_rules2)
    Get_Rmap(grammar_rules2)
    Get_Left_Recursive()

    println("\n---------------测试用例3---------------")
    var grammar_rules3: String = """
    S -> apple | apply | application | ball | bat | bath | Xb
    X -> ab | ac | ad"""
    println(grammar_rules3)
    Get_Rmap(grammar_rules3)
    Remove_left()

    println("\n---------------测试用例4---------------")
    var grammar_rules4: String = """
    S -> AB
    A -> a | ε
    B -> b"""
    println(grammar_rules4)
    Get_Rmap(grammar_rules4)
    Get_FIRST()
    Get_FOLLOW()

    println("\n---------------测试用例5---------------")
    var grammar_rules5: String = """
    E -> TE'
    E' -> +TE' | ε
    T -> FT'
    T' -> *FT' | ε
    F -> (E) | i`d"""
    println(grammar_rules5)
    Get_Rmap(grammar_rules5)
    Get_FIRST()
    Get_FOLLOW()

    return 0
}