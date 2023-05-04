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
		at: 'Roassal3' put: [ [ :a :b |
			self show: 'Updating fonts'.
			FreeTypeFontProvider current updateFromSystem.
			self loadDefault: a group: b ] ];
		yourself
]

{ #category : #initialization }
IOPharoTestsRunner >> initialize [
	super initialize.
	self cout: Stdio stdout.
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
	self show: 'Clonning from ', repoPath.
	aBaselineName = 'PharoTestsAction' ifTrue: [ 
		self show: 'PharoTestsAction already loaded'.
		^ self ].
	[Metacello new
		baseline: aBaselineName;
		repository: repoPath;
		load: group ] on: MCMergeOrLoadWarning do: [ :warning | warning load ].
	self show: 'Finish baseline `', aBaselineName, '`'.
]

{ #category : #removing }
IOPharoTestsRunner >> remove: aString [
	aString = '.' ifTrue: [ 
		self show: 'Nothing to remove!'.
		^ self ].
	self show: 'Removing packages `', aString, '`'.
	names := self splitString: aString.
	names do: [ :each | self removeNamed: each ].
	self show: 'Remove completed'.

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
	| unitTests numberOfPassed numberOfErrors numberOfTestsMethods |
	self show: 'Running tests for `', aString, '`'.
	unitTests := self unitTestsFor: aString.
	numberOfPassed := 0.
	numberOfErrors := 0.
	numberOfTestsMethods := 0.
	
	unitTests do: [ :unitTestClass | | suite res |
		suite := unitTestClass buildSuite.
		numberOfTestsMethods := numberOfTestsMethods + suite tests size.
		res := suite resultClass new.
		suite setUp.
		[ suite tests do: [ :each | 
			[ each debug.
			numberOfPassed := numberOfPassed + 1 ] onErrorDo: [ :error |
				numberOfErrors := numberOfErrors + 1.
				stream << 'Error: ' << each asString.
				stream crlf.
				stream << error signalerContext shortStack.
				stream crlf; crlf.
			].
			suite announceTest: each.
			suite changed: each.
			 ] ] ensure: [ suite tearDown ]
		 ].
	
	cout crlf.
	self 
		show: 'TESTS RESULTS';
		show: unitTests size asString, ' test classes in total';
		show: numberOfPassed asString, ' passed test methods';
		show: numberOfErrors asString, ' error test methods';
		show: numberOfTestsMethods asString, ' test methods in total';
		show:'IO: Running tests completed!'
]

{ #category : #actions }
IOPharoTestsRunner >> show: aString [
	cout << 'IO: ' << aString; crlf
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
