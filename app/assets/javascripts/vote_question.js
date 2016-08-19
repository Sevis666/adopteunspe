function setUpvoted(div) {
    div.className = "vote-form upvoted";
    var p = div.getElementsByClassName("previousvote")[0];
    d = 1 - p.value;
    p.value = 1;
    var points = div.getElementsByClassName("votes")[0];
    points.innerHTML = Number(points.innerHTML) + d;
}
function setDownvoted(div) {
    div.className = "vote-form downvoted";
    var p = div.getElementsByClassName("previousvote")[0];
    d = -1 - p.value;
    p.value = -1;
    var points = div.getElementsByClassName("votes")[0];
    points.innerHTML = Number(points.innerHTML) + d;
}
