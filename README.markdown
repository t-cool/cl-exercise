# cl-exercise 

Common Lisp Online Learning System

![image](https://raw.githubusercontent.com/t-cool/cl-exercise/master/screenshot/img.png)

## To do

- ~~to add evaluating answers function~~

- ~~to embed an editor (Codemirror)~~

- ~~to make a table of lessons~~

- to add saving mode

- to add lesson plans (base on cl-cookbook)

## Platform

macOS High Sierra, Ubuntu

## Requirement

- [libev](http://software.schmorp.de/pkg/libev.html)

- [Roswell](https://github.com/roswell/roswell)

## Installation

```
$ ros install t-cool/cl-exercise
```

## Usage

```lisp
# load the system and start the server
* (ql:quickload :cl-exercise)
* (cl-exercise:start :port 8000 :debug nil)

;; Development / Publishing
* (cl-exercise:start :host "http://[GLOBAL_IP_ADDRESS]" :port 80)
```

## Adding lessons

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
  Please set the result of `2 + 3 * 4` to the symbol `reslut`.
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
