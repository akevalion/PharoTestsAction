"
Class used to remove existing code the load it again to finally run tests
"
Class {
	#name : #IOPharoTestsRunner,
	#superclass : #Object,
	#instVars : [
		'names',
		'repos',
		'cout'
	],
	#category : #PharoTestsAction
}

{ #category : #accessing }
IOPharoTestsRunner >> cout [

	^ cout
]

{ #category : #accessing }
IOPharoTestsRunner >> cout: anObject [

	cout := anObject
]

{ #category : #default }
IOPharoTestsRunner >> defaultRepos [
	^ Dictionary new
		"at: 'Roassal3' put: [ [ :a :b | self loadDefault: a group: b ] ];"
		yourself
]

{ #category : #initialization }
IOPharoTestsRunner >> initialize [
	super initialize.
	cout := Stdio stdout.
]

{ #category : #actions }
IOPharoTestsRunner >> load: aRepoString group: aGroupString [
	self repos at: aRepoString
		ifPresent: [ :block | block value: aRepoString value: aGroupString ] 
		ifAbsent: [ self loadDefault: aRepoString group: 'default' ].
]

{ #category : #actions }
IOPharoTestsRunner >> loadDefault: aBaselineName group: group [
	| env repoPath |
	env := Smalltalk os environment.
	repoPath := 'gitlocal://', (env at: 'GITHUB_WORKSPACE').
	cout << '>>> Clonning from: '; << repoPath; crlf.
	aBaselineName = 'PharoTestsAction' ifTrue: [ 
		cout << 'Already loaded'; crlf.
		^ self ].
	[ Metacello new
    baseline: aBaselineName;
    repository: repoPath;
    load: group ] on: MCMergeOrLoadWarning do: [ :warning | warning load ].
	
]

{ #category : #removing }
IOPharoTestsRunner >> remove: aString [
	aString = '.' ifTrue: [ 
		cout << 'IO: nothing to remove!'.
		^ self ].
	names := self splitString: aString.
	names do: [ :each | self removeNamed: each ]

]

{ #category : #removing }
IOPharoTestsRunner >> removeNamed: aString [
	| regExp packages |
	regExp := '*', aString, '*'.
	packages := RPackageOrganizer default packages
		select: [ :each | regExp match: each packageName ].
	packages do: [ :each | each removeFromSystem ].
]

{ #category : #accessing }
IOPharoTestsRunner >> repos [
	^ repos ifNil: [ repos := self defaultRepos ]
]

{ #category : #actions }
IOPharoTestsRunner >> runTests: aString [
	| errorFile |
	errorFile := '/tmp/testError.txt' asFileReference.
	errorFile writeStreamDo: [ :stream | self runTests: aString onErrorStream: stream ].
	errorFile contents ifEmpty: [ errorFile delete ].
	
]

{ #category : #actions }
IOPharoTestsRunner >> runTests: aString onErrorStream: stream [
	| unitTests numberOfPassed numberOfTestsMethods |
	cout << '>>> Running tests for: '; <<aString; crlf.
	unitTests := self unitTestsFor: aString.
	numberOfPassed := 0.
	numberOfTestsMethods := 0.
	unitTests do: [ :unitTestClass | | suite res |
		suite := unitTestClass buildSuite.
		numberOfTestsMethods := numberOfTestsMethods + suite tests size.
		res := suite resultClass new.
		suite setUp.
		[ suite tests do: [ :each | 
			[ each debug.
			numberOfPassed := numberOfPassed + 1 ] onErrorDo: [ :error |
				stream << 'Error: ' << each asString.
				stream crlf.
				stream << error signalerContext shortStack.
				stream crlf; crlf.
			].
			suite announceTest: each.
			suite changed: each.
			 ] ] ensure: [ suite tearDown ]
		 ].
	cout 
		crlf;
		<< 'NUMBER OF UNIT TESTS=';
		<< unitTests size asString;
		crlf;
		<< 'NUMBER OF PASSED TEST METHODS=';
		<< numberOfPassed asString; 
		crlf;
		<< 'NUMBER OF TEST METHODS=';
		<< numberOfTestsMethods asString;
		crlf;
		<< 'END';
		crlf.
]

{ #category : #removing }
IOPharoTestsRunner >> splitString: aString [
	^ (aString splitOn: ',') collect: [:each | each trimBoth ] as: Array.
]

{ #category : #actions }
IOPharoTestsRunner >> unitTestsFor: aString [
	^ ((self splitString: aString) flatCollect: [ :name | | regExp |
		regExp := '*', name , '*'.
		TestCase withAllSubclasses
			select: [ :cls | regExp match: cls package packageName ] ])
		sorted: [ :a :b | a name < b name ]
		
]
