# noinspection RubyStringKeysInHashInspection
class BibleResourceParser

  def initialize(language_data)
    @data = language_data
    @checking_image_url = '/assets/img/uW-Level%s-64px.png'
    @online_url = 'https://bible.unfoldingword.org/?w1=bible&t1=uw_%s_%s&v1=%s'
    @full_pdf_url = 'https://api.unfoldingword.org/%s/txt/1/%s-%s/%s.pdf'
    @ot_pdf_url = 'https://api.unfoldingword.org/%s/txt/1/%s-%s/%s-OT.pdf'
    @nt_pdf_url = 'https://api.unfoldingword.org/%s/txt/1/%s-%s/%s-NT.pdf'
  end

  def parse
    resources = []
    @data['vers'].each do |bible|
      book_url = @online_url % [@data['lc'], bible['slug'], '%s']
      books_parser = BibleBooksParser.new(bible['toc'], book_url)
      resources << {
        'name'                  =>  bible['name'],
        'slug'                  =>  bible['slug'],
        'books'                 =>  books_parser.parse,
        'checking_level'        =>  bible['status']['checking_level'],
        'checking_level_image'  =>  @checking_image_url % [bible['status']['checking_level']],
        'online_url'            =>  @online_url % [@data['lc'], bible['slug'], 'GN1_1'],
        'pdf_urls'              =>  {
          'full'                =>  @full_pdf_url % [bible['slug'], bible['slug'], @data['lc'], bible['slug'].upcase],
          'old_testament'       =>  @ot_pdf_url % [bible['slug'], bible['slug'], @data['lc'], bible['slug'].upcase],
          'new_testament'       =>  @nt_pdf_url % [bible['slug'], bible['slug'], @data['lc'], bible['slug'].upcase]
        }
      }
    end
    resources
  end

end

# noinspection RubyStringKeysInHashInspection,RubyLiteralArrayInspection,RubyClassVariableUsageInspection
class BibleBooksParser

  @@slug_to_dbs = {
    'gen' =>  'GN',
    'exo' =>  'EX',
    'lev' =>  'LV',
    'num' =>  'NU',
    'deu' =>  'DT',
    'jos' =>  'JS',
    'jdg' =>  'JG',
    'rut' =>  'RT',
    '1sa' =>  'S1',
    '2sa' =>  'S2',
    '1ki' =>  'K1',
    '2ki' =>  'K2',
    '1ch' =>  'R1',
    '2ch' =>  'R2',
    'ezr' =>  'ER',
    'neh' =>  'NH',
    'est' =>  'ET',
    'job' =>  'JB',
    'psa' =>  'PS',
    'pro' =>  'PR',
    'ecc' =>  'EC',
    'sng' =>  'SS',
    'isa' =>  'IS',
    'jer' =>  'JR',
    'lam' =>  'LM',
    'ezk' =>  'EK',
    'dan' =>  'DN',
    'hos' =>  'HS',
    'jol' =>  'JL',
    'amo' =>  'AM',
    'oba' =>  'OB',
    'jon' =>  'JH',
    'mic' =>  'MC',
    'nam' =>  'NM',
    'hab' =>  'HK',
    'zep' =>  'ZP',
    'hag' =>  'HG',
    'zec' =>  'ZC',
    'mal' =>  'ML',
    'mat' =>  'MT',
    'mrk' =>  'MK',
    'luk' =>  'LK',
    'jhn' =>  'JN',
    'act' =>  'AC',
    'rom' =>  'RM',
    '1co' =>  'C1',
    '2co' =>  'C2',
    'gal' =>  'GL',
    'eph' =>  'EP',
    'php' =>  'PP',
    'col' =>  'CL',
    '1th' =>  'H1',
    '2th' =>  'H2',
    '1ti' =>  'T1',
    '2ti' =>  'T2',
    'tit' =>  'TT',
    'phm' =>  'PM',
    'heb' =>  'HB',
    'jas' =>  'JM',
    '1pe' =>  'P1',
    '2pe' =>  'P2',
    '1jn' =>  'J1',
    '2jn' =>  'J2',
    '3jn' =>  'J3',
    'jud' =>  'JD',
    'rev' =>  'RV'
  }
  
  @@usfm_books = {
      'GEN' => ['Genesis', '01'],
      'EXO' => ['Exodus', '02'],
      'LEV' => ['Leviticus', '03'],
      'NUM' => ['Numbers', '04'],
      'DEU' => ['Deuteronomy', '05'],
      'JOS' => ['Joshua', '06'],
      'JDG' => ['Judges', '07'],
      'RUT' => ['Ruth', '08'],
      '1SA' => ['1 Samuel', '09'],
      '2SA' => ['2 Samuel', '10'],
      '1KI' => ['1 Kings', '11'],
      '2KI' => ['2 Kings', '12'],
      '1CH' => ['1 Chronicles', '13'],
      '2CH' => ['2 Chronicles', '14'],
      'EZR' => ['Ezra', '15'],
      'NEH' => ['Nehemiah', '16'],
      'EST' => ['Esther', '17'],
      'JOB' => ['Job', '18'],
      'PSA' => ['Psalms', '19'],
      'PRO' => ['Proverbs', '20'],
      'ECC' => ['Ecclesiastes', '21'],
      'SNG' => ['Song of Solomon', '22'],
      'ISA' => ['Isaiah', '23'],
      'JER' => ['Jeremiah', '24'],
      'LAM' => ['Lamentations', '25'],
      'EZK' => ['Ezekiel', '26'],
      'DAN' => ['Daniel', '27'],
      'HOS' => ['Hosea', '28'],
      'JOL' => ['Joel', '29'],
      'AMO' => ['Amos', '30'],
      'OBA' => ['Obadiah', '31'],
      'JON' => ['Jonah', '32'],
      'MIC' => ['Micah', '33'],
      'NAM' => ['Nahum', '34'],
      'HAB' => ['Habakkuk', '35'],
      'ZEP' => ['Zephaniah', '36'],
      'HAG' => ['Haggai', '37'],
      'ZEC' => ['Zechariah', '38'],
      'MAL' => ['Malachi', '39'],
      'MAT' => ['Matthew', '41'],
      'MRK' => ['Mark', '42'],
      'LUK' => ['Luke', '43'],
      'JHN' => ['John', '44'],
      'ACT' => ['Acts', '45'],
      'ROM' => ['Romans', '46'],
      '1CO' => ['1 Corinthians', '47'],
      '2CO' => ['2 Corinthians', '48'],
      'GAL' => ['Galatians', '49'],
      'EPH' => ['Ephesians', '50'],
      'PHP' => ['Philippians', '51'],
      'COL' => ['Colossians', '52'],
      '1TH' => ['1 Thessalonians', '53'],
      '2TH' => ['2 Thessalonians', '54'],
      '1TI' => ['1 Timothy', '55'],
      '2TI' => ['2 Timothy', '56'],
      'TIT' => ['Titus', '57'],
      'PHM' => ['Philemon', '58'],
      'HEB' => ['Hebrews', '59'],
      'JAS' => ['James', '60'],
      '1PE' => ['1 Peter', '61'],
      '2PE' => ['2 Peter', '62'],
      '1JN' => ['1 John', '63'],
      '2JN' => ['2 John', '64'],
      '3JN' => ['3 John', '65'],
      'JUD' => ['Jude', '66'],
      'REV' => ['Revelation', '67']
  }

  def self.usfm_books
    @@usfm_books
  end

  def initialize(book_data, online_url)
    @data = book_data
    @url = online_url
  end

  def parse
    results = []
    @data.each do |book|
      online_url = ''
      if @@slug_to_dbs.has_key?(book['slug'])
        book_param = "#{@@slug_to_dbs[book['slug']]}1_1"
        online_url = @url % [book_param]
      end

      results << {
        'slug'        =>  book['slug'],
        'name'        =>  book['title'],
        'online_url'  =>  online_url,
        'pdf_url'     =>  book['pdf']
      }
    end
    results
  end
end
