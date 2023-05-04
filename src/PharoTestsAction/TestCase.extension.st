Extension { #name : #TestCase }

{ #category : #'*PharoTestsAction' }
TestCase >> run: aResult block: aBlock set: set [
	| string |
	string := self asString.
	(set includes: string)
		ifTrue: [ ^ self ].
	set add: string.
	aResult runCase: self block: aBlock
]
