# PharoTestsAction

This project is to test pharo code. The actions will remove packages of pharo and then will load and execute the tests. I an error is found it will return an error

### Installation

In pharo 11 run:

```Smalltalk
Metacello new
    baseline: 'PharoTestsAction';
    repository: 'github://akevalion/PharoTestsAction';
    load
```
