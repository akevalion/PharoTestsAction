| env cout file last repoPath actionRepo regExp baseline group tests currentTime category |
env := Smalltalk os environment.
cout := Stdio stdout.
regExp := env at: 'ACTION_REGEX_STRING'.
baseline := env at: 'ACTION_BASELINE'.
group := env at: 'ACTION_GROUP'.
tests := env at: 'ACTION_TESTS'.

actionRepo := CommandLineArguments default arguments last asFileReference parent absolutePath pathString.

cout 
    << 'Loading action repository: gitlocal://';
    << actionRepo;
    crlf.
category := 'haroTestsAction'.
"To remove metacello notifactions"
MetacelloNotification compile: 'defaultAction' classified: category."TODO add a configuration to enable or disable this action"
NewUndeclaredWarning compile: 'defaultAction' classified: category.
MCGitBasedNetworkRepository compile: 'traceCr: aString' classified: category.
currentTime := DateAndTime now.
[Metacello new
    baseline: 'PharoTestsAction';
    repository: 'gitlocal://', actionRepo;
    load.
currentTime := DateAndTime now.
cout 
    << 'PharoTestsAction baseline loaded';
    crlf;
    << 'IO: Ready :V';
    crlf.
"This object can create an error file to know if tests are good or not, and its used by index.js"
#IOPharoTestsRunner asClass new
    remove: regExp;
    load: baseline group: group;
    runTests: tests.

 ] onErrorDo: [:ex | | errorFile |
    errorFile := '/tmp/testError.txt' asFileReference.
    errorFile writeStreamDo: [ :stream | 
        stream
            << ex asString; crlf; 
            << ex signalerContext longStack
    ]
].
cout crlf.
cout << 'Duration: ' << (DateAndTime now - currentTime) humanReadablePrintString.
cout crlf.
SmalltalkImage current quitPrimitive
