var Ajax = (function () {
    function Ajax() {
    }
    Ajax.get = function (url, values, callback) {
        var request = Ajax.getRequest();
        // add the values to the query string
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
        // build the post string
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
        // returns null if not successful
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
})();
var FlyOutNotes = (function () {
    function FlyOutNotes() {
        // get the url parts
        var parts = window.location.pathname.split(/\//).filter(function (e) {
            return ((!!e) && (e.indexOf('unfolding') === -1));
        });
        if (parts.length > 2) {
            this.langCode = parts[0];
            this.storyNum = parseInt(parts[2]);
        }
        // create the slide-out
        var slidingDiv = document.createElement('div');
        slidingDiv.setAttribute('id', 'sliding-box');
        // create the tab to activate the slide-out
        var tabDiv = document.createElement('div');
        tabDiv.setAttribute('id', 'sliding-box-tab');
        slidingDiv.appendChild(tabDiv);
        // create the translation notes tab
        var notesDiv = document.createElement('div');
        notesDiv.setAttribute('id', 'notes-button-div');
        notesDiv.setAttribute('class', 'button selected');
        notesDiv.innerHTML = 'Translation Notes';
        notesDiv.addEventListener('click', function () {
            FlyOutNotes.showNotes();
        });
        slidingDiv.appendChild(notesDiv);
        // crete the key terms tab
        var termsDiv = document.createElement('div');
        termsDiv.setAttribute('id', 'terms-button-div');
        termsDiv.setAttribute('class', 'button');
        termsDiv.innerHTML = 'Important Terms';
        termsDiv.addEventListener('click', function () {
            FlyOutNotes.showTerms();
        });
        slidingDiv.appendChild(termsDiv);
        // append all this to the main document
        document.body.appendChild(slidingDiv);
        // get key terms
        Ajax.get('https://api.unfoldingword.org/obs/txt/1/en/kt-en.json', null, function (responseText) {
            var allTerms = JSON.parse(responseText);
            // only keep terms that relate to this story
            flyOutNotes.storyTerms = allTerms.filter(function (o) {
                var ex = o['ex'];
                if (!ex)
                    return false;
                // only keep references that relate to this story
                var keep = ex.filter(function (e) {
                    return parseInt(e['ref'].substr(0, 2)) === flyOutNotes.storyNum;
                });
                if (keep && (keep.length > 0)) {
                    o['ex'] = keep;
                    return true;
                }
                return false;
            });
            // get translation notes
            Ajax.get('https://api.unfoldingword.org/obs/txt/1/en/tN-en.json', null, function (responseText) {
                var allNotes = JSON.parse(responseText);
                // only keep notes that relate to this story
                flyOutNotes.storyNotes = allNotes.filter(function (o) {
                    return (o['id'] && (parseInt(o['id'].substr(0, 2)) === flyOutNotes.storyNum));
                });
                // indicate that loading is finished and enable sliding
                document.getElementById('sliding-box-tab').innerHTML = '<div></div>';
                document.getElementById('sliding-box').setAttribute('class', 'sliding-ready');
                // show any notes or terms that apply to this frame
                flyOutNotes.loadNotes();
            });
        });
    }
    /**
     * Gets the notes and key terms that apply to the current frame and puts them in the slide-out
     */
    FlyOutNotes.prototype.loadNotes = function () {
        // load for the current frame
        this.frameNum = FlyOutNotes.getFrameNumber();
        // look for this id
        var objId = FlyOutNotes.pad(this.storyNum, 2) + '-' + FlyOutNotes.pad(this.frameNum, 2);
        // key terms
        var foundTerms = flyOutNotes.storyTerms.filter(function (item) {
            for (var i = 0; i < item['ex'].length; i++) {
                if (item['ex'][i]['ref'] === objId)
                    return true;
            }
            return false;
        });
        // translation notes
        var foundNotes = flyOutNotes.storyNotes.filter(function (item) {
            return item['id'] === objId;
        });
        console.log(foundTerms);
        FlyOutNotes.makeNotesDiv(foundNotes);
        FlyOutNotes.makeTermsDiv(foundTerms);
        if (foundTerms.length === 0)
            FlyOutNotes.showNotes();
    };
    /**
     * Put the notes for this frame into the translation notes tab
     * @param foundNotes
     */
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
    /**
     * Looks for DokuWiki hyperlinks in the text and converts them to HTML hyperlinks.
     * @param text
     * @returns {string}
     */
    FlyOutNotes.formatHyperlinks = function (text) {
        var regex = new RegExp('(\\[\\[)(.+)(\\]\\])+?');
        return text.replace(regex, function (match, p1, p2, p3) {
            var parts = p2.split('|');
            var url = 'https://door43.org/' + parts[0].replace(/:/g, '/');
            return '<a href="' + url + '" target="_blank">' + parts[1].replace(/[\[\]]+/g, '') + '</a>';
        });
    };
    /**
     * Gets the first bold text block
     * @param text
     * @returns {string}
     */
    FlyOutNotes.getBoldText = function (text) {
        var regex = new RegExp('(<b>)(.+)(</b>)+?');
        var matches = text.match(regex);
        if (matches && (matches.length > 2))
            return matches[2];
        // if you are here there were no matches
        return text;
    };
    /**
     * Gets the current frame number from the location hash
     * @returns {number}
     */
    FlyOutNotes.getFrameNumber = function () {
        var hash = window.location.hash;
        if (hash.length > 2)
            return parseInt(hash.substr(2));
        else
            return 0;
    };
    /**
     * Zero pads numbers
     * @param num
     * @param size
     * @returns {string}
     */
    FlyOutNotes.pad = function (num, size) {
        var s = num + '';
        while (s.length < size)
            s = '0' + s;
        return s;
    };
    return FlyOutNotes;
})();
//# sourceMappingURL=obs-notes.js.map