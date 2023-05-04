| env cout file last repoPath actionRepo regExp baseline group tests |
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
"To remove metacello notifactions"
MetacelloNotification compile: 'defaultAction'.
NewUndeclaredWarning compile: 'defaultAction'.
[Metacello new
    baseline: 'PharoTestsAction';
    repository: 'gitlocal://', actionRepo;
    load.
cout 
    << 'PharoTestsAction baseline loaded';
    crlf;
    << 'IO: Ready! :V';
    crlf.
"This object can create an error file to know if tests are good or not, and its used by index.js"
#IOPharoTestsRunner asClass new
    remove: regExp;
    load: baseline group: group;
    runTests: tests.

 ] onErrorDo: [:ex | 
        cout
            << ex asString; crlf; 
            << ex signalerContext shortStack ].

SmalltalkImage current quitPrimitive