Class {
	#name : #GQLRequestGrammarEvaluatorTest,
	#superclass : #GQLTest,
	#category : #'GraphQLBeta-Tests-Grammar'
}

{ #category : #'as yet unclassified' }
GQLRequestGrammarEvaluatorTest >> requestEvaluator [

	^ GQLRequestGrammarEvaluator
]

{ #category : #'test-grammar-values' }
GQLRequestGrammarEvaluatorTest >> testArgumentsCompositeObjectValue [
	| document field values objectField |
	document := self parseRequest: '{
  				nearestThing(countries: [{ name: "Bolivia" , continent: "America" } , 
												{ name : "Chile" , continent: "America"}])
	}'.
	self assert: document class: GQLDocumentNode.
	field := document operations first selections first.
	self assert: field name: 'nearestThing'.
	self assert: field arguments size equals: 1.
	self assertArguments: field withNames: #('countries').
	self assertArguments: field ofClasses: #('GQLListNode').
	values := field arguments first value value.
	self assertList: values class: GQLObjectNode.
	objectField := values first.
	self assertObjectField: objectField withNames: #('name' 'continent').
	self assertObjectField: objectField withValues: #('"Bolivia"' '"America"').
	objectField := values second.
	self assertObjectField: objectField withNames: #('name' 'continent').
	self assertObjectField: objectField withValues: #('"Chile"' '"America"').
]

{ #category : #'test-grammar-values' }
GQLRequestGrammarEvaluatorTest >> testArgumentsEnumValue [
	| document filmsField |
	document := self parseRequest:  '{
				films(ofGender: FavoriteGender){
					rating
					name
				}
			}'.
	self assert: document class: GQLDocumentNode.
	filmsField := document operations first selections first.
	self assert: filmsField name: 'films'.
	self assert: filmsField arguments size equals: 1.
	self assertArguments: filmsField withNames: #('ofGender').
	self assertArguments: filmsField ofClasses: #('GQLEnumNode').
	self assertArguments: filmsField withValues: #('FavoriteGender'). 
]

{ #category : #'test-grammar-values' }
GQLRequestGrammarEvaluatorTest >> testArgumentsListScalarValue [
	| document filmsField argument valueArgument |
	document := self parseRequest:  '{
				films(inYears: [ 2016, 2012, 2000], withActors: [ "Adam Sandler", "Cris Rock" ]){
					rating
					name
				}
			}'.
	self assert: document class: GQLDocumentNode.
	filmsField := document operations first selections first.
	self assert: filmsField name: 'films'.
	self assert: filmsField arguments size equals: 2.
	self assertArguments: filmsField withNames: #('inYears' 'withActors').
	self assertArguments: filmsField ofClasses: #('GQLListNode' 'GQLListNode').
	argument := filmsField arguments first.
	valueArgument := argument value value.
	self assertList: valueArgument class: GQLIntNode.
	self assertList: valueArgument withValues: #('2016' '2012' '2000').
	argument := filmsField arguments second.
	valueArgument := argument value value.
	self assertList: valueArgument class: GQLStringNode.
	self assertList: valueArgument withValues: #('"Adam Sandler"' '"Cris Rock"').
]

{ #category : #'test-grammar-values' }
GQLRequestGrammarEvaluatorTest >> testArgumentsNullValue [
	| document filmsField |
	document := self parseRequest: '{
				films(inYear: 2016, visual: null){
					rating
					name
				}
			}'.
	self assert: document class: GQLDocumentNode.
	filmsField := document operations first selections first.
	self assert: filmsField name: 'films'.
	self assert: filmsField arguments size equals: 2.
	self assertArguments: filmsField withNames: #('inYear' 'visual').
	self assertArguments: filmsField ofClasses: #('GQLIntNode' 'GQLNullNode').
	self assertArguments: filmsField withValues: #('2016' 'null').
	self assertSelections: filmsField withNames: #('rating' 'name').
]

{ #category : #'test-grammar-values' }
GQLRequestGrammarEvaluatorTest >> testArgumentsObjectValue [
	| document field objectValue |
	document := self parseRequest:  '{
  				nearestThing(location: { lon: 12.43, lat: -53.211 })
	}'.
	self assert: document class: GQLDocumentNode.
	field := document operations first selections first.
	self assert: field name: 'nearestThing'.
	self assert: field arguments size equals: 1.
	self assert: field arguments first name: 'location'.
	objectValue := field arguments first value.
	self assert: objectValue class: GQLObjectNode.
	self assertList: objectValue objectFields class: GQLObjectFieldNode.
	self assertObjectField: objectValue withNames: #('lon' 'lat').
	self assertObjectField: objectValue withValues: #('12.43' '-53.211').
]

{ #category : #'test-grammar-values' }
GQLRequestGrammarEvaluatorTest >> testArgumentsSimpleScalarValue [
	| document filmsField actorsField|
	document := self parseRequest:  '{
				films(inYear: 2016, minorRating: 5.5){
					rating
				}
				actors(inMovie : "Star wars", active : true){
					name
				}
			}'.
	self assert: document class: GQLDocumentNode.
	filmsField := document operations first selections first.
	self assert: filmsField name: 'films'.
	self assert: filmsField arguments size equals: 2.
	self assertArguments: filmsField withNames: #('inYear' 'minorRating').
	self assertArguments: filmsField ofClasses: #('GQLIntNode' 'GQLFloatNode').
	self assertArguments: filmsField withValues: #('2016' '5.5').

	actorsField := document operations first selections second.
	self assert: actorsField name: 'actors'.
	self assert: actorsField arguments size equals: 2.
	self assertArguments: actorsField withNames: #('inMovie' 'active').
	self assertArguments: actorsField ofClasses: #('GQLStringNode' 'GQLBooleanNode').
	self assertArguments: actorsField withValues: #('"Star wars"' 'true').
]

{ #category : #'test-grammar-values' }
GQLRequestGrammarEvaluatorTest >> testArgumentsVariableValue [
	| document filmsField |
	document := self parseRequest:  '{
				films(inYears: $years withActors: $actors){
					rating
					name
				}
			}'.
	self assert: document class: GQLDocumentNode.
	filmsField := document operations first selections first.
	self assert: filmsField name: 'films'.
	self assert: filmsField arguments size equals: 2.
	self assertArguments: filmsField withNames: #('inYears' 'withActors').
	self assertArguments: filmsField ofClasses: #('GQLVariableNode' 'GQLVariableNode').
	self assertArguments: filmsField withValues: #('years' 'actors').
]

{ #category : #'test-grammar-comment' }
GQLRequestGrammarEvaluatorTest >> testComment [
	| document node |
	document := self parseRequest: '{
  		#field hello
		helloAt: hello #returns a String
	}'.
	self assert: document class: GQLDocumentNode.
	node := document operations first selections first.
	self assert: node alias = 'helloAt'.
	self assertComments: node comments equals: #('#field hello' '#returns a String').
	
	document := self parseRequest: '{
		#field hello
		hello #skip directive 
		@skip(if : true)
	}'.
	self assert: document class: GQLDocumentNode.
	node := document operations first selections first.
	self assert: node class: GQLScalarFieldNode.
	self assertComments: node comments equals: #('#field hello').
	
	document := self parseRequest: '{
		hello #include directive 
		@include(if : true)
	}'.
	self assert: document class: GQLDocumentNode.
	node := document operations first selections first.
	self assert: node comments isEmpty.
	
	document := self parseRequest: '{
		#field helloTo
		helloTo(name: "Alex") #returns a String
	}'.
	self assert: document class: GQLDocumentNode.
	node := document operations first selections first.
	self assertComments: node comments equals: #( '#field helloTo' '#returns a String').
	
	document := self parseRequest: '
		mutation #comment of mutation
		pointCreation($x : #of type int
		Int) {
		createPoint(x: $x, y: 2){
			x y
		}
		}'.
	self assert: document class: GQLDocumentNode.
	node := document operations first comments isEmpty.
	
	document := self parseRequest: '{
		classification(gender: #enum type
		ACTION)
	}'.
	self assert: document class: GQLDocumentNode.
	node := document operations first.
	self assert: node comments isEmpty.
]

{ #category : #'test-grammar-comment' }
GQLRequestGrammarEvaluatorTest >> testCommentInVariables [
	| document |
	document := self parseRequest: '{
		{"name": #comment incorrect
		"Mary"}
	}'.
	self assert: document class: PPFailure.
]

{ #category : #'test-grammar-fields' }
GQLRequestGrammarEvaluatorTest >> testFieldsAlias [
	| document userField subField |
	document := self parseRequest: '{
  				user(id: 4) {
    					name
    					smallPic: profilePic(size: 64)
    					bigPic: profilePic(size: 1024)
  			}
		}'.
	self assert: document class: GQLDocumentNode.
	userField := document operations first selections first.
	self assert: userField class: GQLNonScalarFieldNode.
	self assert: userField name: 'user'.
	self assert: userField arguments first name: 'id'.
	self assertSelections: userField withNames: #('name' 'profilePic' 'profilePic').
	subField := userField selectionSet selections second.
	self assert: subField alias equals: 'smallPic'.
	self assertArguments: subField withValues: #('64').
	subField := userField selectionSet selections third.
	self assert: subField alias equals: 'bigPic'.
	self assertArguments: subField withValues: #('1024').
	
]

{ #category : #'test-grammar-fields' }
GQLRequestGrammarEvaluatorTest >> testFieldsIncomplete [
	| document  |
	document := self parseRequest: '{
  				user(id: 4) {
    					name
    					bigPic: profilePic(size: 1024)
  			
		}'.
	self assert: document class: PPFailure.
	
	document := self parseRequest: '{
  				user(id: 4) {
    					name
    					bigPic: profilePic(size: )
  				}
		}'.
	self assert: document class equals: PPFailure.
	
	document := self parseRequest: 'query myQuery {
  				experimentalField @skip(if: )
			}'.
	self assert: document class equals: PPFailure.
]

{ #category : #'test-grammar-fields' }
GQLRequestGrammarEvaluatorTest >> testFieldsWithArguments [
	| document filmsField actorsField |
	document := self parseRequest: '{
				films(inYear: 2016){
					rating
				}
				actors(inMovie : "Star wars", active : true){
					name
				}
			}'.
	self assert: document class: GQLDocumentNode.
	self assertList: document operations first selections class: GQLNonScalarFieldNode.
	filmsField := document operations first selections first.
	self assert: filmsField name: 'films'.
	self assert: filmsField arguments size equals: 1.
	self assertArguments: filmsField withNames: #('inYear').
	self assertArguments: filmsField ofClasses: #('GQLIntNode').
	self assertArguments: filmsField withValues: #('2016').
	self assertSelections: filmsField withNames: #('rating').
	
	actorsField := document operations first selections second.
	self assert: actorsField name: 'actors'.
	self assert: actorsField arguments size equals: 2.
	self assertArguments: actorsField withNames: #('inMovie' 'active'). 
	self assertArguments: actorsField ofClasses: #('GQLStringNode' 'GQLBooleanNode'). 
	self assertArguments: actorsField withValues: #('"Star wars"' 'true').
]

{ #category : #'test-grammar-fields' }
GQLRequestGrammarEvaluatorTest >> testFieldsWithDirectives [
	| document operation field variable directive |
	document := self parseRequest: 'query myQuery($someTest: Boolean) {
  				experimentalField @skip(if: $someTest)
			}'.
	self assert: document class: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class: GQLOperationNode.
	self assert: operation name: 'myQuery'.
	self assert: operation type: 'query'.
	variable := operation variableDefinitions first.
	self assert: variable name class: ByteString.
	self assert: variable name value equals: 'someTest'.
	self assert: variable type class: GQLSBooleanTypeNode.
	field := operation selectionSet selections first.
	self assert: field class: GQLScalarFieldNode.
	self assert: field name: 'experimentalField'.
	directive := field directives first.
	self assert: directive name equals: 'skip'.
	self assert: directive arguments size equals: 1.
	self assertArguments: directive withNames: #('if').
	self assertArguments: directive ofClasses: #('GQLVariableNode').
	self assertArguments: directive withValues: #('someTest').
	
]

{ #category : #'test-grammar-fragment' }
GQLRequestGrammarEvaluatorTest >> testFragment [
	| document withFragment fragment fieldSpread field |
	document := self parseRequest: 'query withFragment {
      			...friendFields
			}
			fragment friendFields on User {
 				name
 				profilePic(size: 50)
	}'.
	
	self assert: document class: GQLDocumentNode.
	withFragment := document operations first.
	self assert: withFragment class: GQLOperationNode.
	self assert: withFragment type: 'query'.
	self assert: withFragment name: 'withFragment'.
	fieldSpread := withFragment selectionSet selections first.
	self assert: fieldSpread class: GQLFragmentSpreadNode.
	self assert: fieldSpread name: 'friendFields'.
	
	fragment := document fragments first.
	self assert: fragment class: GQLFragmentNode.
	self assert: fragment name: 'friendFields'.
	self assert: fragment typeCondition class: GQLSNamedTypeNode.
	self assert: fragment typeCondition name: 'User'.
	self assertSelections: fragment withNames: #('name' 'profilePic').
	
	field := fragment selectionSet selections second.
	self assertArguments: field withNames: #('size').
	self assertArguments: field ofClasses: #('GQLIntNode').
	self assertArguments: field withValues: #('50').
	
]

{ #category : #'test-grammar-fragment' }
GQLRequestGrammarEvaluatorTest >> testFragmentIncorrect [
	| document |
	document := self parseRequest: 'query withFragment {
      			...friendFields
			}
			fragment on User {
 				name
 				profilePic(size: 50)
	}'.
	self assert: document class: PPFailure.
	
	document := self parseRequest: 'query withFragment {
      			...friendFields
			}
			fragment friendFields {
 				name
 				profilePic(size: 50)
	}'.
	self assert: document class: PPFailure.
	
	document := self parseRequest: 'query withFragment {
      			...friendFields
			}
			fragment friendFields on User {
	}'.
	
	self assert: document class: PPFailure.
	
]

{ #category : #'test-grammar-fragmentSpread' }
GQLRequestGrammarEvaluatorTest >> testFragmentSpread [
	| document nestedFragments firstSubSelection secondFragment |
	document := self parseRequest: 'query withNestedFragments {
  				user(id: 4) {
    					...familiarFields
    					mutualFriends(first: 10) {
      					...friendFields
    					}
  				}
	}'.
	self assert: document class: GQLDocumentNode.
	nestedFragments := document operations first.
	self assert: nestedFragments class: GQLOperationNode.
	self assert: nestedFragments type: 'query'.
	self assert: nestedFragments name: 'withNestedFragments'.
	
	firstSubSelection := nestedFragments selectionSet selections first.
	self assert: firstSubSelection class: GQLNonScalarFieldNode.
	self assert: firstSubSelection name: 'user'.
	self assertArguments: firstSubSelection withNames: #('id').
	self assertArguments: firstSubSelection ofClasses: #('GQLIntNode').
	self assertArguments: firstSubSelection withValues: #('4'). 
	self assertSelections: firstSubSelection withNames: #('familiarFields' 'mutualFriends').
	
	secondFragment := firstSubSelection selectionSet selections second.
	self assertSelections: secondFragment withNames: #('friendFields').
	
]

{ #category : #'test-grammar-fragmentSpread' }
GQLRequestGrammarEvaluatorTest >> testFragmentSpreadIncorrect [
	| text document |
	document := self parseRequest: 'query withNestedFragments {
  				user(id: 4) {
    					...familiarFields @skip(if: $someTest){
						user
					}
  				}
	}'.
	self assert: document class: PPFailure.
	
	document := self parseRequest: 'query withNestedFragments {
  				user(id: 4) {
    					...familiarFields @skip(if: $someTest){
					}
  				}
	}'.
	self assert: document class: PPFailure.
	
	document := self parseRequest: 'query withNestedFragments {
  				user(id: 4) {
    					...familiarFields{
						name
					}
  				}
	}'.
	self assert: document class: PPFailure.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testFragmentSpreadWithDirectives [
	| document nestedFragments firstSubSelection firstFragment directive |
	document := self parseRequest: 'query withNestedFragments {
  				user(id: 4) {
    					...familiarFields @skip(if: $someTest)
  				}
	}'.
	self assert: document class: GQLDocumentNode.
	nestedFragments := document operations first.
	self assert: nestedFragments class: GQLOperationNode.
	self assert: nestedFragments type: 'query'.
	self assert: nestedFragments name: 'withNestedFragments'.
	
	firstSubSelection := nestedFragments selectionSet selections first.
	self assert: firstSubSelection class: GQLNonScalarFieldNode.
	self assert: firstSubSelection name: 'user'.
	self assertArguments: firstSubSelection withNames: #('id').
	self assertArguments: firstSubSelection ofClasses: #('GQLIntNode').
	self assertArguments: firstSubSelection withValues: #('4').
	
	firstFragment := firstSubSelection selectionSet selections first.
	self assert: firstFragment name: 'familiarFields'.
	directive := firstFragment directives first.
	self assert: directive name: 'skip'.
	self assertArguments: directive withNames: #('if').
	self assertArguments: directive withValues: #('someTest').
]

{ #category : #'test-grammar-fragment' }
GQLRequestGrammarEvaluatorTest >> testFragmentWithDirectives [
	| text document withFragment fragment |
	text := 'query withFragment {
      			...friends
			}
			fragment friends on User @directiveBehavior {
 				id
	}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	withFragment := document operations first.
	self assert: withFragment class equals: GQLOperationNode.
	self assert: withFragment type equals: 'query'.
	self assert: withFragment name equals: 'withFragment'.
	self assert: withFragment selectionSet selections first class equals: GQLFragmentSpreadNode.
	self assert: withFragment selectionSet selections first name equals: 'friends'.
	
	fragment := document fragments first.
	self assert: fragment class equals: GQLFragmentNode.
	self assert: fragment name equals: 'friends'.
	self assert: fragment typeCondition class equals: GQLSNamedTypeNode.
	self assert: fragment typeCondition name equals: 'User'.
	self assert: fragment directives first name equals: 'directiveBehavior'.
	self assert: fragment selectionSet selections first name equals: 'id'.
	
]

{ #category : #'test-grammar-inlineFragment' }
GQLRequestGrammarEvaluatorTest >> testInlineFragmentIncomplete [
	| text document |
	text := 'query inlineFragmentNoType($expandedInfo: Boolean) {
    					... @include(if: ) {
      					firstName
      					birthday
    					}
	}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: PPFailure.
	
	text := 'query inlineFragmentNoType($expandedInfo: Boolean) {
    					.. on User {
      					firstName
      					birthday
    					}
	}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: PPFailure.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testInlineFragmentWithDirectives [
	| text document inlineFragmentTyping firstSubSelection firstFragment  |
	text := 'query inlineFragmentNoType($expandedInfo: Boolean) {
  				user(handle: "zuck") {
    					id
    					... @include(if: $expandedInfo) {
      					firstName
    					}
  				}
	}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	inlineFragmentTyping := document operations first.
	self assert: inlineFragmentTyping class equals: GQLOperationNode.
	self assert: inlineFragmentTyping type equals: 'query'.
	self assert: inlineFragmentTyping name equals: 'inlineFragmentNoType'.
	self assert: inlineFragmentTyping variableDefinitions first type class equals: GQLSBooleanTypeNode.
	self assert: inlineFragmentTyping variableDefinitions first name value equals: 'expandedInfo'.
	
	firstSubSelection := inlineFragmentTyping selectionSet selections first.
	self assert: firstSubSelection class equals: GQLNonScalarFieldNode.
	self assert: firstSubSelection name equals: 'user'.
	self assert: firstSubSelection arguments first name equals: 'handle'.
	self assert: firstSubSelection arguments first value class equals: GQLStringNode.
	self assert: firstSubSelection arguments first value value equals: '"zuck"'. 
	
	firstFragment := firstSubSelection selectionSet selections second.
	self assert: firstFragment directives first name equals: 'include'.
	self assert: firstFragment directives first arguments first name equals: 'if'.
	self assert: firstFragment directives first arguments first value class equals: GQLVariableNode.
	self assert: firstFragment directives first arguments first value value equals: 'expandedInfo'.
	self assert: firstFragment selectionSet selections first name equals: 'firstName'.
	
]

{ #category : #'test-grammar-inlineFragment' }
GQLRequestGrammarEvaluatorTest >> testInlineFragmentWithTypeCondition [
	| text document inlineFragmentTyping firstSubSelection firstFragment secondFragment |
	text := 'query inlineFragmentTyping {
  				profiles(handles: ["zuck", "cocacola"]) {
   					handle
    					... on User {
      					friends {
        						count
      					}
    					}
    					... on Page {
      					likers {
        						count
      					}
    					}
  				}
			}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	inlineFragmentTyping := document operations first.
	self assert: inlineFragmentTyping class equals: GQLOperationNode.
	self assert: inlineFragmentTyping type equals: 'query'.
	self assert: inlineFragmentTyping name equals: 'inlineFragmentTyping'.
	
	firstSubSelection := inlineFragmentTyping selectionSet selections first selectionSet.
	self assert: firstSubSelection class equals: GQLSelectionSetNode.
	self assert: firstSubSelection selections first name equals: 'handle'.
	
	firstFragment := firstSubSelection selections second.
	self assert: firstFragment typeCondition class equals: GQLSNamedTypeNode.
	self assert: firstFragment typeCondition name equals: 'User'.
	self assert: firstFragment selectionSet selections first name equals: 'friends'.
	self assert: firstFragment selectionSet selections first selectionSet selections first name equals: 'count'.
	
	secondFragment := firstSubSelection selections third.
	self assert: secondFragment typeCondition class equals: GQLSNamedTypeNode.
	self assert: secondFragment typeCondition name equals: 'Page'.
	self assert: secondFragment selectionSet selections first name equals: 'likers'.
	self assert: secondFragment selectionSet selections first selectionSet selections first name equals: 'count'.
	
]

{ #category : #'test-grammar-operation' }
GQLRequestGrammarEvaluatorTest >> testOperationFail [
	| text document |
	text := 'mutation {
 				likeStory(storyID: 12345) {
 			 	story {
    				}
  			}
		}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: PPFailure.
	
	text := 'mutation {
 				likeStory(storyID: .12345) {
  			}
		}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: PPFailure.
	
	text := '{
 				likeStor(storyID: 12345) {
  			}
		}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: PPFailure.
]

{ #category : #'test-grammar-operation' }
GQLRequestGrammarEvaluatorTest >> testOperationMutation [
	| text document operation firstField subField |
	text := 'mutation {
 				likeStory(storyID: 12345) {
 			 	story {
      				likeCount
    				}
  			}
		}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation type equals: 'mutation'.
	firstField := operation selectionSet selections first.
	self assert: firstField class equals: GQLNonScalarFieldNode.
	self assert: firstField name equals: 'likeStory'.
	self assert: firstField arguments first name equals: 'storyID'.
	self assert: firstField arguments first value class equals: GQLIntNode.
	self assert: firstField arguments first value value equals: '12345'.
	subField := firstField selectionSet selections first.
	self assert: subField name equals: 'story'.
	self assert: subField selectionSet selections first name equals: 'likeCount'.
	
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testOperationWithDirective [
	| text document operation firstField |
	text := 'query @skip(if: $foo) {
 				 field
			}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation type equals: 'query'.
	self assert: operation directives first name equals: 'skip'.
	self assert: operation directives first arguments first name equals: 'if'.
	self assert: operation directives first arguments first value class equals: GQLVariableNode.
	self assert: operation directives first arguments first value value equals: 'foo'.
	firstField := operation selectionSet selections first.
	self assert: firstField class equals: GQLScalarFieldNode.
	self assert: firstField name equals: 'field'.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testOperationWithVariableDefaultValue [
	| text document operation field |
	text := 'query myQuery($atOtherHomes: Boolean = true) {
  				isHousetrained(atOtherHomes: $atOtherHomes)
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'atOtherHomes'.
	self assert: operation variableDefinitions first type class equals: GQLSBooleanTypeNode.
	self assert: operation variableDefinitions first defaultValue class equals: GQLBooleanNode.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'isHousetrained'.
	self assert: field arguments first name equals: 'atOtherHomes'.
	self assert: field arguments first value class equals: GQLVariableNode.
	self assert: field arguments first value value equals: 'atOtherHomes'.
	
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testOperationWithVariableDefinitions [
	| text document operation field |
	text := 'query myQuery($someTest: Boolean) {
  				experimentalField @include(if: $someTest)
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSBooleanTypeNode.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
	self assert: field directives first name equals: 'include'.
	self assert: field directives first arguments size equals: 1.
	self assert: field directives first arguments first name equals: 'if'.
	self assert: field directives first arguments first value class equals: GQLVariableNode.
	self assert: field directives first arguments first value value equals: 'someTest'.
	
]

{ #category : #'test-grammar-fields' }
GQLRequestGrammarEvaluatorTest >> testSimpleFields [
	| text document principalSelection firstSubSelection secondSubSelection|
	text := '{
				allFilms{
					name
					actors{
						name
					}
				}
			}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	principalSelection := document operations first.
	self assert: principalSelection class equals: GQLSelectionSetNode.
	self assert: principalSelection selections first class equals: GQLNonScalarFieldNode.
	self assert: principalSelection selections first name equals: 'allFilms'.
	firstSubSelection := principalSelection selections first selectionSet.
	self assert: firstSubSelection class equals: GQLSelectionSetNode.
	self assert: firstSubSelection selections first name equals: 'name'.
	self assert: firstSubSelection selections second name equals: 'actors'.
	secondSubSelection := firstSubSelection selections second selectionSet.
	self assert: secondSubSelection selections first name equals: 'name'.
	
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testVariableListType [
	| text document operation field |
	text := 'query myQuery($someTest: [ Boolean ]) {
  				experimentalField
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSListTypeNode.
	self assert: operation variableDefinitions first type wrappedType class equals: GQLSBooleanTypeNode.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testVariableListTypeNamed [
	| text document operation field |
	text := 'query myQuery($someTest: [ Some ]) {
  				experimentalField
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSListTypeNode.
	self assert: operation variableDefinitions first type wrappedType class equals: GQLSNamedTypeNode.
	self assert: operation variableDefinitions first type wrappedType name equals: 'Some'.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testVariableListTypeNonNull [
	| text document operation field |
	text := 'query myQuery($someTest: [ Int! ]) {
  				experimentalField
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSListTypeNode.
	self assert: operation variableDefinitions first type wrappedType class equals: GQLSNonNullTypeNode.
	self assert: operation variableDefinitions first type wrappedType wrappedType class equals: GQLSIntTypeNode.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testVariableListTypeNonNullNamed [
	| text document operation field |
	text := 'query myQuery($someTest: [ Some! ]) {
  				experimentalField
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSListTypeNode.
	self assert: operation variableDefinitions first type wrappedType class equals: GQLSNonNullTypeNode.
	self assert: operation variableDefinitions first type wrappedType wrappedType class equals: GQLSNamedTypeNode.
	self assert: operation variableDefinitions first type wrappedType wrappedType name equals: 'Some'.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testVariableNamedType [
	| text document operation field |
	text := 'query myQuery($someTest: Some) {
  				experimentalField
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSNamedTypeNode.
	self assert: operation variableDefinitions first type name equals: 'Some'.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testVariableNonNullListType [
	| text document operation field |
	text := 'query myQuery($someTest: [ Float ]!) {
  				experimentalField
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSNonNullTypeNode.
	self assert: operation variableDefinitions first type wrappedType class equals: GQLSListTypeNode.
	self assert: operation variableDefinitions first type wrappedType wrappedType class equals: GQLSFloatTypeNode.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testVariableNonNullListTypeNamed [
	| text document operation field |
	text := 'query myQuery($someTest: [ Some ]!) {
  				experimentalField
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSNonNullTypeNode.
	self assert: operation variableDefinitions first type wrappedType class equals: GQLSListTypeNode.
	self assert: operation variableDefinitions first type wrappedType wrappedType class equals: GQLSNamedTypeNode.
	self assert: operation variableDefinitions first type wrappedType wrappedType name equals: 'Some'.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testVariableNonNullListTypeNonNull [
	| text document operation field |
	text := 'query myQuery($someTest: [ Boolean! ]!) {
  				experimentalField
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSNonNullTypeNode.
	self assert: operation variableDefinitions first type wrappedType class equals: GQLSListTypeNode.
	self assert: operation variableDefinitions first type wrappedType wrappedType class equals: GQLSNonNullTypeNode.
	self assert: operation variableDefinitions first type wrappedType wrappedType wrappedType class equals: GQLSBooleanTypeNode.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testVariableNonNullListTypeNonNullNamed [
	| text document operation field |
	text := 'query myQuery($someTest: [ Some! ]!) {
  				experimentalField
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSNonNullTypeNode.
	self assert: operation variableDefinitions first type wrappedType class equals: GQLSListTypeNode.
	self assert: operation variableDefinitions first type wrappedType wrappedType class equals: GQLSNonNullTypeNode.
	self assert: operation variableDefinitions first type wrappedType wrappedType wrappedType class equals: GQLSNamedTypeNode.
	self assert: operation variableDefinitions first type wrappedType wrappedType wrappedType name equals: 'Some'.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testVariableNonNullNamedType [
	| text document operation field |
	text := 'query myQuery($someTest: Some!) {
  				experimentalField
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSNonNullTypeNode.
	self assert: operation variableDefinitions first type wrappedType class equals: GQLSNamedTypeNode.
	self assert: operation variableDefinitions first type wrappedType name equals: 'Some'.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testVariableNonNullScalarType [
	| text document operation field |
	text := 'query myQuery($someTest: ID!) {
  				experimentalField
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSNonNullTypeNode.
	self assert: operation variableDefinitions first type wrappedType class equals: GQLSIDTypeNode.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
]

{ #category : #tests }
GQLRequestGrammarEvaluatorTest >> testVariableScalarType [
	| text document operation field |
	text := 'query myQuery($someTest: String) {
  				experimentalField
				}'.
	document := GQLRequestGrammarEvaluator parse: text.
	self assert: document class equals: GQLDocumentNode.
	operation := document operations first.
	self assert: operation class equals: GQLOperationNode.
	self assert: operation name equals: 'myQuery'.
	self assert: operation type equals: 'query'.
	self assert: operation variableDefinitions first name class equals: ByteString.
	self assert: operation variableDefinitions first name value equals: 'someTest'.
	self assert: operation variableDefinitions first type class equals: GQLSStringTypeNode.
	field := operation selectionSet selections first.
	self assert: field class equals: GQLScalarFieldNode.
	self assert: field name equals: 'experimentalField'.
]
