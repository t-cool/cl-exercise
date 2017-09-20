
const initializeOptions =
  new InitializeOptions()
  .plugins(["cl-exercise"])
  .ignoreSettings(true)
  .debug(DEBUG)
  .asObject();

let client = new EvalClient(HOST, "user_id", "tutor");

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
             resultElement.innerHTML = `<p>戻り値:${result.returnValue}</p><pre>${result.output}</pre>`;
             if (checkCorrect(result.optional)) {
               resultElement.innerHTML += "<strong>正解</strong>";
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
  let loader = document.getElementById("eval-loader");
  result.innerHTML = "";
  loader.classList.add("show");
  send(editor.innerText.trim(), result, () => loader.classList.remove("show"));
}

window.onload = () => {
  let description = document.getElementById("description");
  description.innerHTML = marked("# "+TITLE+"\n"+DESCRIPTION);
  let editor = document.getElementById("editor");
  editor.innerText = ExerciseStorage.getAnswer(QUESTION_PATH);
  window.onbeforeunload = () => {
    ExerciseStorage.setAnswer(QUESTION_PATH, editor.innerText);
  }
}
