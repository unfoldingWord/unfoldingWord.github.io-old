#!/usr/bin/env python
# -*- coding: utf8 -*-
#
# Copyright (c) 2015 unfoldingWord
# http://creativecommons.org/licenses/MIT/
# See LICENSE file for details.
#
#  Contributors:
#  Phil Hopper <phillip_hopper@wycliffeassociates.org>
#
import httplib
import json


class SelfClosingConnection(httplib.HTTPSConnection):
    """
    This class is here to enable with...as functionality for the HHTPConnection
    """

    def __enter__(self):
        return self

    # noinspection PyUnusedLocal
    def __exit__(self, exception_type, exception_val, trace):
        self.close()


def get_language_list():

    with SelfClosingConnection('api.unfoldingword.org') as connection:

        connection.request('GET', '/obs/txt/1/obs-catalog.json')
        response = connection.getresponse()

        # check the status
        if response.status != 200:
            print 'Error ' + str(response.status) + ': ' + response.reason
            return None

        langlist = json.loads(response.read())

    # sort the list of languages by language code
    langlist.sort(key=lambda x: x['language'])

    with open('_data/obs-catalog.json', 'w') as catalogout:
        catalogout.write(json.dumps(langlist, indent=2, separators=(',', ': ')))

    return langlist


def get_language_file(langcodestr):

    with SelfClosingConnection('api.unfoldingword.org') as connection:

        connection.request('GET', '/obs/txt/1/' + langcodestr + '/obs-' + langcodestr + '.json')
        response = connection.getresponse()

        # check the status
        if response.status != 200:
            print 'Error retrieving ' + langcodestr + ': ' + str(response.status) + ': ' + response.reason
            return

        resptext = response.read()

        with open('_data/obs-' + langcodestr + '.json', 'w') as langfileout:
            langfileout.write(resptext)

        return json.loads(resptext)


def get_front_matter(code, check, chapnum, chapname, chaptitle, chaps, frames, words, imgsize, nextone):

    returnval = '---\n'
    returnval += 'layout: obs_reveal\n'
    returnval += 'title: unfoldingWord Open Bible Stories\n'
    returnval += 'languageCode: ' + code + '\n'
    returnval += 'checkingLevel: ' + check + '\n'
    returnval += 'chapterNumber: ' + chapnum + '\n'
    returnval += 'chapterName: ' + chapname + '\n'
    returnval += 'chapterTitle: ' + chaptitle + '\n'
    returnval += 'chapters: ' + chaps + '\n'
    returnval += 'frames: ' + frames + '\n'
    returnval += 'appWords: ' + words + '\n'
    returnval += 'imageSize: ' + imgsize + '\n'

    if nextone is not None:
        returnval += 'nextChapter: ' + nextone + '\n'

    returnval += '---\n'

    return returnval


if __name__ == '__main__':

    # get the language list from api.unfoldingword.org
    languages = get_language_list()

    print 'Finished'
