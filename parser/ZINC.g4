grammar ZINC;


// Top-level program structure
program
    : (statement | declaration)* SEMICOLON? EOF
    ;


statement
    : expression
    | declaration
    | function
    | ifStatement
    | matchStatement
    | returnStatement
    | loop
    ;

// Improved declaration rules
declaration
    : variableDeclaration
    | arrayDeclaration
    | mapDeclaration
    ;


variableDeclaration
    : IDENTIFIER COLON types (ASSIGN expression)?
    | IDENTIFIER WALRUS expression
    ;

arrayDeclaration
    : LBRACKET (expression (COMMA expression)*)? RBRACKET
    ;

mapDeclaration
    : LBRACKET types COMMA types RBRACKET LBRACE (mapEntry (COMMA mapEntry)*)? RBRACE
    ;

mapEntry
    : expression COLON expression
    ;


// Simplified expression hierarchy
expression
    : primary                                                                       # PrimaryExpr
    | LPAREN expression RPAREN                                                      # ParenExpr
    | expression op=(MULTIPLY | DIVIDE | MOD | FLOOR_DIV | SQUARE) expression       # ArithmeticExpr
    | expression op=(PLUS | MINUS) expression                                       # AddSubExpr
    | expression op=(INC | DEC)                                                     # UnaryPostfixExpr
    | op=NOT expression                                                             # UnaryPrefixExpr
    | expression op=(EQ | NEQ | GT | LT | GTE | LTE | IS | IS_NOT) expression       # ComparisonExpr
    | expression op=(AND | OR) expression                                           # LogicalExpr
    | functionCall                                                                  # FunctionCallExpr
    | cast                                                                          # CastExpr
    ;


primary
    : literal
    | IDENTIFIER
    | arrayDeclaration
    | mapDeclaration
    | classPattern
    ;

literal
    : INTEGER           # IntLiteral
    | REAL              # RealLiteral
    | STRING            # StringLiteral
    | CHARACTER         # CharLiteral
    | BOOLEAN           # BooleanLiteral
    ;



ifStatement
    : IF expression block (ELSE_IF expression block)* (ELSE block)?
    ;


// For Loops decloration
loop
    : FOR block                                                         # InfiniteLoop
    | FOR IDENTIFIER COMMA IDENTIFIER WALRUS expression block           # ForEachLoop
    | FOR forInit? SEMICOLON expression? SEMICOLON expression? block    # TraditionalForLoop
    ;

forInit
    : IDENTIFIER COLON types ASSIGN expression
    | IDENTIFIER ASSIGN expression
    ;



// Function Declarations
function
    : FUNC IDENTIFIER parameterList? (ARROW returnType)? block
    | IDENTIFIER (COLON types)? ARROW (expression | block)
    ;

block
    : LBRACE statement* RBRACE
    ;

parameterList
    : LPAREN (parameter (COMMA parameter)*)? RPAREN
    ;

parameter
    : IDENTIFIER COLON types
    ;

returnType
    : primitiveTypes
    | structuredTypes
    | EMP_TYPE
    | ANY
    ;


functionCall
    : IDENTIFIER LPAREN (expression (COMMA expression)*)? RPAREN
    ;


cast
    : IDENTIFIER AS (primitiveTypes | structuredTypes);


matchStatement
    : MATCH expression LBRACE
        caseBlock+
        defaultBlock?
      RBRACE
    ;

caseBlock
    : CASE expression COLON statement*
    ;

defaultBlock
    : DEFAULT COLON statement*
    ;


returnStatement
    : RETURN (expression | statement)
    ;


classPattern
    : CLASS IDENTIFIER LBRACE classBody RBRACE
    ;


classBody
    : .*?
    ;

// TYPE Definitions
types
    : primitiveTypes
    | structuredTypes
    | EMP_TYPE
    | CONST
    | ANY
    ;


primitiveTypes
    : INT_TYPE
    | STRING_TYPE
    | CHAR_TYPE
    | DECIMAL_TYPE
    | BOOL_TYPE
    ;

structuredTypes
    : LIST_TYPE
    | MAP_TYPE
    ;


// Logical Operators
AND: 'and' ;
OR: 'or' ;
NOT: 'not' | '!';

// Comparison Operators
EQ: '==' ;
NEQ: '!=' ;
GT: '>' ;
LT: '<' ;
GTE: '>=' ;
LTE: '<=' ;
IS: 'is' ;
ASSIGN: '=' ;
IS_NOT: 'is not' ;

// Punctuation
LPAREN: '(' ;
RPAREN: ')' ;
LBRACE: '{' ;
RBRACE: '}' ;
LBRACKET: '[' ;
RBRACKET: ']' ;
COMMA: ',' ;
COLON: ':' ;
SEMICOLON: ';' ;
ARROW: '->' ;
INC : '++';
DEC: '--';
ELLIPSIS: '...';

// Operators
MOD: '%' ;
SQUARE: '^';
PLUS: '+';
FLOOR_DIV: '//' ;
MINUS: '-';
DIVIDE: '/';
MULTIPLY: '*';
WALRUS: ':=' ;





// Keywords and Types
AS: 'as' ;
IF: 'if' ;
FOR: 'for' ;
LEN: 'len' ;
PASS: 'pass' ;
ELSE: 'else' ;
FUNC: 'func' ;
CASE: 'case' ;
LOCK: 'lock' ;  // use lock like private inside a class to make it inaccessable outside the class.
PRINT: 'print' ;
INPUT: 'input' ;
MATCH: 'match' ;
BREAK: 'break' ;
CLASS: 'class' ;
ELSE_IF: 'elif' ;
RETURN: 'return' ;
DEFAULT: 'default' ;
CONTINUE: 'continue' ;

INT_TYPE: 'int' | 'long' | 'short';
EMP_TYPE: 'emp' ;
STRING_TYPE: 'string' ;
CHAR_TYPE: 'char' ;
DECIMAL_TYPE: 'float' | 'double' ;
LIST_TYPE: 'list' ;
MAP_TYPE: 'map' ;
BOOL_TYPE: 'bool' ;
CONST: 'const' ;
ANY: 'any';

// VALUE Definitions


fragment DIGIT: [0-9] ;

fragment ESCAPE_SEQUENCE:
    '\\\''
    | '\\"'
    | '\\\\'
    | '\\n'
    | '\\r'
    | '\\' ('\r' '\n'? | '\n')
;

fragment False : 'false' ;
fragment True: 'true' ;

// Identifiers and Literals
INTEGER: DIGIT+ ;
REAL: DIGIT+ '.' DIGIT+ ;
BOOLEAN: True | False;
IDENTIFIER: [a-zA-Z_][a-zA-Z0-9_]* ;
STRING: '"' (~["\r\n] | ESCAPE_SEQUENCE)* '"' ;
CHARACTER: '\'' (~['\r\n] | ESCAPE_SEQUENCE) '\'' ;

// Skipping Whitespaces and Comments
WHITESPACE: [ \t\r\n]+ -> skip ;
LINE_COMMENT: '#' ~[\r\n]* -> skip ;
BLOCK_COMMENT: '/*' .*? '*/' -> skip;
ERRCHAR: . ;