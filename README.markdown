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
$ cd ~/.roswell/local-projects/t-cool/cl-exercise && qlot install
$ qlot exec ros -S . run
```

## Usage

```lisp
$ cd ~/.roswell/local-projects/t-cool/cl-exercise
$ qlot exec ros -S . run
* (ql:quickload :cl-exercise)
* (cl-exercise:start :port 8000 :debug nil)

;; Development / Publishing
* (cl-exercise:start :host "http://[GLOBAL_IP_ADDRESS]" :port 80)
```

## Adding 

The files of lessons are inside `data` directory in JSON format.

You can add your own lessons. The format is as bellow:

 - `name`: lesson's name

 - `purpose`: lesson's purpose

 - `media`: the link to videos or presentation slides

 - `description`: the head title of the lesson page

 - `content`: explanation
 
 - `test`: the test function to check the answer

 - `requirements`: the list of the symbols that have to be inside the code
 
This is an example of lessons. 

```json
{
  "name": "setf",
  "purpose": "The purpose of the lesson",
  "media": "https://www.youtube.com/embed/HM1Zb3xmvMc",
  "description": "**setq**",
  "content": "
  いま，パッケージに**result**というシンボルが存在します．
  setqを使って、シンボルresultに2 + 3 * 4の計算結果を代入してください．
  ",
  "prepare": "(defvar result nil)",
  "test": "(and (numberp result) (= result (+ 2 (* 3 4))))",
  "requirements": {
    "symbols": ["setq", "result"]
  }
}
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
