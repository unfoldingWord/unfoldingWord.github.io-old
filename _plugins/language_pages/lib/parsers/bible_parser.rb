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
  };

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
      dbs =
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
