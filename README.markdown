# cl-exercise 

Common Lisp Online Learning System

![image](https://raw.githubusercontent.com/t-cool/cl-exercise/master/screenshot/img.png)

## Platform

macOS High Sierra

## Requirement

- Libev

```bash
brew install libev
```

- Roswell

Please follow [Roswell Installation Guide](https://github.com/roswell/roswell/wiki/Installation), and then add the PATH to `ros` command.

```
echo "export PATH=\"\$HOME/.roswell/bin:\$PATH\"" >> ~/.bash_profile
```

- Qlot

```
$ ros install fukamachi/qlot
```

## Installation

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

;; Development / Publishing
* (cl-exercise:start :host "http://[GLOBAL_IP_ADDRESS]" :port 80)
```

## See Also

* [Darkmatter](https://github.com/tamamu/darkmatter) - The notebook-style Common Lisp environment
* [Bulma](https://github.com/jgthms/bulma) - Modern CSS framework based on Flexbox
* [CodeMirror](https://github.com/codemirror/codemirror) - In-browser code editor
* [marked](https://github.com/chjj/marked) - A markdown parser and compiler


## Author

Eddie, t-cool

## Copyright

Copyright (c) 2018 Eddie, t-cool

## License

Licensed under the MIT License.
