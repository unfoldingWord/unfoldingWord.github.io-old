
class Ajax {

	static get(url: string, values?: Object,  callback?: Function) {

		var request: XMLHttpRequest = Ajax.getRequest();

		// add the values to the query string
		if (values) {
			var qs: string = Ajax.getValueString(values);
			if (qs) url += '?' + qs;
		}

		if (callback) Ajax.attachCallback(request, callback);

		request.open('GET', url, true);
		request.send();
	}

	static post(url: string, values?: Object,  callback?: Function) {

		var request: XMLHttpRequest = Ajax.getRequest();

		// build the post string
		var postString: string;
		if (values)
			postString = Ajax.getValueString(values);

		if (callback) Ajax.attachCallback(request, callback);


		request.open('POST', url, true);
		request.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
		request.send(postString);
	}

	private static attachCallback(request: XMLHttpRequest, callback: Function): void {

		request.onreadystatechange = function() {

			if (request.readyState == 4 && request.status == 200) {
				callback(request.responseText);
			}
		}
	}

	private static getValueString(values: Object): string {

		var keys = Object.keys(values);
		var qs: string;
		for (var i = 0; i < keys.length; i++) {
			if (qs)
				qs += '&' + keys[i] + '=' + encodeURIComponent(values[keys[i]]);
			else
				qs = keys[i] + '=' + encodeURIComponent(values[keys[i]]);
		}

		return qs;
	}

	private static getRequest(): XMLHttpRequest {

		// returns null if not successful
		var request: XMLHttpRequest;

		if (window['ActiveXObject']){ // if IE
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
		else if (window['XMLHttpRequest']) { // Mozilla, Safari etc
			request = new XMLHttpRequest();
		}
		else return null;

		if (request != null) request.abort();

		return request;
	}
}

class FlyOutNotes {

	langCode: string;
	storyNum: number;
	frameNum: number;
	storyTerms: Object[];
	storyNotes: Object[];

	constructor() {

		// get the url parts
		var parts = window.location.pathname.match(/\/(\w*)\/\d*px\/(\d*)\//);
		if (parts.length > 2) {
			this.langCode = parts[1];
			this.storyNum = parseInt(parts[2]);
		}

		// create the slide-out
		var slidingDiv: HTMLDivElement = document.createElement('div');
		slidingDiv.setAttribute('id', 'sliding-box');

		// create the tab to activate the slide-out
		var tabDiv: HTMLDivElement = document.createElement('div');
		tabDiv.setAttribute('id', 'sliding-box-tab');
		slidingDiv.appendChild(tabDiv);

		// create the translation notes tab
		var notesDiv: HTMLDivElement = document.createElement('div');
		notesDiv.setAttribute('id', 'notes-button-div');
		notesDiv.setAttribute('class', 'button selected');
		notesDiv.innerHTML = 'Translation Notes';
		notesDiv.addEventListener('click', function() { FlyOutNotes.showNotes() });
		slidingDiv.appendChild(notesDiv);

		// crete the key terms tab
		var termsDiv: HTMLDivElement = document.createElement('div');
		termsDiv.setAttribute('id', 'terms-button-div');
		termsDiv.setAttribute('class', 'button');
		termsDiv.innerHTML = 'Important Terms';
		termsDiv.addEventListener('click', function() { FlyOutNotes.showTerms() });
		slidingDiv.appendChild(termsDiv);

		// append all this to the main document
		document.body.appendChild(slidingDiv);

		// get key terms
		Ajax.get('https://api.unfoldingword.org/obs/txt/1/en/kt-en.json', null, function(responseText: string) {

			var allTerms: Object[] = JSON.parse(responseText);

			// only keep terms that relate to this story
			flyOutNotes.storyTerms = allTerms.filter(function(o) {

				var ex: Object[] = o['ex'];

				if (!ex) return false;

				// only keep references that relate to this story
				var keep = ex.filter(function(e) {
					return parseInt(e['ref'].substr(0, 2)) === flyOutNotes.storyNum;
				});

				if (keep && (keep.length > 0)) {
					o['ex'] = keep;
					return true;
				}

				return false;
			});

			// get translation notes
			Ajax.get('https://api.unfoldingword.org/obs/txt/1/en/tN-en.json', null, function(responseText: string) {

				var allNotes: Object[] = JSON.parse(responseText);

				// only keep notes that relate to this story
				flyOutNotes.storyNotes = allNotes.filter(function(o) {
					return (o['id'] && (parseInt(o['id'].substr(0, 2)) === flyOutNotes.storyNum));
				});

				// indicate that loading is finished and enable sliding
				document.getElementById('sliding-box-tab').innerHTML = '<div></div>';
				document.getElementById('sliding-box').setAttribute('class', 'sliding-ready');

				// show any notes or terms that apply to this frame
				flyOutNotes.loadNotes()
			});
		});
	}

	/**
	 * Gets the notes and key terms that apply to the current frame and puts them in the slide-out
	 */
	loadNotes(): void {

		// load for the current frame
		this.frameNum = FlyOutNotes.getFrameNumber();

		// look for this id
		var objId: string = FlyOutNotes.pad(this.storyNum, 2) + '-' + FlyOutNotes.pad(this.frameNum, 2);

		// key terms
		var foundTerms: Object[] = flyOutNotes.storyTerms.filter(function(item) {
			for (var i = 0; i < item['ex'].length; i++) {
				if (item['ex'][i]['ref'] === objId) return true;
			}
			return false
		});

		// translation notes
		var foundNotes: Object[] = flyOutNotes.storyNotes.filter(function(item) {
			return item['id'] === objId;
		});

		console.log(foundTerms);
		FlyOutNotes.makeNotesDiv(foundNotes);
		FlyOutNotes.makeTermsDiv(foundTerms);

		if (foundTerms.length === 0) FlyOutNotes.showNotes();
	}

	/**
	 * Put the notes for this frame into the translation notes tab
	 * @param foundNotes
	 */
	private static makeNotesDiv(foundNotes: Object[]): void {

		var notesDiv: HTMLDivElement = <HTMLDivElement>document.getElementById('tx-notes');
		if (!notesDiv) {
			notesDiv = document.createElement('div');
			notesDiv.setAttribute('id', 'tx-notes');
			notesDiv.setAttribute('class', 'notes');

			var slidingDiv: HTMLDivElement = <HTMLDivElement>document.getElementById('sliding-box');
			slidingDiv.appendChild(notesDiv);
		}

		notesDiv.innerHTML = '';

		for (var i = 0; i < foundNotes.length; i++) {

			var foundItems: Object[] = foundNotes[i]['tn'];

			for (var j = 0; j < foundItems.length; j++) {

				var note: Object = foundItems[j];

				var ref: HTMLParagraphElement = <HTMLParagraphElement>document.createElement('p');
				ref.innerHTML = note['ref'];
				ref.setAttribute('class', 'bold-title');
				notesDiv.appendChild(ref);

				var text: HTMLParagraphElement = <HTMLParagraphElement>document.createElement('p');
				text.innerHTML = FlyOutNotes.formatHyperlinks(note['text']);
				notesDiv.appendChild(text);
			}
		}
	}

	private static makeTermsDiv(foundTerms: Object[]): void {

		var termsDiv: HTMLDivElement = <HTMLDivElement>document.getElementById('key-terms');
		if (!termsDiv) {
			termsDiv = document.createElement('div');
			termsDiv.setAttribute('id', 'key-terms');
			termsDiv.setAttribute('class', 'notes');
			termsDiv.style.display = 'none';

			var slidingDiv: HTMLDivElement = <HTMLDivElement>document.getElementById('sliding-box');
			slidingDiv.appendChild(termsDiv);
		}

		termsDiv.innerHTML = '';

		for (var i = 0; i < foundTerms.length; i++) {

			var term: string = foundTerms[i]['term'];

			for (var j = 0; j < foundTerms[i]['aliases'].length; j++) {
				term += ', ' + foundTerms[i]['aliases'][j];
			}

			var def: string = foundTerms[i]['def'];

			var ref: HTMLParagraphElement = <HTMLParagraphElement>document.createElement('p');
			ref.innerHTML = term;
			ref.setAttribute('class', 'bold-title');
			termsDiv.appendChild(ref);

			var text: HTMLParagraphElement = <HTMLParagraphElement>document.createElement('p');
			text.innerHTML = FlyOutNotes.formatHyperlinks(def);
			termsDiv.appendChild(text);
		}
	}

	public static showNotes(): void {

		document.getElementById('notes-button-div').setAttribute('class', 'button selected');
		document.getElementById('terms-button-div').setAttribute('class', 'button');

		document.getElementById('tx-notes').style.display = '';
		document.getElementById('key-terms').style.display = 'none';
	}

	public static showTerms(): void {

		document.getElementById('notes-button-div').setAttribute('class', 'button');
		document.getElementById('terms-button-div').setAttribute('class', 'button selected');

		document.getElementById('tx-notes').style.display = 'none';
		document.getElementById('key-terms').style.display = '';
	}

	/**
	 * Looks for DokuWiki hyperlinks in the text and converts them to HTML hyperlinks.
	 * @param text
	 * @returns {string}
	 */
	private static formatHyperlinks(text: string): string {

		var regex = new RegExp('(\\[\\[)(.+)(\\]\\])+?');
		return text.replace(regex, function(match, p1, p2, p3) {
			var parts: string[] = p2.split('|');
			var url: string = 'https://door43.org/' + parts[0].replace(/:/g, '/');
			return '<a href="' + url + '" target="_blank">' + parts[1].replace(/[\[\]]+/g, '') + '</a>';
		});
	}

	/**
	 * Gets the first bold text block
	 * @param text
	 * @returns {string}
	 */
	private static getBoldText(text: string): string {

		var regex = new RegExp('(<b>)(.+)(</b>)+?');

		var matches = text.match(regex);

		if (matches && (matches.length > 2))
			return matches[2];

		// if you are here there were no matches
		return text;
	}

	/**
	 * Gets the current frame number from the location hash
	 * @returns {number}
	 */
	private static getFrameNumber(): number {
		var hash: string = window.location.hash;
		if (hash.length > 2)
			return parseInt(hash.substr(2));
		else
			return 0;
	}

	/**
	 * Zero pads numbers
	 * @param num
	 * @param size
	 * @returns {string}
	 */
	private static pad(num, size): string {
		var s = num + '';
		while (s.length < size) s = '0' + s;
		return s;
	}
}

declare var flyOutNotes: FlyOutNotes;
