| env cout file last repoPath actionRepo regExp baseline group tests |
env := Smalltalk os environment.
cout := Stdio stdout.
regExp := env at: 'ACTION_REGEX_STRING'.
baseline := env at: 'ACTION_BASELINE'.
group := env at: 'ACTION_GROUP'.
tests := env at: 'ACTION_TESTS'.

actionRepo := CommandLineArguments default arguments last asFileReference parent absolutePath pathString.
"actionRepo asFileReference allChildren do: [:each | cout << each absolutePath pathString; crlf ]."
cout 
    << 'Loading action repository: ';
    << ('gitlocal://', actionRepo);
    crlf.

[Metacello new
    baseline: 'PharoTestsAction';
    repository: 'gitlocal://', actionRepo;
    load.
"This object can create an error file to know if tests are good or not, and its used by index.js"
IOPharoTestsRunner new
    remove: regExp;
    load: baseline group: group;
    runTests: tests.

 ] onErrorDo: [:ex | 
        cout
            << ex asString; crlf; 
            << ex signalerContext shortStack ].

SmalltalkImage current quitPrimitive