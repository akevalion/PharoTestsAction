Class {
	#name : #BaselineOfPharoTestsAction,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoTestsAction
}

{ #category : #baselines }
BaselineOfPharoTestsAction >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec 
			package: #'PharoTestsAction';
			package: #'PharoTestsAction-Tests';
			group: 'default' with: #('PharoTestsAction' 'PharoTestsAction-Tests')
	]
]
