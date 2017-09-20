
const __ES_ANSWER__= "answer";
const __ES_CHECK__ = "check";

class ExerciseStorage {
  static setAnswer(key, answer) {
    const real = `${__ES_ANSWER__}/${key}`;
    localStorage.setItem(real, answer);
  }
  static setCheck(key, check) {
    const real = `${__ES_CHECK__}/${key}`;
    localStorage.setItem(real, check);
  }
  static getAnswer(key) {
    const real = `${__ES_ANSWER__}/${key}`;
    let tmp = localStorage.getItem(real);
    return tmp ? tmp : "";
  }
  static getCheck(key) {
    const real = `${__ES_CHECK__}/${key}`;
    let tmp = localStorage.getItem(real);
    return tmp ? tmp === "true" : false;
  }
}
