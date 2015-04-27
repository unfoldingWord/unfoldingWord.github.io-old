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

        resptext = response.read()

    with open('_data/obs-catalog.json', 'w') as out:
        out.write(resptext)

    return json.loads(resptext)


def get_language_file(langcode):

    with SelfClosingConnection('api.unfoldingword.org') as connection:

        connection.request('GET', '/obs/txt/1/' + langcode + '/obs-' + langcode + '.json')
        response = connection.getresponse()

        # check the status
        if response.status != 200:
            print 'Error retrieving ' + langcode + ': ' + str(response.status) + ': ' + response.reason
            return

        resptext = response.read()

        with open('_data/obs-' + langcode + '.json', 'w') as out:
            out.write(resptext)

        return json.loads(resptext)


def list_to_jekyll_string(value):
    return str(value).replace("', u'", "', '").replace("[u'", "['")


if __name__ == '__main__':

    # get the language list from api.unfoldingword.org
    languages = get_language_list()

    # process the list
    for language in languages:

        langcode = language['language']
        print 'Retrieving ' + langcode

        # retrieve from api.unfoldingword.org
        obs = get_language_file(langcode)

        # set up the language directory
        if os.path.isdir(langcode):
            shutil.rmtree(langcode)

        os.makedirs(langcode)

        # get chapter names
        chapters = []
        chapterTitles = []
        for chapter in obs['chapters']:
            chapters.append(chapter['title'])
            chapterTitles.append(chapter['ref'])

        chapterstr = list_to_jekyll_string(chapters)
        titlestr = list_to_jekyll_string(chapterTitles)

        # create the markdown file
        with open(langcode + '/index.html', 'w') as out:
            out.write('---\n')
            out.write('layout: obs_reveal\n')
            out.write('title: unfoldingWord Open Bible Stories\n')
            out.write('chapters: ' + chapterstr + '\n')
            out.write('chapterTitles: ' + titlestr + '\n')
            out.write('---\n')

    print ''
    print 'Finished'