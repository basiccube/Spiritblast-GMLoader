//! Responsible for the lexical analysis stage of the Catspeak compiler.
//! This stage converts UTF8 encoded text from individual characters into
//! discrete clusters of characters called [tokens](https://en.wikipedia.org/wiki/Lexical_analysis#Lexical_token_and_lexical_tokenization).

#macro CATSPEAK_DEBUG_MODE global.catspeak_debug_mode

/// Indicates the type of Catspeak IR instruction.
///
/// @experimental
enum CatspeakTerm {
    VALUE,
    ARRAY,
    STRUCT,
    BLOCK,
    IF,
    AND,
    OR,
    LOOP,
    WITH,
    MATCH,
    USE,
    RETURN,
    BREAK,
    CONTINUE,
    THROW,
    OP_BINARY,
    OP_UNARY,
    CALL,
    CALL_NEW,
    SET,
    INDEX,
    PROPERTY,
    LOCAL,
    GLOBAL,
    FUNCTION,
    PARAMS,
    PARAMS_COUNT,
    SELF,
    OTHER,
    CATCH,
    /// @ignore
    __SIZE__
}

/// Represents the set of pure operators used by the Catspeak runtime and
/// compile-time constant folding.
///
/// @experimental
enum CatspeakOperator {
    /// The remainder `%` operator.
    REMAINDER,
    /// The `*` operator.
    MULTIPLY,
    /// The `/` operator.
    DIVIDE,
    /// The integer division `//` operator.
    DIVIDE_INT,
    /// The `-` operator.
    SUBTRACT,
    /// The `+` operator.
    PLUS,
    /// The `==` operator.
    EQUAL,
    /// The `!=` operator.
    NOT_EQUAL,
    /// The `>` operator.
    GREATER,
    /// The `>=` operator.
    GREATER_EQUAL,
    /// The `<` operator.
    LESS,
    /// The `<=` operator.
    LESS_EQUAL,
    /// The logical negation `!` operator.
    NOT,
    /// The bitwise negation `~` operator.
    BITWISE_NOT,
    /// The bitwise right shift `>>` operator.
    SHIFT_RIGHT,
    /// The bitwise left shift `<<` operator.
    SHIFT_LEFT,
    /// The bitwise AND `&` operator.
    BITWISE_AND,
    /// The bitwise XOR `^` operator.
    BITWISE_XOR,
    /// The bitwise OR `|` operator.
    BITWISE_OR,
    /// The logical XOR operator.
    XOR,
    /// @ignore
    __SIZE__,
}

/// Represents the set of assignment operators understood by Catspeak.
///
/// @experimental
enum CatspeakAssign {
    /// The typical `=` assignment.
    VANILLA,
    /// Multiply assign `*=`.
    MULTIPLY,
    /// Division assign `/=`.
    DIVIDE,
    /// Subtract assign `-=`.
    SUBTRACT,
    /// Plus assign `+=`.
    PLUS,
    /// @ignore
    __SIZE__,
}

/// A token in Catspeak is a series of characters with meaning, usually
/// separated by whitespace. These meanings are represented by unique
/// elements of the `CatspeakToken` enum.
///
/// @experimental
///
/// @example
///   Some examples of tokens in Catspeak, and their meanings:
///   - `if`   (is a `CatspeakToken.IF`)
///   - `else` (is a `CatspeakToken.ELSE`)
///   - `12.3` (is a `CatspeakToken.NUMBER`)
///   - `+`    (is a `CatspeakToken.PLUS`)
enum CatspeakToken {
    /// End of the file.
    EOF = 0,
    COLON,
    COLON_COLON,
    COMMA,
    ARROW,
    /// @ignore
    __TERMINAL_BEGIN__,
    SELF,
    OTHER,
    /// Reserved in case of argument array access.
    ///
    /// @experimental
    PARAMS,
    /// Reserved in case of argument array access.
    ///
    /// @experimental
    PARAMS_COUNT,
    /// Represents a variable name.
    ///
    /// This can either be an alphanumeric name, or a so-called
    /// "raw identifier" wrapped in backticks `` ` ``.
    IDENT,
    /// Represents a numeric value. This could be one of:
    ///  - integer:           `1`, `2`, `5`
    ///  - float:             `1.25`, `0.5`
    ///  - character:         `'A'`, `'0'`, `'\n'`
    ///  - boolean:           `true` or `false`
    NUMBER,
    /// Represents a string value. This could be one of:
    ///  - string literal:    `"hello world"`
    ///  - verbatim literal:  `@"\(0_0)/ no escapes!"`
    STRING,
    /// Represents the `undefined` value in GML. Logically boring.
    UNDEFINED,
    /// @ignore
    __TERMINAL_END__,
    /// @ignore
    __INDEX_BEGIN__,
    PAREN_LEFT,
    PAREN_RIGHT,
    BOX_LEFT,
    BOX_RIGHT,
    BRACE_LEFT,
    BRACE_RIGHT,
    DOT,
    NEW,
    /// @ignore
    __INDEX_END__,
    /// @ignore
    __OP_MULT_BEGIN__,
    REMAINDER,
    MULTIPLY,
    DIVIDE,
    DIVIDE_INT,
    /// @ignore
    __OP_MULT_END__,
    /// @ignore
    __OP_UNARY_BEGIN__,
    /// @ignore
    __OP_ADD_BEGIN__,
    MINUS,
    PLUS,
    /// @ignore
    __OP_ADD_END__,
    NOT,
    BITWISE_NOT,
    /// @ignore
    __OP_UNARY_END__,
    /// @ignore
    __OP_BITWISE_BEGIN__,
    BITWISE_AND,
    BITWISE_XOR,
    BITWISE_OR,
    SHIFT_RIGHT,
    SHIFT_LEFT,
    /// @ignore
    __OP_BITWISE_END__,
    /// @ignore
    __OP_RELATE_BEGIN__,
    GREATER,
    GREATER_EQUAL,
    LESS,
    LESS_EQUAL,
    /// @ignore
    __OP_RELATE_END__,
    /// @ignore
    __OP_EQUAL_BEGIN__,
    EQUAL,
    NOT_EQUAL,
    /// @ignore
    __OP_EQUAL_END__,
    /// @ignore
    __OP_PIPE_BEGIN__,
    PIPE_RIGHT,
    PIPE_LEFT,
    /// @ignore
    __OP_PIPE_END__,
    AND,
    /// @ignore
    __OP_OR_BEGIN__,
    OR,
    XOR,
    /// @ignore
    __OP_OR_END__,
    /// @ignore
    __BLOCKEXPR_BEGIN__,
    DO,
    IF,
    ELSE,
    WHILE,
    /// Reserved in case of for loops.
    ///
    /// @experimental
    FOR,
    /// Reserved in case of infinite loops.
    ///
    /// @experimental
    LOOP,
    WITH,
    /// @experimental
    MATCH,
    FUN,
    /// Reserved in case of constructors.
    ///
    /// @experimental
    IMPL,
    /// @ignore
    __BLOCKEXPR_END__,
    CATCH,
    /// @ignore
    __OP_ASSIGN_BEGIN__,
    ASSIGN,
    ASSIGN_MULTIPLY,
    ASSIGN_DIVIDE,
    ASSIGN_MINUS,
    ASSIGN_PLUS,
    /// @ignore
    __OP_ASSIGN_END__,
    /// @ignore
    __EXPR_BEGIN__,
    RETURN,
    CONTINUE,
    BREAK,
    THROW,
    /// @ignore
    __EXPR_END__,
    /// @ignore
    __STMT_BEGIN__,
    SEMICOLON,
    LET,
    /// @ignore
    __STMT_END__,
    /// Represents a sequence of non-breaking whitespace characters.
    WHITESPACE,
    COMMENT,
    /// Represents any other unrecognised character.
    ///
    /// @remark
    ///   If the compiler encounters a token of this type, it will typically
    ///   raise an exception. This likely indicates that a Catspeak script has
    ///   a syntax error somewhere.
    ERROR,
    /// @ignore
    __SIZE__,
}

/// A token in Catspeak is a series of characters with meaning, usually
/// separated by whitespace. These meanings are represented by unique
/// elements of the `CatspeakTokenV3` enum.
///
/// @deprecated {4.0.0}
///   Use `CatspeakToken` instead.
///
/// @example
///   Some examples of tokens in Catspeak, and their meanings:
///   - `if`   (is a `CatspeakTokenV3.IF`)
///   - `else` (is a `CatspeakTokenV3.ELSE`)
///   - `12.3` (is a `CatspeakTokenV3.VALUE`)
///   - `+`    (is a `CatspeakTokenV3.PLUS`)
enum CatspeakTokenV3 {
    /// The `(` character.
    PAREN_LEFT = CatspeakToken.PAREN_LEFT,
    /// The `)` character.
    PAREN_RIGHT = CatspeakToken.PAREN_RIGHT,
    /// The `[` character.
    BOX_LEFT = CatspeakToken.BOX_LEFT,
    /// The `]` character.
    BOX_RIGHT = CatspeakToken.BOX_RIGHT,
    /// The `{` character.
    BRACE_LEFT = CatspeakToken.BRACE_LEFT,
    /// The `}` character.
    BRACE_RIGHT = CatspeakToken.BRACE_RIGHT,
    /// The `:` character.
    COLON = CatspeakToken.COLON,
    /// The `;` character.
    SEMICOLON = CatspeakToken.SEMICOLON,
    /// The `,` character.
    COMMA = CatspeakToken.COMMA,
    /// The `.` operator.
    DOT = CatspeakToken.DOT,
    /// The `=>` operator.
    ARROW = CatspeakToken.ARROW,
    /// @ignore
    __OP_ASSIGN_BEGIN__ = CatspeakToken.ASSIGN,
    /// The `=` operator.
    ASSIGN = CatspeakToken.ASSIGN,
    /// The `*=` operator.
    ASSIGN_MULTIPLY = CatspeakToken.ASSIGN_MULTIPLY,
    /// The `/=` operator.
    ASSIGN_DIVIDE = CatspeakToken.ASSIGN_DIVIDE,
    /// The `-=` operator.
    ASSIGN_SUBTRACT = CatspeakToken.ASSIGN_MINUS,
    /// The `+=` operator.
    ASSIGN_PLUS = CatspeakToken.ASSIGN_PLUS,
    /// @ignore
    __OP_BEGIN__ = CatspeakToken.REMAINDER,
    /// The remainder `%` operator.
    REMAINDER = CatspeakToken.REMAINDER,
    /// The `*` operator.
    MULTIPLY = CatspeakToken.MULTIPLY,
    /// The `/` operator.
    DIVIDE = CatspeakToken.DIVIDE,
    /// The integer division `//` operator.
    DIVIDE_INT = CatspeakToken.DIVIDE_INT,
    /// The `-` operator.
    SUBTRACT = CatspeakToken.MINUS,
    /// The `+` operator.
    PLUS = CatspeakToken.PLUS,
    /// The relational `==` operator.
    EQUAL = CatspeakToken.EQUAL,
    /// The relational `!=` operator.
    NOT_EQUAL = CatspeakToken.NOT_EQUAL,
    /// The relational `>` operator.
    GREATER = CatspeakToken.GREATER,
    /// The relational `>=` operator.
    GREATER_EQUAL = CatspeakToken.GREATER_EQUAL,
    /// The relational `<` operator.
    LESS = CatspeakToken.LESS,
    /// The relational `<=` operator.
    LESS_EQUAL = CatspeakToken.LESS_EQUAL,
    /// The logical negation `!` operator.
    NOT = CatspeakToken.NOT,
    /// The bitwise negation `~` operator.
    BITWISE_NOT = CatspeakToken.BITWISE_NOT,
    /// The bitwise right shift `>>` operator.
    SHIFT_RIGHT = CatspeakToken.SHIFT_RIGHT,
    /// The bitwise left shift `<<` operator.
    SHIFT_LEFT = CatspeakToken.SHIFT_LEFT,
    /// The bitwise and `&` operator.
    BITWISE_AND = CatspeakToken.BITWISE_AND,
    /// The bitwise xor `^` operator.
    BITWISE_XOR = CatspeakToken.BITWISE_XOR,
    /// The bitwise or `|` operator.
    BITWISE_OR = CatspeakToken.BITWISE_OR,
    /// The logical `and` operator.
    AND = CatspeakToken.AND,
    /// The logical `or` operator.
    OR = CatspeakToken.OR,
    /// The logical `xor` operator.
    XOR = CatspeakToken.XOR,
    /// The functional pipe right `|>` operator.
    PIPE_RIGHT = CatspeakToken.PIPE_RIGHT,
    /// The functional pipe left `<|` operator.
    PIPE_LEFT = CatspeakToken.PIPE_LEFT,
    /// The `do` keyword.
    DO = CatspeakToken.DO,
    /// The `if` keyword.
    IF = CatspeakToken.IF,
    /// The `else` keyword.
    ELSE = CatspeakToken.ELSE,
    /// The `catch` keyword.
    CATCH = CatspeakToken.CATCH,
    /// The `while` keyword.
    WHILE = CatspeakToken.WHILE,
    /// The `for` keyword.
    ///
    /// @experimental
    FOR = CatspeakToken.FOR,
    /// The `loop` keyword.
    ///
    /// @experimental
    LOOP = CatspeakToken.LOOP,
    /// The `with` keyword.
    ///
    /// @experimental
    WITH = CatspeakToken.WITH,
    /// The `match` keyword.
    ///
    /// @experimental
    MATCH = CatspeakToken.MATCH,
    /// The `let` keyword.
    LET = CatspeakToken.LET,
    /// The `fun` keyword.
    FUN = CatspeakToken.FUN,
    /// The `break` keyword.
    BREAK = CatspeakToken.BREAK,
    /// The `continue` keyword.
    CONTINUE = CatspeakToken.CONTINUE,
    /// The `return` keyword.
    RETURN = CatspeakToken.RETURN,
    /// The `throw` keyword.
    THROW = CatspeakToken.THROW,
    /// The `new` keyword.
    NEW = CatspeakToken.NEW,
    /// The `impl` keyword.
    ///
    /// @experimental
    IMPL = CatspeakToken.IMPL,
    /// The `self` keyword.
    ///
    /// @experimental
    SELF = CatspeakToken.SELF,
    /// The `params` keyword.
    ///
    /// @experimental
    PARAMS = CatspeakToken.PARAMS,
    /// The `params_count` keyword.
    ///
    /// @experimental
    PARAMS_COUNT = CatspeakToken.PARAMS_COUNT,
    /// Represents a variable name.
    IDENT = CatspeakToken.IDENT,
    /// Represents a GML value. This could be one of:
    ///  - string literal:    `"hello world"`
    ///  - verbatim literal:  `@"\(0_0)/ no escapes!"`
    ///  - integer:           `1`, `2`, `5`
    ///  - float:             `1.25`, `0.5`
    ///  - character:         `'A'`, `'0'`, `'\n'`
    ///  - boolean:           `true` or `false`
    ///  - `undefined`
    //VALUE = CatspeakToken.NUMBER,
    VALUE_NUMBER = CatspeakToken.NUMBER,
    VALUE_STRING = CatspeakToken.STRING,
    VALUE_UNDEFINED = CatspeakToken.UNDEFINED,
    /// Represents a sequence of non-breaking whitespace characters.
    WHITESPACE = CatspeakToken.WHITESPACE,
    /// Represents a comment.
    COMMENT = CatspeakToken.COMMENT,
    /// Represents the end of the file.
    EOF = CatspeakToken.EOF,
    /// Represents any other unrecognised character.
    ///
    /// @remark
    ///   If the compiler encounters a token of this type, it will typically
    ///   raise an exception. This likely indicates that a Catspeak script has
    ///   a syntax error somewhere.
    OTHER = CatspeakToken.ERROR,
    /// @ignore
    __SIZE__ = CatspeakToken.__SIZE__,
}

//# feather use syntax-errors

//! Responsible for the syntax analysis stage of the Catspeak compiler.
//!
//! This stage uses `CatspeakIRBuilder` to create a hierarchical
//! representation of your Catspeak programs, called an abstract syntax graph
//! (or ASG for short). These graphs are encoded as a JSON object, making it
//! possible for you to cache the result of parsing a mod to a file, instead
//! of re-parsing each time the game loads.

//# feather use syntax-errors

/// Consumes tokens produced by a `CatspeakLexerV3`, transforming the program
/// they represent into Catspeak IR. This Catspeak IR can be further compiled
/// down into a callable GML function using `CatspeakGMLCompiler`.
///
/// @experimental
///
/// @param {Struct.CatspeakLexerV3} lexer
///   The lexer to consume tokens from.
///
/// @param {Struct.CatspeakIRBuilder} builder
///   The Catspeak IR builder to write the program to.
function CatspeakParserV3(lexer, builder) constructor {
    if (CATSPEAK_DEBUG_MODE) {
        __catspeak_check_arg_struct_instanceof(
                "lexer", lexer, "CatspeakLexerV3");
        __catspeak_check_arg_struct_instanceof(
                "builder", builder, "CatspeakIRBuilder");
    }
    /// @ignore
    self.lexer = lexer;
    /// @ignore
    self.ir = builder;
    /// @ignore
    self.finalised = false;
    builder.pushFunction();

    /// Parses a top-level Catspeak statement from the supplied lexer, adding
    /// any relevant parse information to the supplied IR.
    ///
    /// @example
    ///   Creates a new `CatspeakParserV3` from the variables `lexer` and
    ///   `builder`, then loops until there is nothing left to parse.
    ///
    ///   ```gml
    ///   var parser = new CatspeakParserV3(lexer, builder);
    ///   var moreToParse;
    ///   do {
    ///       moreToParse = parser.update();
    ///   } until (!moreToParse);
    ///   ```
    ///
    /// @return {Bool}
    ///   `true` if there is still more data left to parse, and `false`
    ///   if the parser has reached the end of the file.
    static update = function () {
        if (lexer.peek() == CatspeakTokenV3.EOF) {
            if (!finalised) {
                ir.popFunction();
                finalised = true;
            }
            return false;
        }
        if (CATSPEAK_DEBUG_MODE && finalised) {
            __catspeak_error_v3(
                "attempting to update parser after it has been finalised"
            );
        }
        __parseStatement();
        return true;
    };

    /// @ignore
    static __parseStatement = function () {
        var result;
        var peeked = lexer.peek();
        if (peeked == CatspeakTokenV3.SEMICOLON) {
            lexer.next();
            return;
        } else if (peeked == CatspeakTokenV3.LET) {
            lexer.next();
            if (lexer.next() != CatspeakTokenV3.IDENT) {
                __ex("expected identifier after 'let' keyword");
            }
            var localName = lexer.getValue();
            var location = lexer.getLocation();
            var valueTerm;
            if (lexer.peek() == CatspeakTokenV3.ASSIGN) {
                lexer.next();
                valueTerm = __parseExpression();
            } else {
                valueTerm = ir.createValue(undefined, location);
            }
            var getter = ir.allocLocal(localName, location);
            result = ir.createAssign(
                CatspeakAssign.VANILLA,
                getter,
                valueTerm,
                lexer.getLocation()
            );
        } else {
            result = __parseExpression();
        }
        ir.createStatement(result);
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseExpression = function () {
        var peeked = lexer.peek();
        if (peeked == CatspeakTokenV3.RETURN) {
            lexer.next();
            peeked = lexer.peek();
            var value;
            if (
                peeked == CatspeakTokenV3.SEMICOLON ||
                peeked == CatspeakTokenV3.BRACE_RIGHT ||
                peeked == CatspeakTokenV3.LET
            ) {
                value = ir.createValue(undefined, lexer.getLocation());
            } else {
                value = __parseExpression();
            }
            return ir.createReturn(value, lexer.getLocation());
        } else if (peeked == CatspeakTokenV3.CONTINUE) {
            lexer.next();
            return ir.createContinue(lexer.getLocation());
        } else if (peeked == CatspeakTokenV3.BREAK) {
            lexer.next();
            peeked = lexer.peek();
            var value;
            if (
                peeked == CatspeakTokenV3.SEMICOLON ||
                peeked == CatspeakTokenV3.BRACE_RIGHT ||
                peeked == CatspeakTokenV3.LET
            ) {
                value = ir.createValue(undefined, lexer.getLocation());
            } else {
                value = __parseExpression();
            }
            return ir.createBreak(value, lexer.getLocation());
        } else if (peeked == CatspeakTokenV3.THROW) {
            lexer.next();
            peeked = lexer.peek();
            var value = __parseExpression();
            return ir.createThrow(value, lexer.getLocation());
        } else {
            return __parseAssign();
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseAssign = function () {
        var lhs = __parseCatch();
        var peeked = lexer.peek();
        if (
            peeked == CatspeakTokenV3.ASSIGN ||
            peeked == CatspeakTokenV3.ASSIGN_MULTIPLY ||
            peeked == CatspeakTokenV3.ASSIGN_DIVIDE ||
            peeked == CatspeakTokenV3.ASSIGN_SUBTRACT ||
            peeked == CatspeakTokenV3.ASSIGN_PLUS
        ) {
            lexer.next();
            var assignType = __catspeak_operator_assign_from_token(peeked);
            lhs = ir.createAssign(
                assignType,
                lhs,
                __parseExpression(),
                lexer.getLocation()
            );
        }
        return lhs;
    };
    
    /// @ignore
    ///
    /// @return {Struct}
    static __parseCatch = function () {
        var result = __parseExpressionBlock();
        while (true) {
            if (lexer.peek() == CatspeakTokenV3.CATCH) {
                lexer.next();
                ir.pushBlock();
                var localRef = undefined;
                if (lexer.peek() == CatspeakTokenV3.IDENT) {
                    lexer.next();
                    var localName = lexer.getValue();
                    localRef = ir.allocLocal(localName, lexer.getLocation());
                }
                __parseStatements("catch");
                var catchBlock_ = ir.popBlock();
                result = ir.createCatch(result, catchBlock_, localRef, lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseExpressionBlock = function () {
        var peeked = lexer.peek();
        if (peeked == CatspeakTokenV3.DO) {
            lexer.next();
            ir.pushBlock(true);
            __parseStatements("do");
            return ir.popBlock();
        } else if (peeked == CatspeakTokenV3.IF) {
            lexer.next();
            var condition = __parseCondition();
            ir.pushBlock();
            __parseStatements("if")
            var ifTrue = ir.popBlock();
            var ifFalse;
            if (lexer.peek() == CatspeakTokenV3.ELSE) {
                lexer.next();
                ir.pushBlock();
                if (lexer.peek() == CatspeakTokenV3.IF) {
                    // for `else if` support
                    var elseIf = __parseExpression();
                    ir.createStatement(elseIf);
                } else {
                    __parseStatements("else");
                }
                ifFalse = ir.popBlock();
            } else {
                ifFalse = ir.createValue(undefined, lexer.getLocation());
            }
            return ir.createIf(condition, ifTrue, ifFalse, lexer.getLocation());
        } else if (peeked == CatspeakTokenV3.WHILE) {
            lexer.next();
            var condition = __parseCondition();
            ir.pushBlock();
            __parseStatements("while");
            var body = ir.popBlock();
            return ir.createWhile(condition, body, lexer.getLocation());
        } else if (peeked == CatspeakTokenV3.WITH) {
            lexer.next();
            var scope = __parseCondition();
            ir.pushBlock();
            __parseStatements("with");
            var body = ir.popBlock();
            return ir.createWith(scope, body, lexer.getLocation());
        } else if (peeked == CatspeakTokenV3.MATCH) {
            lexer.next();
            var value = __parseExpression();
            var conditions = __parseMatchArms();
            return ir.createMatch(value, conditions, lexer.getLocation());
        } else if (peeked == CatspeakTokenV3.FUN) {
            lexer.next();
            ir.pushFunction();
            if (lexer.peek() != CatspeakTokenV3.BRACE_LEFT) {
                if (lexer.next() != CatspeakTokenV3.PAREN_LEFT) {
                    __ex("expected opening '(' after 'fun' keyword");
                }
                while (__isNot(CatspeakTokenV3.PAREN_RIGHT)) {
                    if (lexer.next() != CatspeakTokenV3.IDENT) {
                        __ex("expected identifier in function arguments");
                    }
                    ir.allocArg(lexer.getValue(), lexer.getLocation());
                    if (lexer.peek() == CatspeakTokenV3.COMMA) {
                        lexer.next();
                    }
                }
                if (lexer.next() != CatspeakTokenV3.PAREN_RIGHT) {
                    __ex("expected closing ')' after function arguments");
                }
            }
            __parseStatements("fun");
            return ir.popFunction();
        } else {
            return __parseCondition();
        }
    };

    /// @ignore
    ///
    /// @param {String} keyword
    /// @return {Struct}
    static __parseStatements = function (keyword) {
        if (lexer.next() != CatspeakTokenV3.BRACE_LEFT) {
            __ex("expected opening '{' at the start of '", keyword, "' block");
        }
        while (__isNot(CatspeakTokenV3.BRACE_RIGHT)) {
            __parseStatement();
        }
        if (lexer.next() != CatspeakTokenV3.BRACE_RIGHT) {
            __ex("expected closing '}' after '", keyword, "' block");
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseCondition = function () {
        return __parseOpLogicalOR();
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpLogicalOR = function () {
        var result = __parseOpLogicalAND();
        while (true) {
            var peeked = lexer.peek();
            if (peeked == CatspeakTokenV3.OR) {
                lexer.next();
                var lhs = result;
                var rhs = __parseOpLogicalAND();
                result = ir.createOr(lhs, rhs, lexer.getLocation());
            } else if (peeked == CatspeakTokenV3.XOR) {
                lexer.next();
                var lhs = result;
                var rhs = __parseOpLogicalAND();
                result = ir.createBinary(CatspeakOperator.XOR, lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpLogicalAND = function () {
        var result = __parseOpPipe();
        while (true) {
            var peeked = lexer.peek();
            if (peeked == CatspeakTokenV3.AND) {
                lexer.next();
                var lhs = result;
                var rhs = __parseOpPipe();
                result = ir.createAnd(lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpPipe = function () {
        var result = __parseOpEquality();
        while (true) {
            var peeked = lexer.peek();
            if (peeked == CatspeakTokenV3.PIPE_RIGHT) {
                lexer.next();
                var lhs = result;
                var rhs = __parseOpEquality();
                result = ir.createCall(rhs, [lhs], lexer.getLocation());
            } else if (peeked == CatspeakTokenV3.PIPE_LEFT) {
                lexer.next();
                var lhs = result;
                var rhs = __parseOpEquality();
                result = ir.createCall(lhs, [rhs], lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpEquality = function () {
        var result = __parseOpRelational();
        while (true) {
            var peeked = lexer.peek();
            if (
                peeked == CatspeakTokenV3.EQUAL ||
                peeked == CatspeakTokenV3.NOT_EQUAL
            ) {
                lexer.next();
                var op = __catspeak_operator_from_token(peeked);
                var lhs = result;
                var rhs = __parseOpRelational();
                result = ir.createBinary(op, lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpRelational = function () {
        var result = __parseOpBitwise();
        while (true) {
            var peeked = lexer.peek();
            if (
                peeked == CatspeakTokenV3.LESS ||
                peeked == CatspeakTokenV3.LESS_EQUAL ||
                peeked == CatspeakTokenV3.GREATER ||
                peeked == CatspeakTokenV3.GREATER_EQUAL
            ) {
                lexer.next();
                var op = __catspeak_operator_from_token(peeked);
                var lhs = result;
                var rhs = __parseOpBitwise();
                result = ir.createBinary(op, lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };


    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpBitwise = function () {
        var result = __parseOpAdd();
        while (true) {
            var peeked = lexer.peek();
            if (
                peeked == CatspeakTokenV3.BITWISE_AND ||
                peeked == CatspeakTokenV3.BITWISE_XOR ||
                peeked == CatspeakTokenV3.BITWISE_OR ||
                peeked == CatspeakTokenV3.SHIFT_LEFT ||
                peeked == CatspeakTokenV3.SHIFT_RIGHT
            ) {
                lexer.next();
                var op = __catspeak_operator_from_token(peeked);
                var lhs = result;
                var rhs = __parseOpAdd();
                result = ir.createBinary(op, lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };
    
    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpAdd = function () {
        var result = __parseOpMultiply();
        while (true) {
            var peeked = lexer.peek();
            if (
                peeked == CatspeakTokenV3.PLUS ||
                peeked == CatspeakTokenV3.SUBTRACT
            ) {
                lexer.next();
                var op = __catspeak_operator_from_token(peeked);
                var lhs = result;
                var rhs = __parseOpMultiply();
                result = ir.createBinary(op, lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpMultiply = function () {
        var result = __parseOpUnary();
        while (true) {
            var peeked = lexer.peek();
            if (
                peeked == CatspeakTokenV3.MULTIPLY ||
                peeked == CatspeakTokenV3.DIVIDE ||
                peeked == CatspeakTokenV3.DIVIDE_INT ||
                peeked == CatspeakTokenV3.REMAINDER
            ) {
                lexer.next();
                var op = __catspeak_operator_from_token(peeked);
                var lhs = result;
                var rhs = __parseOpUnary();
                result = ir.createBinary(op, lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpUnary = function () {
        var peeked = lexer.peek();
        if (
            peeked == CatspeakTokenV3.NOT ||
            peeked == CatspeakTokenV3.BITWISE_NOT ||
            peeked == CatspeakTokenV3.SUBTRACT ||
            peeked == CatspeakTokenV3.PLUS
        ) {
            lexer.next();
            var op = __catspeak_operator_from_token(peeked);
            var value = __parseIndex();
            return ir.createUnary(op, value, lexer.getLocation());
        //} else if (peeked == CatspeakTokenV3.COLON) {
        //    // `:property` syntax
        //    lexer.next();
        //    return ir.createProperty(__parseTerminal(), lexer.getLocation());
        } else {
            return __parseIndex();
        }
    };
    
    /// @ignore
    ///
    /// @return {Array}
    static __parseMatchArms = function () {
        if (lexer.next() != CatspeakTokenV3.BRACE_LEFT) {
            __ex("expected opening '{' before 'match' arms");
        }
        var conditions = [];
        while (__isNot(CatspeakTokenV3.BRACE_RIGHT)) {
            var value;
            var prefix = lexer.next();
            if (prefix == CatspeakTokenV3.ELSE) {
                value = undefined;
            } else if (lexer.getLexeme() != "case") {
                __ex("expected 'case' keyword before non-default match arm");
            } else {
                value = __parseExpression();
            }
            ir.pushBlock();
            __parseStatements("case");
            var result = ir.popBlock();
            array_push(conditions, [value, result]);
        }
        if (lexer.next() != CatspeakTokenV3.BRACE_RIGHT) {
            __ex("expected closing '}' after 'match' arm");
        }
        return conditions;
    }

    /// @ignore
    ///
    /// @return {Struct}
    static __parseIndex = function () {
        var callNew = lexer.peek() == CatspeakTokenV3.NEW;
        if (callNew) {
            lexer.next();
        }
        var result = __parseTerminal();
        while (true) {
            var peeked = lexer.peek();
            if (peeked == CatspeakTokenV3.PAREN_LEFT) {
                // function call syntax
                lexer.next();
                var args = [];
                while (__isNot(CatspeakTokenV3.PAREN_RIGHT)) {
                    array_push(args, __parseExpression());
                    if (lexer.peek() == CatspeakTokenV3.COMMA) {
                        lexer.next();
                    }
                }
                if (lexer.next() != CatspeakTokenV3.PAREN_RIGHT) {
                    __ex("expected closing ')' after function arguments");
                }
                result = callNew
                        ? ir.createCallNew(result, args, lexer.getLocation())
                        : ir.createCall(result, args, lexer.getLocation());
                callNew = false;
            } else if (peeked == CatspeakTokenV3.BOX_LEFT) {
                // accessor syntax
                lexer.next();
                var collection = result;
                var key = __parseExpression();
                if (lexer.next() != CatspeakTokenV3.BOX_RIGHT) {
                    __ex("expected closing ']' after accessor expression");
                }
                result = ir.createAccessor(collection, key, lexer.getLocation());
            } else if (peeked == CatspeakTokenV3.DOT) {
                // dot accessor syntax
                lexer.next();
                var collection = result;
                if (lexer.next() != CatspeakTokenV3.IDENT) {
                    __ex("expected identifier after '.' operator");
                }
                var key = ir.createValue(lexer.getValue(), lexer.getLocation());
                result = ir.createAccessor(collection, key, lexer.getLocation());
            } else {
                break;
            }
        }
        if (callNew) {
            // implicit new: `let t = new Thing;`
            result = ir.createCallNew(result, [], lexer.getLocation());
        }
        return result;
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseTerminal = function () {
        var peeked = lexer.peek();
        if (
            peeked == CatspeakTokenV3.VALUE_NUMBER ||
            peeked == CatspeakTokenV3.VALUE_STRING ||
            peeked == CatspeakTokenV3.VALUE_UNDEFINED
        ) {
            lexer.next();
            return ir.createValue(lexer.getValue(), lexer.getLocation());
        } else if (peeked == CatspeakTokenV3.IDENT) {
            lexer.next();
            return ir.createGet(lexer.getValue(), lexer.getLocation());
        } else if (peeked == CatspeakTokenV3.SELF) {
            lexer.next();
            return ir.createSelf(lexer.getLocation());
        } else if (peeked == CatspeakTokenV3.OTHER) {
            lexer.next();
            return ir.createOther(lexer.getLocation());
        } else {
            return __parseGrouping();
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseGrouping = function () {
        var peeked = lexer.peek();
        if (peeked == CatspeakTokenV3.PAREN_LEFT) {
            lexer.next();
            var inner = __parseExpression();
            if (lexer.next() != CatspeakTokenV3.PAREN_RIGHT) {
                __ex("expected closing ')' after group expression");
            }
            return inner;
        } else if (peeked == CatspeakTokenV3.BOX_LEFT) {
            lexer.next();
            var values = [];
            while (__isNot(CatspeakTokenV3.BOX_RIGHT)) {
                array_push(values, __parseExpression());
                if (lexer.peek() == CatspeakTokenV3.COMMA) {
                    lexer.next();
                }
            }
            if (lexer.next() != CatspeakTokenV3.BOX_RIGHT) {
                __ex("expected closing ']' after array literal");
            }
            return ir.createArray(values, lexer.getLocation());
        } else if (peeked == CatspeakTokenV3.BRACE_LEFT) {
            lexer.next();
            var values = [];
            while (__isNot(CatspeakTokenV3.BRACE_RIGHT)) {
                var key;
                var keyToken = lexer.next();
                if (keyToken == CatspeakTokenV3.BOX_LEFT) {
                    key = __parseExpression();
                    if (lexer.next() != CatspeakTokenV3.BOX_RIGHT) {
                        __ex(
                            "expected closing ']' after computed struct key"
                        );
                    }
                } else if (
                    keyToken == CatspeakTokenV3.IDENT ||
                    keyToken == CatspeakTokenV3.VALUE_NUMBER ||
                    keyToken == CatspeakTokenV3.VALUE_STRING ||
                    keyToken == CatspeakTokenV3.VALUE_UNDEFINED
                ) {
                    key = ir.createValue(lexer.getValue(), lexer.getLocation());
                } else {
                    __ex("expected identifier or value as struct key");
                }
                var value;
                if (lexer.peek() == CatspeakTokenV3.COLON) {
                    lexer.next();
                    value = __parseExpression();
                } else if (keyToken == CatspeakTokenV3.IDENT) {
                    value = ir.createGet(key.value, lexer.getLocation());
                } else {
                    __ex(
                        "expected ':' between key and value ",
                        "of struct literal"
                    );
                }
                if (lexer.peek() == CatspeakTokenV3.COMMA) {
                    lexer.next();
                }
                array_push(values, key, value);
            }
            if (lexer.next() != CatspeakTokenV3.BRACE_RIGHT) {
                __ex("expected closing '}' after struct literal");
            }
            return ir.createStruct(values, lexer.getLocation());
        } else {
            __ex("malformed expression, expected: '(', '[' or '{'");
        }
    };

    /// @ignore
    ///
    /// @param {String} ...
    static __ex = function () {
        var dbg = __catspeak_location_show(lexer.getLocation(), ir.filepath) + " when parsing";
        if (argument_count < 1) {
            __catspeak_error_v3(dbg);
        } else {
            var msg = "";
            for (var i = 0; i < argument_count; i += 1) {
                msg += __catspeak_string(argument[i]);
            }
            __catspeak_error_v3(dbg, " -- ", msg, ", got ", __tokenDebug());
        }
    };

    /// @ignore
    ///
    /// @return {String}
    static __tokenDebug = function () {
        var peeked = lexer.peek();
        if (peeked == CatspeakTokenV3.EOF) {
            return "end of file";
        } else if (peeked == CatspeakTokenV3.SEMICOLON) {
            return "line break ';'";
        }
        return "token '" + lexer.getLexeme() + "' (" + string(peeked) + ")";
    };

    /// @ignore
    ///
    /// @param {Enum.CatspeakTokenV3} expect
    /// @return {Bool}
    static __isNot = function (expect) {
        var peeked = lexer.peek();
        return peeked != expect && peeked != CatspeakTokenV3.EOF;
    };

    /// @ignore
    ///
    /// @param {Enum.CatspeakTokenV3} expect
    /// @return {Bool}
    static __is = function (expect) {
        var peeked = lexer.peek();
        return peeked == expect && peeked != CatspeakTokenV3.EOF;
    };
}