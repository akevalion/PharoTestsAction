| env cout |

env := Smalltalk os environment.
cout := Stdio stdout.
cout << '\e[1;31m Jajaja \e[0m'.
cout crlf.
cout << ((env at: 'GITHUB_WORKSPACE' ifAbsent: [ 'nogithub'])).

SmalltalkImage current quitPrimitive