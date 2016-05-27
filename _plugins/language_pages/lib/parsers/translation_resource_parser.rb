# noinspection RubyStringKeysInHashInspection
class TranslationResourceParser

  def initialize(language_data)
    @language = language_data['lc']
  end

  def parse
    resources = []
    unless @language == 'en'
      return resources
    end

    resources << {
        'name' => 'translationWords',
        'href' => 'http://cdn.door43.org/en/tw/v2/pdf/tw-v2.pdf'
    }
    resources << {
        'name' => 'translationNotes',
        'href' => 'http://cdn.door43.org/en/tn/v2/pdf/tn-67-REV-v2.pdf'
    }
    resources << {
        'name' => 'translationQuestions',
        'href' => 'http://cdn.door43.org/en/tq/v2/pdf/tq-67-REV-v2.pdf'
    }
    resources
  end

end