Extension { #name : #Exception }

{ #category : #'*PharoTestsAction' }
Exception >> processActionBlock: ablock test: aTestCase [
	ablock value: self value: aTestCase
]

{ #category : #'*PharoTestsAction' }
Exception >> sunitAnnounce: a toResult: b [
]
