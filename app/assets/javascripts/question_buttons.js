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

function addStudentsPoints(parent, count) {
    var div = document.createElement("div");
    div.className = "student-points";

    var dropdown = document.createElement("select");
    dropdown.name = "answers[" + count + "][points][" + (countChildren(parent) + 1) + "][student]";
    // Fix for Lison always getting 0 points
    var o = document.createElement("option");
    o.value = "";
    o.text = "";
    dropdown.appendChild(o);

    for (var i=0; i<students.length; i++) {
        var option = document.createElement("option");
        option.value = studentIds[i];
        option.text = students[i];
        dropdown.appendChild(option);
    }
    div.appendChild(dropdown);

    var pointsInput = document.createElement("input");
    pointsInput.type = "number"
    pointsInput.name = "answers[" + count + "][points][" + (countChildren(parent) + 1) + "][value]";
    pointsInput.value = 0;
    pointsInput.min = 0;
    pointsInput.max = 10;
    pointsInput.class = "points-counter";
    div.appendChild(pointsInput);

    parent.appendChild(div);
}
