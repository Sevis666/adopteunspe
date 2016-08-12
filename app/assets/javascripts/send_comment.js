function sendComment(form) {
    var comment = form.getElementsByClassName("comment-input")[0];
    var str = comment.value;
    comment.value = "";
    form.getElementsByClassName("comment-hidden")[0].value = str;

    form.className="add-comment-box";

    var div = form.parentNode;
    var p = document.createElement("p");
    p.className = "comment";
    var t = document.createTextNode(fullName + " : " + str);
    p.appendChild(t);
    div.insertBefore(p, div.childNodes[div.childNodes.length-2]);
}
