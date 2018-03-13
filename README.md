# emacs-reason-ocaml
A simple setup for people who want to use ReasonML and OCaml with Emacs

This is supposed to be a simple Emacs configuration file to be mixed with your own. The only liberties I took was in using Helm and adding S-Expression syntax highlighting to make editing .elisp files easier. Helm is not required for this project to work.


## steps to follow
1. Rename your `.emacs.d` folder to something like `emacs-backup`
1. Run `git clone https://github.com/kuwze/emacs-reason-ocaml.git ~/.emacs.d`
1. Start Emacs
1. It should automatically download the current versions of the dependent libraries
1. When it comes to the .merlin file (which is required for merlin to work) you either write you own (if you are doing OCaml) or have the bucklescript compiler generate one for you (the example `bsconfig.json` below will auto generate one for you).

> `tree example-reasonml-application`
```
├── bsconfig.json
├── reasonml
│   ├── File1.bs.js
│   ├── File2.bs.js
│   ├── File1.re
│   └── File2.re
├── .merlin // this is autogenerated for you by bsb via your `bsconfig.json` at the start of the tree
```

> `cat bsconfig.json`

```javascript
{
    "name": "example-reasonml-application",
    "generate-merlin": true,
    "namespace": true,
    "reason": {
	"react-jsx": 2
    },
    "bsc-flags": ["-bs-super-errors"],
    "bs-dependencies": ["reason-react"],
    "sources": [
	{
	    "dir": "./reasonml",
	    "subdirs": true
	}
    ],
    "refmt": 3,
    "package-specs": {
	"module": "es6-global",
	"in-source": true
    },
    "js-post-build": {
	"cmd": "prettier --write"
    },
    "suffix": ".bs.js"
}
```
