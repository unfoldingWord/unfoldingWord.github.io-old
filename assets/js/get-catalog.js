
function getCatalog(response) {

    // check for blank response
    if (!response) return;

    var arr = JSON.parse(response);

    //sort by language property
    arr.sort(function(a,b){
        return a.language.toLowerCase().localeCompare(b.language.toLowerCase());
    });

    var items = [];

    for (var i = 0; i < arr.length; i++) {
        var item = arr[i];
        items.push(buildListItem(item.string, item.language, item.status));
    }

    document.getElementById("id01").innerHTML = '<div><ul>\n' + items.join('\n') + '</ul></div>\n';
}

function buildListItem(langName, langCode, status) {

    var cssClass = "languages checking-level-" + status.checking_level;
    var lowRes = 'https://unfoldingword.org/' + langCode + '/360px/01/';
    var highRes = 'https://unfoldingword.org/' + langCode + '/2160px/01/';
    var pdfUrl = 'https://api.unfoldingword.org/obs/txt/1/' + langCode + '/obs-' + langCode + '-v' + status.version.replace(/[ .]/g, '_') + '.pdf';

    // li text
    // 2015-03-09, PH: span added to fix an issue of text not displaying in IE if the name of the language uses a
    //                 different writing system than the rest of the line, which uses the Latin writing system
    var html = '<span>' + langName + '</span> (' + langCode + ')';

    // low res link
    html += ' <a class="img_swap" href="' + lowRes + '"><img class="languages" src="' + pathJoin(BASE_URL, '/assets/img/obs/low_res_h.png') + '"></a>';

    // high res link
    html += ' <a class="img_swap" href="' + highRes + '"><img class="languages" src="' + pathJoin(BASE_URL, '/assets/img/obs/high_res_h.png') + '"></a>';

    // pdf link
    html += ' <a class="img_swap" href="' + pdfUrl + '"><img class="languages" src="' + pathJoin(BASE_URL, '/assets/img/obs/download_h.png') + '"></a>';

    return '<li class="' + cssClass + '">' + html + '</li>';
}
