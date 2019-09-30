"
A GQLSingleAnonimousQueryGrammarTest is a test class for testing the behavior of GQLSingleAnonimousQueryGrammar
"
Class {
	#name : #GQLSingleAnonimousQueryGrammarTest,
	#superclass : #PPCompositeParserTest,
	#category : #'GraphQLBeta-Tests-Grammar'
}

{ #category : #accessing }
GQLSingleAnonimousQueryGrammarTest >> parserClass [
	^ GQLSingleAnonimousQueryGrammar 
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testComposedDocument [
	| text |
	text := '{
		films { 
			id 
			name 
			rating 
		}
	}'.

	
	self parse: text rule: #document
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testComposedDocumentWithArguments [
	| text |
	text := '{
		films (ids:["1", "2"]){ 
			id
			name 
			rating (stringify: true)
		}
	}'.
	
	self parse: text rule: #document
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testComposedDocumentWithDirectives [
	| text |
		text := '{
		films (ids:["1", "2"]) @skip(if : true){ 
			id
			name 
			rating (stringify: true)
		}
	}'.
	
	self parse: text rule: #document
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testComposedDocumentWithFragments [
	| text |
	text := '{
		films (ids:["1", "2"]) @skip(if : true){ 
			id
			name 
			rating (stringify: true)
		}
	}
	fragment filmFeatures on Film { 
		rating(stringify: true)
		name
	}
	'.
	
	self parse: text rule: #document
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testComposedDocumentWithInlineFragments [
	| text |
	text := '{
		films (ids:["1", "2"]) @skip(if : true){ 
			id
			... {
				rating(stringify: true)
				name
			}
		}
	}
	'.
	
	self parse: text rule: #document
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testComposedDocumentWithInlineFragmentsDirectives [
	| text |
	text := '{
		films (ids:["1", "2"]) @skip(if : true){ 
			id
			... on Film @skip(if:true) @include(if:true){
				rating(stringify: true)
				name
			}
		}
	}
	'.
	
	self parse: text rule: #document
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testComposedDocumentWithInlineFragmentsType [
	| text |
	text := '{
		films (ids:["1", "2"]) @skip(if : true){ 
			id
			... on Film{
				rating(stringify: true)
				name
			}
		}
	}
	'.
	
	self parse: text rule: #document
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testComposedDocumentWithSchemaIntrospection [
	| text |
	text := '{
		__schema { 
			types { 
				name
			} 
		}
	}'.

	
	self parse: text rule: #document
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testComposedDocumentWithSpreadFragments [
	| text |
	text := '{
		films (ids:["1", "2"]) @skip(if : true){ 
			id
			...filmFeatures @include(if : true)
		}
	}
	fragment filmFeatures on Film { 
		rating(stringify: true)
		name
	}
	'.
	
	self parse: text rule: #document
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testComposedDocumentWithTypeIntrospection [
	| text |
	text := '{
  			__type(name:"Query")
		}'.
	
	self parse: text rule: #document.
]

{ #category : #'tests-introspection' }
GQLSingleAnonimousQueryGrammarTest >> testSchemaField [
	self parse: '__schema{types{name}}' rule: #schemaField.
	self parse: '__schema @skip(if: false){name}' rule: #schemaField.
	self parse: '__schema{
						fields
						otherField}' rule: #schemaField.
	self parse: '#comment 
					__schema{otherFields}' rule: #schemaField.
	self parse: '#comment 
					__schema{
						fields
						otherFields{
							name
						}
					}
					#other comment' rule: #schemaField.
	self fail: '__othername' rule: #schemaField.
	self fail: '__schema' rule: #schemaField.
	self fail: '_schema' rule: #schemaField.
	self fail: 'schema' rule: #schemaField.
	self fail: '__Schema' rule: #schemaField.
	self fail: '__schema(name:"Query")' rule: #schemaField.
	self fail: '__schema @skip(if:true)' rule: #schemaField.
	self fail: '__schema{}' rule: #schemaField.
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testSimpleDocument [
	| text |
	text := '{
  			firstName
  			lastName
		}'.
	
	self parse: text rule: #document.
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testSimpleDocumentWithArguments [
	| text |
	text := '{
  			firstName (upercase:true)
  			lastName
		}'.
	
	self parse: text rule: #document.
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testSimpleDocumentWithDirectives [
	| text |
	text := '{
  			firstName (upercase:true) @include(if : true)
  			lastName
		}'.
	
	self parse: text rule: #document.
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testSimpleDocumentWithFragments [
	| text |
	text := '{
  			firstName (upercase:true) @include(if : true)
  			lastName
		}
		fragment names on Person{
			firstName (upercase:true) @include(if : true)
  			lastName
		}
		fragment first on Person{
			name
		}
		'.
	
	self parse: text rule: #document.

]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testSimpleDocumentWithInlineFragment [
	| text |
	text := '{
  			...{
			firstName (upercase:true) @include(if : true)
  			lastName
			name
			}
		}'.
	
	self parse: text rule: #document.
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testSimpleDocumentWithInlineFragmentDirectives [
	| text |
	text := '{
  			... @skip(if:true){
			firstName (upercase:true) @include(if : true)
  			lastName
			name
			}
		}'.
	
	self parse: text rule: #document.
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testSimpleDocumentWithInlineFragmentType [
	| text |
	text := '{
  			... on Person{
			firstName (upercase:true) @include(if : true)
  			lastName
			name
			}
		}'.
	
	self parse: text rule: #document.
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testSimpleDocumentWithSpreadFragments [
	| text |
	text := '{
  			...names
		}
		fragment names on Person{
			firstName (upercase:true) @include(if : true)
  			lastName
			...name @skip(if : true)
		}
		fragment first on Person{
			name
		}
		'.
	
	self parse: text rule: #document.
]

{ #category : #tests }
GQLSingleAnonimousQueryGrammarTest >> testSimpleDocumentWithTypenameIntrospection [
	| text |
	text := '{
  			__typename
		}'.
	
	self parse: text rule: #document.
]

{ #category : #'tests-introspection' }
GQLSingleAnonimousQueryGrammarTest >> testTypeField [
	self parse: '__type(name:"Query"){name}' rule: #typeField.
	self parse: '__type(name:"Query")@skip(if:true){name}' rule: #typeField.
	self parse: '__type(otherArg:"OtherType"){otherField}' rule: #typeField.
	self parse: '#comment 
					__type(otherArg:"OtherType"){otherFields}' rule: #typeField.
	self parse: '#comment 
					__type(otherArg:"OtherType"){
						fields
						otherFields{
							name
						}
					}
					#other comment' rule: #typeField.
	self fail: 'typename' rule: #typenameField.
	self fail: '_typename' rule: #typenameField.
	self fail: '__otherName' rule: #typenameField.
	self fail: '__Typename' rule: #typenameField.
	self fail: '__type(name: "OtherType")'rule: #typeField.
	self fail: '__type{name}'rule: #typeField.
	self fail: '__type @skip(if: true){otherField}'rule: #typeField.
	self fail: '__type{types{name}}'rule: #typeField.
]

{ #category : #'tests-introspection' }
GQLSingleAnonimousQueryGrammarTest >> testTypenameField [
	self parse: '__typename' rule: #typenameField.
	self parse: '__typename @skip(if:true)' rule: #typenameField.
	self parse: '__typename @include(if:true)' rule: #typenameField.
	self parse: '#comment 
					__typename' rule: #typenameField.
	self parse: '#comment 
					__typename
					#other comment' rule: #typenameField.
	self fail: 'typename' rule: #typenameField.
	self fail: '_typename' rule: #typenameField.
	self fail: '__Typename' rule: #typenameField.
	self fail: '__otherName'rule: #typenameField.
	self fail: '__otherTypename(name: "OtherType")'rule: #typenameField.
	self fail: '__typename(name: "OtherType")'rule: #typenameField.
	self fail: '__typename{name}'rule: #typenameField.
	self fail: '__typename @skip(if: true){otherField}'rule: #typenameField.
	self fail: '__typename{types{name}'rule: #typenameField.
]
