Extension { #name : #TestResult }

{ #category : #'*PharoTestsAction' }
TestResult >> runCase: aTestCase block: aBlock [
	[ 
		aTestCase announce: TestCaseStarted withResult: self.
		aTestCase runCaseManaged.
		aTestCase announce: TestCaseEnded withResult: self.
		self addPass: aTestCase
	] on: Exception do: [ :ex |
		ex actionAnnounce: aTestCase toResult: self
	]
]
