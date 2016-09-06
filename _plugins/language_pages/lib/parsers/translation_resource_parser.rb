# noinspection RubyStringKeysInHashInspection
class TranslationResourceParser

  def initialize(language_data)
    @language = language_data['lc']
  end

  def parse
    resources = {}
    unless @language == 'en'
      return resources
    end

    # there is just one tW file
    resources['tW'] = {
        'name' => 'translationWords',
        'href' => 'http://cdn.door43.org/en/tw/v3/pdf/tw-v3.pdf'
    }

    # there is one tN and tQ file per book of the Bible
    notes = []
    questions = []
    note_url = 'http://cdn.door43.org/%s/tn/v3/pdf/tn-%s-%s-v3.pdf'
    question_url = 'http://cdn.door43.org/%s/tq/v3/pdf/tq-%s-%s-v3.pdf'

    BibleBooksParser.usfm_books.each do |book_id, name_and_number|
      notes << ({
          'name' => name_and_number[0],
          'href' => note_url % [@language, name_and_number[1], book_id]
                   })
      questions << ({
          'name' => name_and_number[0],
          'href' => question_url % [@language, name_and_number[1], book_id]
                       })
    end

    resources['tN'] = {
        'name' => 'translationNotes',
        'files' => notes
    }
    resources['tQ'] = {
        'name' => 'translationQuestions',
        'href' => 'http://cdn.door43.org/%s/tq/v3/pdf/tq-v3.pdf' % @language,
        'files' => questions
    }

    resources
  end

end
