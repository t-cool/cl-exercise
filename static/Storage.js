
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
  static download() {
    let text = JSON.stringify(localStorage);
    window.open(`data:text/plain;charset=utf-8,${encodeURIComponent(text)}`, "_blank");
  }
  static restore(file, progress, callback = null) {
    let reader = new FileReader();
    reader.readAsText(file);
    reader.onloadstart = () => {
      progress.value = 0;
      progress.textContent = "0%";
    };
    reader.onload = () => {
      const json = JSON.parse(reader.result);
      for (let key in json) {
        localStorage.setItem(key, json[key]);
      }
      if (callback) callback();
    };
    reader.onprogress = (e) => {
      if (e.lengthComputable) {
        let percentLoaded = Math.round((e.loaded / e.total) * 100);
        if (percentLoaded < 100) {
          progress.value = percentLoaded;
          progress.textContent = percentLoaded + '%';
        }
      }
    };
  }
}
