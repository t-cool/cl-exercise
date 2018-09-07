# cl-exercise 

Common Lisp Online Learning System

![image](https://raw.githubusercontent.com/t-cool/cl-exercise/master/screenshot/img.png)

## Platform

macOS High Sierra

## Installation

In advance, please install [Roswell](https://github.com/roswell/roswell).

You can refer to this document for its installation:

[Roswell Installation Guide](https://github.com/roswell/roswell/wiki/Installation)


Please add the following line to `~/.bashrc` or `~/.bash_profile` to add `~/.roswell/bin` to PATH.

```
export PATH=$PATH:~/.roswell/bin
```

And then install qlot

```
$ ros install fukamachi/qlot
$ ros install fukamachi/fast-http
```

Now it's ready to install cl-exercise!

```
$ ros install t-cool/cl-exercise
$ cd ~/.roswell/local-projects/t-cool/cl-exercise
$ qlot install
$ qlot exec ros -S . run
```

## Usage

```lisp
$ qlot exec ros -S . run
* (ql:quickload :cl-exercise)
* (cl-exercise:start :port 8000 :debug nil)

;; Deployment
* (cl-exercise:start :host "http://example.com" :port 80)
```

## See Also

* [Bulma](https://github.com/jgthms/bulma) - Modern CSS framework based on Flexbox
* [CodeMirror](https://github.com/codemirror/codemirror) - In-browser code editor
* [marked](https://github.com/chjj/marked) - A markdown parser and compiler
* [darkmatter](https://github.com/tamamu/darkmatter) - The notebook-style Common Lisp environment


## Author

Eddie, t-cool

## Copyright

Copyright (c) 2018 Eddie, t-cool

## License

Licensed under the MIT License.
