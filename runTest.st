| env cout file |
env := Smalltalk os environment.
cout := Stdio stdout.
cout crlf.
cout << ((env at: 'GITHUB_WORKSPACE' ifAbsent: [ 'nogithub'])).

SmalltalkImage current quitPrimitive