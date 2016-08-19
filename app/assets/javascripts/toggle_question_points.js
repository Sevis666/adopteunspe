function showAnswerPoints(div) {
    var c = div.parentNode.parentNode.className;
    if (c == "question-box") {
        c = "question-box shown";
    } else {
        c = "question-box";
    }
    div.parentNode.parentNode.className = c;
}
