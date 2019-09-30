"
I represent a abstract grammar.

Public API and Key Messages

- booleanValue
- comma
- comment
- commentChar
- digit
- escapedCharacter 
- escapedUnicode 
- exponentIndicator 
- exponentPart 
- floatValue 
- fractionalPart 
-ignored 
- insignificantToken 
- intValue 
- integerPart 
- lineTerminator 
- nonZeroDigit 
- punctuator 
- sign 
- sourceCharacter 
- start
- stringCharacter 
- stringDelimiter 
- stringValue 
- token
- tokenName
- unicodeBOM
- whiteSpace 
"
Class {
	#name : #GQLAbstractGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'sourceCharacter',
		'unicodeBOM',
		'whiteSpace',
		'lineTerminator',
		'commentChar',
		'comment',
		'comma',
		'token',
		'punctuator',
		'tokenName',
		'intValue',
		'floatValue',
		'stringValue',
		'integerPart',
		'nonZeroDigit',
		'digit',
		'fractionalPart',
		'exponentPart',
		'exponentIndicator',
		'sign',
		'stringDelimiter',
		'stringCharacter',
		'escapedUnicode',
		'escapedCharacter',
		'ignored',
		'booleanValue',
		'insignificantToken',
		'intType',
		'floatType',
		'scalarType',
		'stringType',
		'booleanType',
		'idType',
		'comments',
		'insignificantTokenNoComment',
		'ignoredNoComment'
	],
	#category : #'GraphQLBeta-Parser'
}

{ #category : #accessing }
GQLAbstractGrammar >> booleanType [
	"Return a token of a parser accepting Boolean"

	^ ('Boolean' asParser , #word asParser not , $_ asParser not) token
]

{ #category : #grammar }
GQLAbstractGrammar >> booleanValue [
	"Return a token accepting true or false"

	^ ('true' asParser / 'false' asParser)
		flatten token
]

{ #category : #grammar }
GQLAbstractGrammar >> comma [
	"Return a parser accepting the comma"

	^ $, asParser
]

{ #category : #grammar }
GQLAbstractGrammar >> comment [
	"Return a parser accepting the char # followed by a parser accepting the list of comment chars"

	^ ($# asParser , commentChar star) flatten token.
]

{ #category : #grammar }
GQLAbstractGrammar >> commentChar [
	"Return a parser that succes when fails accepting the newline and followed by a parser accepting the sourceCharacter"

	^ #newline asParser not , sourceCharacter
]

{ #category : #grammar }
GQLAbstractGrammar >> comments [
	"Return a parser accepting the list of comment"
	^ (comment trim: ignoredNoComment) star
]

{ #category : #grammar }
GQLAbstractGrammar >> digit [
"Return a parser accepting a digit"
	^ #digit asParser
]

{ #category : #grammar }
GQLAbstractGrammar >> escapedCharacter [
	"Return a parser accepting all the characters associated with a escape, like: \t \r"

	^ $" asParser / $\ asParser / $/ asParser
		/ $b asParser / $f asParser / $n asParser
		/ $r asParser / $t asParser
]

{ #category : #grammar }
GQLAbstractGrammar >> escapedUnicode [
"Return a parser accepting word four times"
	^ #word asParser times: 4
]

{ #category : #grammar }
GQLAbstractGrammar >> exponentIndicator [
"Return a parser accepting the char e or the char E"
	^ $e asParser / $E asParser
]

{ #category : #grammar }
GQLAbstractGrammar >> exponentPart [
	"Return a parser accepting a exponentIndicator follow by a parser accepting a optional sign follow by a parser accepting a list of digits"

	^ exponentIndicator , sign optional
		, digit plus
]

{ #category : #accessing }
GQLAbstractGrammar >> floatType [
"Return a token of parser Float"
	^ ('Float' asParser , #word asParser not , $_ asParser not) token
]

{ #category : #grammar }
GQLAbstractGrammar >> floatValue [
	"Return a parser accepting:
	- integerPart fractionalPart exponentPart
	- integerPart fractionalPart
	- integerPart exponentPart"

	^ (integerPart , fractionalPart
		, exponentPart) flatten token
		/
			(integerPart , fractionalPart) flatten token
		/ (integerPart , exponentPart) flatten token
	"^ integerPart , ((fractionalPart , exponentPart) / fractionalPart / exponentPart )"
]

{ #category : #grammar }
GQLAbstractGrammar >> fractionalPart [
"Return a parser accepting . followed by a parser accepting one or more digits"
	^ $. asParser , digit plus
]

{ #category : #accessing }
GQLAbstractGrammar >> idType [
"Return a token of parser ID"
		^ ('ID' asParser , #word asParser not , $_ asParser not) token
]

{ #category : #grammar }
GQLAbstractGrammar >> ignored [
	"Return the parsers accepting the list of things we want to ignore"

	^ comment / lineTerminator / unicodeBOM
		/ whiteSpace / comma
]

{ #category : #grammar }
GQLAbstractGrammar >> ignoredNoComment [
	"Return the parsers accepting the list of things we want to ignore but no comment"

	^ lineTerminator / unicodeBOM
		/ whiteSpace / comma
]

{ #category : #grammar }
GQLAbstractGrammar >> insignificantToken [
	"Return a parser accepting the list of insignificant token"

	^ whiteSpace / comment / lineTerminator
]

{ #category : #grammar }
GQLAbstractGrammar >> insignificantTokenNoComment [
	"Return a parser accepting the list of insignificant token no comment"

	^ whiteSpace / lineTerminator
]

{ #category : #accessing }
GQLAbstractGrammar >> intType [
"Return a token of parse Int"
	^ ('Int' asParser , #word asParser not , $_ asParser not) token
]

{ #category : #grammar }
GQLAbstractGrammar >> intValue [
	"Return a token representing the integerPart"

	^ integerPart flatten token
]

{ #category : #grammar }
GQLAbstractGrammar >> integerPart [
	"Return a parser accepting:
	- sign optional 0
	- sign optional nonZero digitList"

	^ sign optional
		, ($0 asParser / (nonZeroDigit , digit star))
]

{ #category : #grammar }
GQLAbstractGrammar >> lineTerminator [ 
	"New Line (U+000A)
	Carriage Return (U+000D)New Line (U+000A)
	Carriage Return (U+000D)New Line (U+000A)"
	^ #newline asParser 
]

{ #category : #grammar }
GQLAbstractGrammar >> nonZeroDigit [
	"Return a parser that succes when fails accepting the $0 and followed by a parser accepting the digit"

	^ $0 asParser not , digit
]

{ #category : #accessing }
GQLAbstractGrammar >> nullValue [
"Return a token of parsing: null"
	^ 'null' asParser token
]

{ #category : #grammar }
GQLAbstractGrammar >> punctuator [
"Return a parser accepting one of
! $ ( ) ... : = @ [ ] { | }"
	^ $! asParser / $$ asParser / $( asParser
		/ $) asParser / '...' asParser
		/ $: asParser / $= asParser
		/ $@ asParser / $[ asParser
		/ $] asParser / ${ asParser
		/ $| asParser / $} asParser
]

{ #category : #accessing }
GQLAbstractGrammar >> scalarType [
"Return a parser accepting:
intType
floatType
stringType
booleanType
idType"
	^ intType / floatType / stringType / booleanType / idType
]

{ #category : #grammar }
GQLAbstractGrammar >> sign [
	"Return a parser accepting the char + or -"

	^ $+ asParser / $- asParser
]

{ #category : #grammar }
GQLAbstractGrammar >> sourceCharacter [
	"/[\u0009\u000A\u000D\u0020-\uFFFF]/ "
	^ #any asParser
]

{ #category : #grammar }
GQLAbstractGrammar >> start [
	"Return a parser accepting the sourceCharacter and success at the end of the input"

	^ sourceCharacter end
]

{ #category : #grammar }
GQLAbstractGrammar >> stringCharacter [
	"Return a parser accepting:
	- SourceCharacter but not stringDelimiter or  \
	- \u escapedUnicode
	- \ escapedCharacter"

	^ (stringDelimiter not , $\ asParser not
		, sourceCharacter)
		/ ('\u' asParser , escapedUnicode)
		/ ('\' asParser , escapedCharacter)
]

{ #category : #grammar }
GQLAbstractGrammar >> stringDelimiter [
	"Return a parser accepting the quotation symbol"

	^ $" asParser
]

{ #category : #accessing }
GQLAbstractGrammar >> stringType [
"Return a token of parse String"
	^ ('String' asParser , #word asParser not , $_ asParser not) token
]

{ #category : #grammar }
GQLAbstractGrammar >> stringValue [
	"Return a parser accepting a string delimited by quotation symbol"

	^ (stringDelimiter , stringCharacter star
		, stringDelimiter) flatten token 
]

{ #category : #grammar }
GQLAbstractGrammar >> token [
	"Return the parser that accepts the lexical tokens: a punctuator or tokename or float value or int value or string value"

	^ punctuator / tokenName / floatValue
		/ intValue / stringValue
]

{ #category : #grammar }
GQLAbstractGrammar >> tokenName [
	"Return a parser accepting:
 _ letter
 _ wordList"

	^ ($_ asParser / #letter asParser
		, ($_ asParser / #word asParser) star)
		flatten token
]

{ #category : #grammar }
GQLAbstractGrammar >> unicodeBOM [
	"Byte Order Mark (U+FEFF)"
	^ 'U+FEFF' asParser  
]

{ #category : #grammar }
GQLAbstractGrammar >> whiteSpace [
	"Horizontal Tab (U+0009)
	 Space (U+0020)"
	^ #blank asParser
]
