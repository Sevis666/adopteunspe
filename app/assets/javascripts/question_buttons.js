function addAnswer() {
    var container = document.getElementById("answers-box");
    var count = countChildren(container) + 1;

    var div = document.createElement("div");
    div.className = "answer";

    var tmp = document.createElement("div");
    tmp.className = "upper-box";
    var input = document.createElement("input");
    input.type = "text";
    input.name = "answers[" + count + "][answer]";
    input.placeholder = "reponse " + count;
    input.className = "answer-input";
    tmp.appendChild(input);

    var button = document.createElement("div");
    button.className = "button";
    button.onclick = function() {addStudentsPoints(pointsDiv, count);};
    tmp.appendChild(button);
    div.appendChild(tmp);

    var pointsDiv = document.createElement("div");
    addStudentsPoints(pointsDiv, count);
    div.appendChild(pointsDiv);

    container.appendChild(div);
}

function countChildren(parent) {
    var relevantChildren = 0;
    var children = parent.childNodes.length;
    for(var i=0; i<children; i++) {
        if (parent.childNodes[i].nodeType != 3)
            relevantChildren++;
    }
    return relevantChildren;
}
