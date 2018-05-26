# Cl-Exercise

Online Common Lisp Learning System


## Installation

Please install [Roswell](https://github.com/roswell/roswell) in advance.

```bash
$ ros install fukamachi/qlot
$ git clone https://github.com/t-cool/cl-exercise
$ cd cl-exercise
$ qlot install
$ qlot exec ros -S . run
```

## Usage

```lisp
(ql:quickload :cl-exercise)
(cl-exercise:start :port 8000 :debug nil)

;; Deployment
(cl-exercise:start :host "http://example.com" :port 80)
```

## See Also

* [Bulma](https://github.com/jgthms/bulma) - Modern CSS framework based on Flexbox
* [CodeMirror](https://github.com/codemirror/codemirror) - In-browser code editor
* [marked](https://github.com/chjj/marked) - A markdown parser and compiler

## Author

* Eddie, Noguchi Hiroki

## Copyright

Copyright (c) 2018 Eddie, t-cool

## License

Licensed under the MIT License.
