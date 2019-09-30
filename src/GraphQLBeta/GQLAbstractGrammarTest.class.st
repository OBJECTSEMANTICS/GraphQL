"
A GQLAbstractGrammarTest is a test class for testing the behavior of GQLAbstractGrammar
"
Class {
	#name : #GQLAbstractGrammarTest,
	#superclass : #PPCompositeParserTest,
	#category : #'GraphQLBeta-Tests-Grammar'
}

{ #category : #accessing }
GQLAbstractGrammarTest >> parserClass [
	^ GQLAbstractGrammar 
]

{ #category : #tests }
GQLAbstractGrammarTest >> testBooleanValue [

	"boolean value"
	self parse: 'true' rule: #booleanValue.
	self parse: 'false' rule: #booleanValue.
	self fail: 'anyOtherValue' rule: #booleanValue.
	self fail: '1' rule: #booleanValue.
	self fail: '0' rule: #booleanValue.


]

{ #category : #tests }
GQLAbstractGrammarTest >> testComma [

	"comma"
	self parse: ',' rule: #comma.
	self fail: 'any other text' rule: #comma.
]

{ #category : #tests }
GQLAbstractGrammarTest >> testComment [

	self parse: '#some comment' rule: #comment.
	self parse: '###' rule: #comment.
	self fail: '#dsfd

' rule: #comment.
	self fail: 'asdf' rule: #comment.
	self fail: ' ' rule: #comment.

]

{ #category : #tests }
GQLAbstractGrammarTest >> testCommentChar [

"	self parse: '###' rule: #commentChar."
	self parse: 's' rule: #commentChar.
	 '+_)(*&^%$#@!~.}{:"?><|\][;. 		' do: [ :each | self parse: each asString rule:  #commentChar ].
	self fail: ' 
	' rule: #commentChar
]

{ #category : #tests }
GQLAbstractGrammarTest >> testFloatValue [

	"float value"
	self parse: '2312.12' rule: #floatValue.
	self parse: '-123.23e12' rule: #floatValue.
	self parse: '-123.23E12' rule: #floatValue.
	self fail: '12' rule: #floatValue.
	self fail: 'a123' rule: #floatValue.
	self fail: '123.123a' rule: #floatValue.

]

{ #category : #tests }
GQLAbstractGrammarTest >> testIgnored [

	"UnicodeBOM"
	"self parse: '""' rule: #ignored."
	"self fail: '""any other text but " "' rule: #ignored."

	"Whitespace"
	self parse: ' ' rule: #ignored.
	self parse: '	' rule: #ignored.

	"LineTerminator"
	self parse: '
' rule: #ignored.

	"Comment"
	self parse: '#some comment' rule: #ignored.
	self parse: '###' rule: #ignored.

	"comma"
	self parse: ',' rule: #ignored.
]

{ #category : #tests }
GQLAbstractGrammarTest >> testInsignificantToken [
	
	'	 
		' do: [ :each | self parse: each asString rule:  #insignificantToken ].
]

{ #category : #tests }
GQLAbstractGrammarTest >> testIntValue [

	"int value"
	self parse: '2312' rule: #intValue.
	self parse: '-123' rule: #intValue.
	self parse: '+444' rule: #intValue.
	self fail: '123.123' rule: #intValue.
	self fail: '123.123e12' rule: #intValue.

]

{ #category : #tests }
GQLAbstractGrammarTest >> testLineTerminator [

	"LineTerminator"
	self parse: '
' rule: #lineTerminator.
	self fail: ' ' rule: #lineTerminator.


]

{ #category : #tests }
GQLAbstractGrammarTest >> testNonZeroDigit [

	self parse: '1' rule: #nonZeroDigit.
	self fail: '0' rule: #nonZeroDigit.

]

{ #category : #tests }
GQLAbstractGrammarTest >> testPunctuator [

	"punctuator"
	self parse: '{' rule: #punctuator.
	self parse: '}' rule: #punctuator.
	self parse: '...' rule: #punctuator.
	self parse: '[' rule: #punctuator.
	self parse: ']' rule: #punctuator.
	self parse: '!' rule: #punctuator.
	self parse: '$' rule: #punctuator.
	self parse: '|' rule: #punctuator.
	self parse: ':' rule: #punctuator.
	self parse: '@' rule: #punctuator.
	self parse: '=' rule: #punctuator.

	self fail: 'any other character' rule: #punctuator.


]

{ #category : #tests }
GQLAbstractGrammarTest >> testStringValue [

	"string value"
	self parse: '""' rule: #stringValue.
	self parse: '"any other kind of text +_)(*&^%$#@ |}{:?><][/;.,"' rule: #stringValue.
	self parse: '"\u00f3 \\ \/ \b \f \n \r \t"' rule: #stringValue.
	self fail: '"any other text but " "' rule: #stringValue.

]

{ #category : #tests }
GQLAbstractGrammarTest >> testToken [

	"punctuator"
	self parse: '{' rule: #punctuator.
	self parse: '}' rule: #punctuator.
	self parse: '...' rule: #punctuator.
	self parse: '[' rule: #punctuator.
	self parse: ']' rule: #punctuator.
	self parse: '!' rule: #punctuator.
	self parse: '$' rule: #punctuator.
	self parse: '|' rule: #punctuator.
	self parse: ':' rule: #punctuator.
	self parse: '@' rule: #punctuator.
	self parse: '=' rule: #punctuator.

	"names"
	self parse: '_Name23' rule: #token.
	self parse: 'some_Name' rule: #token.
	self parse: 'S' rule: #token.
	self parse: '_' rule: #token.

	"int value"
	self parse: '2312' rule: #token.
	self parse: '-123' rule: #token.
	self parse: '+444' rule: #token.

	"float value"
	self parse: '2312.12' rule: #token.
	self parse: '-123.23e12' rule: #token.
	self parse: '-123.23E12' rule: #token.

	"boolean value"
	self parse: 'true' rule: #token.
	self parse: 'false' rule: #token.

	"string value"
	self parse: '""' rule: #token.
	self parse: '"any other kind of text +_)(*&^%$#@ |}{:?><][/;.,"' rule: #token.
	self parse: '"\u00f3 \\ \/ \b \f \n \r \t"' rule: #token.

]

{ #category : #tests }
GQLAbstractGrammarTest >> testTokenName [

	"names"
	self parse: '_Name23' rule: #tokenName.
	self parse: 'some_Name' rule: #tokenName.
	self parse: 'S' rule: #tokenName.
	self parse: '_' rule: #tokenName.
	self fail: '' rule: #tokenName.
	self fail: ' someName' rule: #tokenName.

]

{ #category : #tests }
GQLAbstractGrammarTest >> testWhiteSpace [

	"WhiteSpace"
	self parse: ' ' rule: #whiteSpace.
	self parse: '	' rule: #whiteSpace.
	self fail: 'any other text but  ' rule: #whiteSpace.


]
