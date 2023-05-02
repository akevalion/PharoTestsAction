| env cout |

env := Smalltalk os environment.
cout := Stdio stdout.
cout << 'hola mierdas'.
cout crlf.
cout << ((env at: 'GITHUB_WORKSPACE' ifAbsent: [ 'nogithub'])).

SmalltalkImage current quitPrimitive