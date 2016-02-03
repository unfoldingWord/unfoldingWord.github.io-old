var Ajax = (function () {
    function Ajax() {
    }
    Ajax.get = function (url, values, callback) {
        var request = Ajax.getRequest();
        if (values) {
            var qs = Ajax.getValueString(values);
            if (qs)
                url += '?' + qs;
        }
        if (callback)
            Ajax.attachCallback(request, callback);
        request.open('GET', url, true);
        request.send();
    };
    Ajax.post = function (url, values, callback) {
        var request = Ajax.getRequest();
        var postString;
        if (values)
            postString = Ajax.getValueString(values);
        if (callback)
            Ajax.attachCallback(request, callback);
        request.open('POST', url, true);
        request.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        request.send(postString);
    };
    Ajax.attachCallback = function (request, callback) {
        request.onreadystatechange = function () {
            if (request.readyState == 4 && request.status == 200) {
                callback(request.responseText);
            }
        };
    };
    Ajax.getValueString = function (values) {
        var keys = Object.keys(values);
        var qs;
        for (var i = 0; i < keys.length; i++) {
            if (qs)
                qs += '&' + keys[i] + '=' + encodeURIComponent(values[keys[i]]);
            else
                qs = keys[i] + '=' + encodeURIComponent(values[keys[i]]);
        }
        return qs;
    };
    Ajax.getRequest = function () {
        var request;
        if (window['ActiveXObject']) {
            try {
                request = new ActiveXObject("Msxml2.XMLHTTP");
            }
            catch (e) {
                try {
                    request = new ActiveXObject("Microsoft.XMLHTTP");
                }
                catch (e) {
                    return null;
                }
            }
        }
        else if (window['XMLHttpRequest']) {
            request = new XMLHttpRequest();
        }
        else
            return null;
        if (request != null)
            request.abort();
        return request;
    };
    return Ajax;
}());
var FlyOutNotes = (function () {
    function FlyOutNotes() {
        var parts = window.location.pathname.match(/\/(\w*)\/\d*px\/(\d*)\//);
        if (parts.length > 2) {
            this.langCode = parts[1];
            this.storyNum = parseInt(parts[2]);
        }
        var slidingDiv = document.createElement('div');
        slidingDiv.setAttribute('id', 'sliding-box');
        var tabDiv = document.createElement('div');
        tabDiv.setAttribute('id', 'sliding-box-tab');
        slidingDiv.appendChild(tabDiv);
        var notesDiv = document.createElement('div');
        notesDiv.setAttribute('id', 'notes-button-div');
        notesDiv.setAttribute('class', 'button selected');
        notesDiv.innerHTML = 'Translation Notes';
        notesDiv.addEventListener('click', function () { FlyOutNotes.showNotes(); });
        slidingDiv.appendChild(notesDiv);
        var termsDiv = document.createElement('div');
        termsDiv.setAttribute('id', 'terms-button-div');
        termsDiv.setAttribute('class', 'button');
        termsDiv.innerHTML = 'Important Terms';
        termsDiv.addEventListener('click', function () { FlyOutNotes.showTerms(); });
        slidingDiv.appendChild(termsDiv);
        document.body.appendChild(slidingDiv);
        Ajax.get('https://api.unfoldingword.org/obs/txt/1/en/kt-en.json', null, function (responseText) {
            var allTerms = JSON.parse(responseText);
            flyOutNotes.storyTerms = allTerms.filter(function (o) {
                var ex = o['ex'];
                if (!ex)
                    return false;
                var keep = ex.filter(function (e) {
                    return parseInt(e['ref'].substr(0, 2)) === flyOutNotes.storyNum;
                });
                if (keep && (keep.length > 0)) {
                    o['ex'] = keep;
                    return true;
                }
                return false;
            });
            Ajax.get('https://api.unfoldingword.org/obs/txt/1/en/tN-en.json', null, function (responseText) {
                var allNotes = JSON.parse(responseText);
                flyOutNotes.storyNotes = allNotes.filter(function (o) {
                    return (o['id'] && (parseInt(o['id'].substr(0, 2)) === flyOutNotes.storyNum));
                });
                document.getElementById('sliding-box-tab').innerHTML = '<div></div>';
                document.getElementById('sliding-box').setAttribute('class', 'sliding-ready');
                flyOutNotes.loadNotes();
            });
        });
    }
    FlyOutNotes.prototype.loadNotes = function () {
        this.frameNum = FlyOutNotes.getFrameNumber();
        var objId = FlyOutNotes.pad(this.storyNum, 2) + '-' + FlyOutNotes.pad(this.frameNum, 2);
        var foundTerms = flyOutNotes.storyTerms.filter(function (item) {
            for (var i = 0; i < item['ex'].length; i++) {
                if (item['ex'][i]['ref'] === objId)
                    return true;
            }
            return false;
        });
        var foundNotes = flyOutNotes.storyNotes.filter(function (item) {
            return item['id'] === objId;
        });
        console.log(foundTerms);
        FlyOutNotes.makeNotesDiv(foundNotes);
        FlyOutNotes.makeTermsDiv(foundTerms);
        if (foundTerms.length === 0)
            FlyOutNotes.showNotes();
    };
    FlyOutNotes.makeNotesDiv = function (foundNotes) {
        var notesDiv = document.getElementById('tx-notes');
        if (!notesDiv) {
            notesDiv = document.createElement('div');
            notesDiv.setAttribute('id', 'tx-notes');
            notesDiv.setAttribute('class', 'notes');
            var slidingDiv = document.getElementById('sliding-box');
            slidingDiv.appendChild(notesDiv);
        }
        notesDiv.innerHTML = '';
        for (var i = 0; i < foundNotes.length; i++) {
            var foundItems = foundNotes[i]['tn'];
            for (var j = 0; j < foundItems.length; j++) {
                var note = foundItems[j];
                var ref = document.createElement('p');
                ref.innerHTML = note['ref'];
                ref.setAttribute('class', 'bold-title');
                notesDiv.appendChild(ref);
                var text = document.createElement('p');
                text.innerHTML = FlyOutNotes.formatHyperlinks(note['text']);
                notesDiv.appendChild(text);
            }
        }
    };
    FlyOutNotes.makeTermsDiv = function (foundTerms) {
        var termsDiv = document.getElementById('key-terms');
        if (!termsDiv) {
            termsDiv = document.createElement('div');
            termsDiv.setAttribute('id', 'key-terms');
            termsDiv.setAttribute('class', 'notes');
            termsDiv.style.display = 'none';
            var slidingDiv = document.getElementById('sliding-box');
            slidingDiv.appendChild(termsDiv);
        }
        termsDiv.innerHTML = '';
        for (var i = 0; i < foundTerms.length; i++) {
            var term = foundTerms[i]['term'];
            for (var j = 0; j < foundTerms[i]['aliases'].length; j++) {
                term += ', ' + foundTerms[i]['aliases'][j];
            }
            var def = foundTerms[i]['def'];
            var ref = document.createElement('p');
            ref.innerHTML = term;
            ref.setAttribute('class', 'bold-title');
            termsDiv.appendChild(ref);
            var text = document.createElement('p');
            text.innerHTML = FlyOutNotes.formatHyperlinks(def);
            termsDiv.appendChild(text);
        }
    };
    FlyOutNotes.showNotes = function () {
        document.getElementById('notes-button-div').setAttribute('class', 'button selected');
        document.getElementById('terms-button-div').setAttribute('class', 'button');
        document.getElementById('tx-notes').style.display = '';
        document.getElementById('key-terms').style.display = 'none';
    };
    FlyOutNotes.showTerms = function () {
        document.getElementById('notes-button-div').setAttribute('class', 'button');
        document.getElementById('terms-button-div').setAttribute('class', 'button selected');
        document.getElementById('tx-notes').style.display = 'none';
        document.getElementById('key-terms').style.display = '';
    };
    FlyOutNotes.formatHyperlinks = function (text) {
        var regex = new RegExp('(\\[\\[)(.+)(\\]\\])+?');
        return text.replace(regex, function (match, p1, p2, p3) {
            var parts = p2.split('|');
            var url = 'https://door43.org/' + parts[0].replace(/:/g, '/');
            return '<a href="' + url + '" target="_blank">' + parts[1].replace(/[\[\]]+/g, '') + '</a>';
        });
    };
    FlyOutNotes.getBoldText = function (text) {
        var regex = new RegExp('(<b>)(.+)(</b>)+?');
        var matches = text.match(regex);
        if (matches && (matches.length > 2))
            return matches[2];
        return text;
    };
    FlyOutNotes.getFrameNumber = function () {
        var hash = window.location.hash;
        if (hash.length > 2)
            return parseInt(hash.substr(2));
        else
            return 0;
    };
    FlyOutNotes.pad = function (num, size) {
        var s = num + '';
        while (s.length < size)
            s = '0' + s;
        return s;
    };
    return FlyOutNotes;
}());
