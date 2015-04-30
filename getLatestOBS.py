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
import os
import shutil


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
        catalogout.write(json.dumps(langlist))

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

    # process the list
    for language in languages:

        langcode = language['language']
        checklevel = language['status']['checking_level']

        print 'Retrieving ' + langcode

        # retrieve from api.unfoldingword.org
        obs = get_language_file(langcode)

        # set up the language directory
        if os.path.isdir(langcode):
            shutil.rmtree(langcode)

        path360 = os.path.join(langcode, '360px')
        path2160 = os.path.join(langcode, '2160px')

        os.makedirs(path360)
        os.makedirs(path2160)

        # get chapter names
        chapters = []
        counter = 1
        for chapter in obs['chapters']:
            chapters.append([format(counter, '02d'), chapter['title']])
            counter += 1
        chapterstr = json.dumps(chapters)

        # get i18n
        appwords = json.dumps(obs['app_words'])

        # get chapter data
        nextchap = None
        for chapter in reversed(obs['chapters']):

            # get the chapter number
            chapterNum = chapter['frames'][0]['id'].split('-')[0]
            chapterDir360 = os.path.join(path360, chapterNum)
            chapterDir2160 = os.path.join(path2160, chapterNum)
            os.makedirs(chapterDir360)
            os.makedirs(chapterDir2160)

            # create the 360px markdown file
            with open(os.path.join(chapterDir360, 'index.html'), 'w') as out:
                out.write(get_front_matter(langcode, checklevel, chapterNum,
                                           json.dumps(chapter['title']), json.dumps(chapter['ref']),
                                           chapterstr, json.dumps(chapter['frames']), appwords, '360', nextchap))

            # create the 2160px markdown file
            with open(os.path.join(chapterDir2160, 'index.html'), 'w') as out:
                out.write(get_front_matter(langcode, checklevel, chapterNum,
                                           json.dumps(chapter['title']), json.dumps(chapter['ref']),
                                           chapterstr, json.dumps(chapter['frames']).replace("360px", "2160px"),
                                           appwords, '2160', nextchap))

            nextchap = chapterNum

    print ''
    print 'Finished'