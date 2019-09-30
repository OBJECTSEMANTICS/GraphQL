"
I have the world menus for this demo
"
Class {
	#name : #GraphQLDemoWorldMenu,
	#superclass : #Object,
	#category : #'GraphQLBeta-Demo'
}

{ #category : #origins }
GraphQLDemoWorldMenu class >> image [
	^  PNGReadWriter formFromStream: self imageString base64Decoded asByteArray readStream
]

{ #category : #origins }
GraphQLDemoWorldMenu class >> imageString [
	^'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAACB1BMVEUAAADlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNavlNav////Zc6BEAAAAq3RSTlMAAAAAAAAAAAAAAAAAAAAAAAAiuroiZ///ZxFgseXlsWARAEiMZo9niFZWiWePZoxIABXM0ygyigoJijIp08sVC6P6hwmIOjmICYf6owsknRFLewICe0wRnSQWih2RJCSRHYoWiW9kZG+JI7WZEhKZtSMKoqgxNDQ0NDGoogoUy++geHl5eXeb7MsVAEeMZo5lEwwMD1l+YIxHABJinMPCj1UOaP//ZSK6uiKvO/P4AAAAAWJLR0SsV2XyiwAAAAd0SU1FB+ILFRAkMTtfxHkAAAD2SURBVBjTY2AAAUYhYRFRRgY4YGIWE5eQZGaBclnZpKRlZOXkFRTZOYBcJWUVVTV1DU0tbR1dPX0DQwYj49UmpmbmFpZW1ja2q+3sGRwcnZxdXN0YGd09PL28fXwZOP38AwKDgpm5QkLDwiMiORm4o6JjYuOAVrLFJyQmRXEzcCenpKYxAgV4eNMzMpO5GTizsnNywW5iy8svKORkKCpeXVJaVl5RUV5ZVb26ppahrn51Q2NTc0tLa1t7x+rOLobunt6+/gkTJ02eMnXa9BkzZwH18jHOnjN33vwFCxfxC0B9I8i4eMnSZYw8CO8yLl+xchUbmAkAehs/ZSlO9KwAAAAldEVYdGRhdGU6Y3JlYXRlADIwMTgtMTEtMjFUMTY6MzY6NDktMDU6MDBSqLNsAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDE4LTExLTIxVDE2OjM2OjQ5LTA1OjAwI/UL0AAAAABJRU5ErkJggg=='
]

{ #category : #'as yet unclassified' }
GraphQLDemoWorldMenu class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: 'GraphQL') icon: self image.
	
	(aBuilder item: 'start' asSymbol)
		order: 0.001; 
		parent: 'GraphQL';
		label: 'Start server';
		icon: (Smalltalk ui icons iconNamed: #smallDoIt);
		action: [ 
			GraphQLBetaDemoSite demoStart.
			WebBrowser openOn: 'http://localhost:8888'].

	(aBuilder item: 'stop' asSymbol)
		order: 0.001; 
		parent: 'GraphQL';
		label: 'Stop server';
		icon: (Smalltalk ui icons iconNamed: #stop);
		action: [ GraphQLBetaDemoSite demoStop ];
		withSeparatorAfter.
		
	(aBuilder item: 'schema' asSymbol)
		order: 0.001; 
		parent: 'GraphQL';
		label: 'Edit the demo schema';
		icon: (Smalltalk ui icons iconNamed: #workspace);
		action: [ (GQLQuery class >> #schema ) browse].
		
	(aBuilder item: 'example' asSymbol)
		order: 0.001; 
		parent: 'GraphQL';
		label: 'See an example';
		icon: (Smalltalk ui icons iconNamed: #workspace);
		action: [ Transcript open; clear; show: self requestExample ].
	(aBuilder item: 'git' asSymbol)
		order: 0.001; 
		parent: 'GraphQL';
		label: 'Github page';
		icon: (Smalltalk ui icons iconNamed: #github);
		action: [ WebBrowser openOn: 'https://github.com/OBJECTSEMANTICS/GraphQL' ].

	(aBuilder item: 'report' asSymbol)
		order: 0.001; 
		parent: 'GraphQL';
		label: 'Report an issue';
		icon: (Smalltalk ui icons iconNamed: #glamorousBug);
		action: [ WebBrowser openOn: 'https://github.com/OBJECTSEMANTICS/GraphQL/issues/new' ].
]

{ #category : #'as yet unclassified' }
GraphQLDemoWorldMenu class >> requestExample [
	^ '
{
	...foo
}
fragment foo on Query{
	allFilms{
		name
	}
}
	'
]
