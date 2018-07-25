# GraphQL
GraphQL is a query language for APIs and a runtime for fulfilling those queries with your existing data (https://graphql.org). 
GraphQL is ported to two Smalltalk dialects, Pharo (6.1) and VisualWorks (7.4 & 8.3). 

___
## Installation on Pharo
Execute the following incantation in a Playground:
```Smalltalk
Metacello new
    configuration: 'GraphQLBeta';
    smalltalkhubUser: 'ObjectProfile' project: 'GraphQL';
    version: #development; 
    load.
``` 
GraphQL is also available in the Pharo Catalog Browser:
1. Open `World Menu` then `Tools >> Catalog Browser`
2. In search input write: `Graphql`
3. Load it 

___
## Installation on VisualWorks 7.4
This project works on VisualWorks 7.4, to install GraphQL please execute the next piece of code

```Smalltalk
| dir file |
dir := Dialog requestDirectoryName: 'Choose the graphql parcels directory'.
dir ifEmpty: [^ self].
dir:= dir, (String with: Filename separator).
#('PetitExtensions' 'PetitParser' 'PetitTests'
 'GraphQLBeta' 'GraphQLExtensions' 'GraphQLBetaDemoSite') do: [:fn | 
 file := dir, fn, '.pcl'.

 file asFilename exists ifFalse: [self error: 'Missing parcel!', file asString].
 Parcel loadParcelFrom: file asFilename
  ].
```
Once load all the parcels of our project. If everything is going well, all the test must pass, except the tests of the classes:

* GQLTypeValidatorTest
* GQLDocumentTypeValidatorTest
## Development
For the moment our application works well for request based on selection sets.

### Internals 
There are some classes very important on Visual Works for GraphQL:
- Query: It's the entry point by default of the demo. Also on the class side has defined the schema used by the demo.
- GraphQLBetaDemoSite: It's the class to start the demo, it works with the schema of the Query class, the entry point is a Query instance and returns the results on JSON.
- GraphQL: It's the class that attends request and return the answer.

If you want to add your data to the Schema, you can modify the schema method on the class side of Query. Remember that the schema is defined as a text and follows the specifications of GraphQL.
Also don't forget to create all the necessary methods (operations) on the instance side of Query to provide the answer according to the schema defined.

___
## Installation on VisualWorks 8.x
You need to load the parcels in that order
1. PetitParser.pcl
1. PetitTests.pcl
1. PetitExtensions.pcl
1. GraphQLBeta.pcl
1. GraphQLJSON.pcl
1. GraphQLBetaExtentions.pcl
1. Sport.pcl
1. Swazoo.pcl
1. GraphQLDemoSite.pcl

After loading these parcels, you should be able to run (i) all the tests of GraphQL without any failure and (ii) the demos given below

___
# Feature ideas

This list describes a roadmap of our effort
* [x] Complete parsing of schema.
* [x] Complete parsing of any valid request.
* [x] Interpretation of simple request based on selection sets.
* [ ] Add tests for interpretation of request with fragments.
* [ ] Interpretation of request with fragments.
* [ ] Add tests for interpretation of any valid request.
* [ ] Interpretation of any valid request.
* [ ] Add tests for error handling.
* [ ] Error handling.
* [ ] Add tests for type checking rules.
* [ ] Type checking of the rules.
* [ ] Add tests for introspection.
* [ ] Introspection.
___

# Quick Demo
Our distribution contains a small demo, which works both on Pharo and VisualWorks. Execute the following steps:
1. Open a workspace and write the following line:
```
GraphQLBetaDemoSite demoStart
```
2. Open the browser and go to the url:
	**localhost:8888/**
3. Write the following request on the text area:
```
{
	allFilms{
		name	
	}
}
```
4. Press the button **Submit**.
5. And you will have the response for this request.

# Another Quick Demo

1. Define the class Hero:
```
Object subclass: #Hero
	instanceVariableNames: 'name planet'
```
And the following methods:
```
Hero>>name
	^ name

Hero>>name: aString
	name := aString
	
Hero>>planet
	^ planet
	
Hero>>planet: aString
	planet := aString
```

2. Define a method answering a set of heroes:
```
Query>>heroes
    | c |
    c := OrderedCollection new.
    c add: (Hero new name: 'Superman'; planet: 'Krypton').
    c add: (Hero new name: 'Mars pathfinder'; planet: 'Mars').
    c add: (Hero new name: 'Curiosity'; planet: 'Mars').
    c add: (Hero new name: 'Philae'; planet: 'comet 67P/Churyumov–Gerasimenko').
    ^ c
```
3. Write the following schema:
```
Query class>>schema
	^ 'type Query{
		heroes: [ Hero ]
	},
	type Hero{
		name : String
		planet : String
	}'
```
4. Open a workspace and write the following line:
```
GraphQLBetaDemoSite demoStart
```
5. Open the browser and go to the url:
	**localhost:8888/**
6. Submit the following request within the web browser:
```
{
	heroes{
		name
		planet	
	}

```
