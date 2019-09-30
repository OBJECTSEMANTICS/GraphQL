Class {
	#name : #GQLTestExtension,
	#superclass : #GQLTest,
	#category : #'GraphQLBeta-Tests-Nodes'
}

{ #category : #initialization }
GQLTestExtension >> initDictOfInvalidSchema [
	^ Dictionary new
	at: 'wrongDefinedObjExtensionManySchemas' put: (
	"Array of schemas"
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		type GQLTestQueryType {
			helloTo(name: String): String
		}'
		with: '
		extend type GQLTestQueryType { 
			cats: [ GQLCat ]
		}
		type GQLCat{ 
			name: String
		}')
	"Array of resolvers"
	with: (Array new: 0)
	with: GQLTestQueryType new
	); 
	at: 'wrongDefinedObjExtensionOneSchema' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		type GQLTestQueryType {
			helloTo(name: String): String
		}
		extend type GQLTestQueryType {
			cats: [ GQLCat ]
		}
		type GQLCat {
			name : String
		}')
	with: (Array new: 0)
	with: GQLTestQueryType new
	);
	at: 'wrongDefinedObjExtensWithInterface' put: (
	Array with:
		(Array with: '
		interface NamedEntity { 
			name: String
		}
		schema{
			query: GQLTestSchema
		}
		type GQLTestSchema {
			filmsSortedBy(name: Boolean): [ GQLTestFilm ]
		}
		type GQLTestFilm {
			rating : Int
		}'
		with: '
		extend interface NamedEntity{
			id: String
		}
		extend type GQLTestFilm implements NamedEntity {
			name: String
		}')
	with: (Array new: 0)
	with: GQLTestSchema new
	);
	at: 'wrongDefinedObjectExtensWithResolvers' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		type GQLTestQueryType {
			hello: String
		}'
		with: '
		extend type GQLTestQueryType {
			asText(number: Int): String
		}')
	with: (Array with: GQLTestQueryType with: GQLFilm)
	with: GQLTestQueryType new
	);
	at: 'wrongInterfaceExtensManySchemas' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		interface DataEntity{
			name: String
		}
		type GQLTestQueryType {
			films: [ GQLTestFilm ]
		}
		type GQLTestFilm implements DataEntity{ 
			name: String
		}'
		with: '
		extend interface DataEntity {
			name: String
		}')
	with: (Array new: 0)
	with: GQLTestQueryType new
	);
	at: 'wrongInterfaceExtensOneSchema' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		interface DataEntity{
			id: String
		}
		type GQLTestQueryType {
			films: [ GQLTestFilm ]
		}
		type GQLTestFilm implements DataEntity{ 
			name: String
			id: String
		}
		extend interface DataEntity { 
			id: String
		}
		')
	with: (Array new: 0)
	with: GQLTestQueryType new
	);
	at: 'wrongUnionExtensionManySchemas' put: (
	Array with:
		(Array with: '
		schema { 
			query: GQLTestSchema
		}
	   union SearchObject = Point | Rectangle
		type GQLTestSchema {
			firstExtendedSearchObject: SearchObject
		}
		type Point{
			x: Float
			y: Float
		}
		type Rectangle{
			origin: Point
			corner: Point
		}
		'
		with: 'extend union SearchObject = Point | GQLDog
		type GQLDog { 
			name: String
		}
		')
	with: (Array new: 0)
	with: GQLTestSchema new
	);
		at: 'wrongUnionExtensionOneSchema' put: (
	Array with:
		(Array with: '
		schema {
			query: GQLTestSchema
		}
		union SearchObject = Point | Rectangle
		type GQLTestSchema{
			firstExtendedSearchObject: SearchObject
		}
		type Point{
			x: Float
			y: Float
		}
		type Rectangle{
			origin: Point
			corner: Point
		}
		type GQLDog { 
			name: String
		}
		extend union SearchObject = Rectangle | GQLDog
		')
	with: (Array new: 0)
	with: GQLTestSchema new
	);	
	at: 'wrongEnumExtensionManySchemas' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		enum MovieType{COMEDY, SCIENCE_FICTION}
		type GQLTestQueryType{
			classification(gender: MovieType): String
		}'
		with: 'extend enum MovieType { COMEDY }')
	with: (Array new: 0)
	with: GQLTestQueryType new);
	at: 'wrongEnumExtensionOneSchema' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		enum MovieType{COMEDY,  DRAMA}
		type GQLTestQueryType{
			classification(gender: MovieType): String
		}
		extend enum MovieType { DRAMA }')
	with: (Array new: 0)
	with: GQLTestQueryType new
	);
	at: 'wrongInputObjectExtensManySchemas' put: (
	Array with:
		(Array with: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema { 
			inform(film: GQLFilmInput, id: Int): GQLFilm
		}
		type GQLFilm{
			id: Int
			filmName: String
		}
		input GQLFilmInput {
			id: Int!
		}'
		with: '
		extend input GQLFilmInput {
			id: Int!
		}')
	with: (Array new: 0)
	with: GQLTestSchema new
	);
	at: 'wrongInputObjectExtensionOneSchema' put: (
	Array with:
		(Array with: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema { 
			inform(film: GQLFilmInput, id: Int): GQLFilm
		}
		type GQLFilm{
			id: Int
			filmName: String
		}
		input GQLFilmInput {
			filmName: String
		}
		extend input GQLFilmInput {
			filmName : String
		}')
	with: (Array new: 0)
	with: GQLTestSchema new
	);
	yourself
]

{ #category : #initialization }
GQLTestExtension >> initDictSchema [
	^ Dictionary new
	at: 'apartObjectExtensWithFieldDef' put: (
	"Array of schemas"
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		type GQLTestQueryType {
			helloTo(name: String): String
		}'
		with: '
		extend type GQLTestQueryType {
			films: [ GQLTestFilm ]
		}
		type GQLTestFilm {
			id : Int
			name : String
			rating : Int
		}'
		with: '
		extend type GQLTestQueryType { 
			features(film: GQLFilmInput): String
		}
		input GQLFilmInput { 
			filmName: String
		}')
	"Array of resolvers"
	with: (Array new: 0)
	"root operation type"
	with: GQLTestQueryType new
	); 
	at: 'objectExtensWithFieldDef' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		type GQLTestQueryType {
			helloTo(name: String): String
		}
		extend type GQLTestQueryType {
			films: [ GQLTestFilm ]
		}
		type GQLTestFilm {
			id : String
			name : String
			rating : Int
		}')
	with: (Array new: 0)
	with: GQLTestQueryType new
	);
	at: 'objectExtensWithInterface' put: (
	Array with:
		(Array with: '
		interface NamedEntity { 
			name: String
		}
		schema{
			query: GQLTestSchema
		}
		type GQLTestSchema {
			cats: [ GQLCat ]
			filmsSortedBy(name: Boolean): [ GQLTestFilm ]
		}
		type GQLCat implements NamedEntity{ 
			name: String
			nickname: String
		}
		type GQLTestFilm {
			id : String
			name : String
			rating : Int
		}'
		with: 'extend type GQLTestFilm implements NamedEntity')
	with: (Array new: 0)
	with: GQLTestSchema new
	);
	at: 'objectExtensWithExtInterface' put: (
	Array with:
		(Array with: '
		interface NamedEntity { 
			name: String
		}
		schema{
			query: GQLTestSchema
		}
		type GQLTestSchema {
			filmsSortedBy(name: Boolean): [ GQLTestFilm ]
		}
		type GQLTestFilm {
			id : String
			rating : Int
		}'
		with: '
		extend interface NamedEntity{
			id: String
		}
		extend type GQLTestFilm implements NamedEntity {
			name: String
		}')
	with: (Array new: 0)
	with: GQLTestSchema new
	);
	at: 'objectExtensWithOtherResolver' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		type GQLTestQueryType {
			hello: String
		}'
		with: '
		extend type GQLTestQueryType {
			asText(number: Int): String
		}')
	with: (Array with: GQLTestQueryType with: GQLTestSchema)
	with: GQLTestQueryType new
	);
	at: 'apartInterfaceExtension' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		interface DataEntity{
			name: String
		}
		type GQLTestQueryType {
			hello: String
			films: [ GQLTestFilm ]
		}
		type GQLTestFilm implements DataEntity{ 
			name: String
			rating: String
			id: String
		}'
		with: '
		extend interface DataEntity {
			id: String
		}')
	with: (Array new: 0)
	with: GQLTestQueryType new
	);
	at: 'apartInterfaceExtensionWithObExt' put: (
	Array with:
		(Array with: '
		schema {
			query: GQLTestQueryType
		}
		interface NamedEntity { 
			name: String
		}
		type GQLTestQueryType {
			films: [ GQLTestFilm ]
		}
		type GQLTestFilm implements NamedEntity { 
			id: String
			rating: Int
		}'
		with: '
		extend type GQLTestFilm implements IdentifierEntity{
			name: String
		}
		interface IdentifierEntity{
			id: String
		}')
	with: (Array new: 0)
	with: GQLTestQueryType new
	);
	at: 'interfaceExtension' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		interface DataEntity{
			id: String
		}
		type GQLTestQueryType {
			films: [ GQLTestFilm ]
		}
		type GQLTestFilm implements DataEntity{ 
			name: String
			rating: String
			id: String
		}
		extend interface DataEntity { 
			name: String
		}
		')
	with: (Array new: 0)
	with: GQLTestQueryType new
	);
	at: 'apartUnionExtension' put: (
	Array with:
		(Array with: '
		schema { 
			query: GQLTestSchema
		}
	   union SearchObject = Point | Rectangle
		type GQLTestSchema {
			firstExtendedSearchObject: SearchObject
		}
		type Point{
			x: Float
			y: Float
		}
		type Rectangle{
			origin: Point
			corner: Point
		}
		'
		with: 'extend union SearchObject = GQLCat | GQLDog
		type GQLCat { 
			name: String
			nickname: String
		}
		type GQLDog { 
			name: String
		}
		')
	with: (Array new: 0)
	with: GQLTestSchema new
	);
		at: 'unionExtension' put: (
	Array with:
		(Array with: '
		schema {
			query: GQLTestSchema
		}
		union SearchObject = Point | Rectangle
		type GQLTestSchema{
			firstExtendedSearchObject: SearchObject
		}
		type Point{
			x: Float
			y: Float
		}
		type Rectangle{
			origin: Point
			corner: Point
		}
		type GQLCat { 
			name: String
			nickname: String
		}
		type GQLDog { 
			name: String
		}
		extend union SearchObject = GQLCat | GQLDog
		')
	with: (Array new: 0)
	with: GQLTestSchema new
	);	
	at: 'apartEnumExtension' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		enum MovieType{COMEDY, SCIENCE_FICTION}
		type GQLTestQueryType{
			classification(gender: MovieType): String
		}'
		with: 'extend enum MovieType { ACTION }')
	with: (Array new: 0)
	with: GQLTestQueryType new);
	at: 'enumExtension' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		enum MovieType{COMEDY,  DRAMA}
		type GQLTestQueryType{
			classification(gender: MovieType): String
		}
		extend enum MovieType { SCIENCE_FICTION }')
	with: (Array new: 0)
	with: GQLTestQueryType new
	);
	at: 'apartInputObjectExtension' put: (
	Array with:
		(Array with: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema { 
			inform(film: GQLTestFilmInput, id: Int): GQLTestFilm
		}
		type GQLTestFilm{
			id: Int
			filmName: String
		}
		input GQLTestFilmInput {
			id: Int!
		}'
		with: '
		extend input GQLTestFilmInput {
			filmName : String
		}')
	with: (Array new: 0)
	with: GQLTestSchema new
	);
	at: 'inputObjectExtension' put: (
	Array with:
		(Array with: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema { 
			inform(film: GQLTestFilmInput, id: Int): GQLTestFilm
		}
		type GQLTestFilm{
			id: Int
			filmName: String
		}
		input GQLTestFilmInput {
			id: Int!
		}
		extend input GQLTestFilmInput {
			filmName : String
		}')
	with: (Array new: 0)
	with: GQLTestSchema new
	);
	yourself
]
