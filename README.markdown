# cl-exercise 

Common Lisp Online Learning System

![screenshot](screenshot/screenshot.png)

## Platform

macOS, Ubuntu16.04

## Requirement

- [Roswell](https://github.com/roswell/roswell)

- [Qlot](https://github.com/fukamachi/qlot)

- [libev](http://software.schmorp.de/pkg/libev.html)

## Installation

1. Please check if you've already installed libev, Roswell, and Qlot:

```
$ brew install libev
Warning: libev 4.24 is already installed and up-to-date```
$ brew install roswell
Warning: roswell 19.3.10.97 is already installed and up-to-date
$ ros install fukamachi/qlot
Installing from github fukamachi/qlot
(omitted)
up to date. stop

2. Install cl-exercise using Roswell:

```
$ ros install t-cool/cl-exercise
```

3. Fix the version of dependent libraries with Qlot:

```
$ cd ~/.roswell/local-projects/t-cool/cl-exercise
$ qlot install
```

## Usage

First please check if you added `~/.roswell/bin` to PATH in `~/.bashrc`:

```
export PATH=$PATH:~/.roswell/bin
```

### Using roswell/bin Command

Now that you have added it to PATH, you can launch cl-exercise with only one command:

```
$ cl-exercise
```

Then please open `http://localhost:8000` with a browser(Firefox or Chrome):

### launch cl-exercise with Qlot

```lisp
$ ros run
* (ql:quickload :qlot)
* (qlot:quickload :cl-exercise)
* (cl-exercise:start :port 8000 :debug nil)
```

## Deployment

Please install cl-exercise as above and start the app as following:

```
* (cl-exercise:start :host "http://[GLOBAL_IP_ADDRESS]" :port 80)
```

### Docker(Local)

(work in progress)

```
# plan
$ docker pull tcool/cl-exercise
$ docker run -it -p 8000:8000 --name cl-exercise tcool/cl-exercise
```

### Heroku

(work in progress)

```
$ heroku create --buildpack https://github.com/gos-k/heroku-buildpack-roswell
$ git add .roswell-install-list .roswell-load-system-list app.lisp Procfile
$ git commit -m "Initial commit"
$ git push
```

### DigitalOcean

(work in progress)

```
$ docker-machine create --digitalocean-size "s-2vcpu-4gb" --driver digitalocean --digitalocean-access-token PERSONAL_ACCESS_TOKEN facebox-prod-1
```

## Adding lessons data

You can add your own lessons. The format is as bellow:

The files of lessons are inside `data` directory in JSON format.

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

Copyright (c) 2019 Eddie, t-cool

## License

Licensed under the MIT License.
