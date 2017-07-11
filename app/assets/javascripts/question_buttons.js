function addAnswer() {
    var container = document.getElementById("answers-box");
    var count = countChildren(container) + 1;

    var div = document.createElement("div");
    div.className = "answer";

    var tmp = document.createElement("div");
    tmp.className = "upper-box";

    var points = document.createElement("input");
    points.className = "private-points-input";
    points.type = "number";
    points.min = 0;
    points.max = total_points_per_question;
    points.value = 0;
    points.name = "answers[" + count + "][points]";
    tmp.appendChild(points);

    var input = document.createElement("input");
    input.type = "text";
    input.name = "answers[" + count + "][answer]";
    input.placeholder = "reponse " + count;
    input.className = "answer-input";
    tmp.appendChild(input);

    div.appendChild(tmp);

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
