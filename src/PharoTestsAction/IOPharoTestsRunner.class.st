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
	| block |
	block := [ :a :b |
		self show: 'Updating fonts'.
		FreeTypeFontProvider current updateFromSystem.
		self loadDefault: a group: b ].
	^ Dictionary new
		at: 'Roassal' put: block;
		at: 'Roassal3' put: block;
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
		ifAbsent: [ self loadDefault: aRepoString group: aGroupString ].
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
	self show: 'Group: ', group asString.
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
	aString = 'Roassal' ifTrue: [
		RSWorldMenu class methods do: [ :each | each removeFromSystem ].
		RSWorldMenu class compile: 'foo: a <worldMenu>'.
	]. 
	regExp := '*', aString, '*'.
	packages := RPackageOrganizer default packages
		select: [ :each | regExp match: each name ].
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
	| unitTests numberOfPassed numberOfErrors numberOfTestsMethods numberOfSkipped set numberOfFailures |
	self show: 'Running tests for `', aString, '`'.
	unitTests := self unitTestsFor: aString.
	numberOfPassed := 0.
	numberOfErrors := 0.
	numberOfTestsMethods := 0.
	numberOfSkipped := 0.
	numberOfFailures := 0.
	set := Set new.
	unitTests do: [ :unitTestClass | | suite res |
		suite := unitTestClass buildSuite.
		res := suite runWithAction: set block: [ :error :test |
			stream
				<< 'Error: ';
				<< test asString;
				<< ' --- ';
				<< error asString;
				crlf;
				<< error signalerContext shortStackCrlf;
				crlf.
			].
		numberOfTestsMethods := numberOfTestsMethods + res tests size.
		numberOfPassed := numberOfPassed + res passed size.
		numberOfErrors := numberOfErrors + res errors size.
		numberOfSkipped := numberOfSkipped + res skipped size.
		numberOfFailures := numberOfFailures + res failures size.
	].
	
	self showResult:
		{ unitTests size.
		numberOfPassed.
		numberOfErrors.
		numberOfFailures.
		numberOfSkipped.
		numberOfTestsMethods}
]

{ #category : #actions }
IOPharoTestsRunner >> show: aString [
	cout << 'IO: ' << aString; crlf
]

{ #category : #actions }
IOPharoTestsRunner >> showResult: aCollection [
	| res |
	res := aCollection collect: #asString.
	self 
		show: 'TESTS RESULTS';
		show: res first, ' test classes in total';
		show: res second, ' passed test methods';
		show: res third, ' error test methods';
		show: res fourth, ' failures test methods';
		show: res fifth, ' skip test methods';
		show: res sixth, ' test methods in total';
		show:'Running tests completed!'
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
			select: [ :cls | regExp match: cls package name ] ])
		sorted: [ :a :b | a name < b name ]
		
]
