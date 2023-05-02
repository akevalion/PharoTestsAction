| env cout |

env := Smalltalk os environment.
cout := Stdio stdout.
cout << '\x1b[31mJajaja\x1b[0m'.
cout crlf.
cout << ((env at: 'GITHUB_WORKSPACE' ifAbsent: [ 'nogithub'])).

SmalltalkImage current quitPrimitive