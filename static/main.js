
const initializeOptions =
  new InitializeOptions()
  .plugins(["cl-exercise"])
  .ignoreSettings(true)
  .debug(DEBUG)
  .asObject();

let client = new EvalClient(HOST, "user_id", "tutor");

let codeMirror;

let check = ExerciseStorage.getCheck(QUESTION_PATH);

function send(code, resultElement, callback) {
  client.initialize(initializeOptions)
    .then(() => {
      client.eval(QUESTION.prepare)
       .then(() => {
         const options = {
           test: QUESTION.test,
           expect: QUESTION.expect,
           requirements: QUESTION.requirements
         };
         client.eval(code, null, null, options)
           .then(res => {
             callback();
             let result = res.result;
             console.log(res);
             const returnValueElement = `<blockquote>${result.returnValue}</blockquote>`;
             const outputElement = `<pre><strong>Output</strong>:\n${result.output}</pre>`;
             resultElement.innerHTML = returnValueElement + outputElement;
             if (checkCorrect(result.optional)) {
               resultElement.innerHTML += "<strong>正解</strong>";
               let modalElement = document.querySelector(".modal");
               modalElement.classList.add("is-active");
             }
           })
           .catch(err => {
             callback();
             console.log(err);
           })
        })
       .catch(() => {
         callback();
         console.error("Error has thrown when preparing the question.");
       })
    })
}
function checkCorrect(optional) {
  check = ((optional.test && optional.testResult==='T')||!optional.test) &&
          ((optional.expect && optional.expectResult==='T')||!optional.expect) &&
          ((optional.requirements.symbols && optional.sexpResult==='T')||!optional.requirements.symbols);
  ExerciseStorage.setCheck(QUESTION_PATH, check);
  return check;
}
function onclickEvalButton() {
  let editor = document.getElementById("editor");
  let result = document.getElementById("result");
  let button = document.getElementById("eval-button");
  result.innerHTML = "";
  button.classList.add("is-loading");
  button.blur();
  send(codeMirror.getValue().trim(), result, () => button.classList.remove("is-loading"));
}

function closeModal(e) {
  let modalElement = document.querySelector(".modal");
  modalElement.classList.remove("is-active");
}

function createMediaIframe() {
  let frame = document.createElement("iframe");
  frame.classList.add("media");
  frame.frameborder = "0";
  frame.setAttribute("frameborder", "0")
  frame.setAttribute("gesture", "media");
  frame.setAttribute("allowfullscreen", "allowfullscreen")
  return frame;
}

function embedMedia(src) {
  const youtubeEmbedSchema = /^https:\/\/www.youtube.com\/embed\/.+/;
  const youtubeWatchSchema = /^https:\/\/www.youtube.com\/watch\?v=(.+)/;
  let mediaElement = document.getElementById("media-area");
  let watchSchemaResult = null;
  if (src.match(youtubeEmbedSchema)) {
    let frame = createMediaIframe();
    mediaElement.appendChild(frame);
    frame.src = src;
  } else if (watchSchemaResult = src.match(youtubeWatchSchema)) {
    let frame = createMediaIframe();
    mediaElement.appendChild(frame);
    frame.src = `https://www.youtube.com/embed/${watchSchemaResult[1]}`;
  } else {
    console.error("Unknown media");
  }
}

window.onload = () => {
  if (QUESTION.media) {
    embedMedia(QUESTION.media);
  }
  let modalBgElement = document.querySelector(".modal-background");
  let modalCloseButton = document.querySelector(".modal-close");
  modalBgElement.onclick = closeModal;
  modalCloseButton.onclick = closeModal;
  let title = document.getElementById("title");
  title.innerHTML = marked("# "+TITLE);
  let description = document.getElementById("description");
  description.innerHTML = marked(DESCRIPTION);
  let question = document.getElementById("question");
  question.innerHTML = marked("## Exercise\n"+CONTENT);
  let editor = document.getElementById("editor");
  codeMirror = CodeMirror.fromTextArea(editor, {
    mode: "commonlisp",
    lineNumbers: true,
    tabSize: 2,
    matchBrackets: true,
    autofocus: true,
    viewportMargin: Infinity
  });
  codeMirror.setSize("100%", "auto");
  codeMirror.setValue(ExerciseStorage.getAnswer(QUESTION_PATH));
  window.onbeforeunload = () => {
    ExerciseStorage.setAnswer(QUESTION_PATH, codeMirror.getValue());
  }
}
