Extension { #name : #TestSkipped }

{ #category : #'*PharoTestsAction' }
TestSkipped >> actionAnnounce: aTestCase toResult: aTestResult [

	aTestResult addSkip: aTestCase
]
