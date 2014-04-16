# coding: utf-8

require 'rubybsup.rb'

$entrytypes = [ 'article', 'book', 'booklet', 'conference',
  'inbook', 'incollection', 'inproceedings', 'manual', 'mastersthesis',
  'misc', 'phdthesis', 'proceedings', 'techreport', 'unpublished' ]

$styles['article'] = "(:[:author_or_journal:]:) (:([:year:]):).\n" +
  "(:\\newblock [:c_title*:].\n:)" +
  "(:\\newblock [:articleoptions*:].\n:)" +
  "(:\\newblock [:note*:].\n:)"
$styles['book'] = "(:[:author_editor:]:) (:([:year:]):).\n" +
  "\\newblock (:\\emph{[:c_title:]}:)(:[:bookoptions*:]:).\n" +
  "\\newblock (:[:address*:]: :)(:[:publisher:]:).\n" +
  "(:\\newblock [:note*:].\n:)"
$styles['booklet'] = "(:[:author_or_title:]:)(: ([:year*:]):).\n" +
  "(:\\newblock \\emph{[:title_ifauthor*:]}.\n:)" +
  "(:\\newblock [:bookletoptions*:].\n:)" +
  "(:\\newblock [:note*:].\n:)"
$styles['inbook'] = "(:[:author_editor:]:) (:([:year:]):).\n" +
  "\\newblock (:\\emph{[:c_title:]}:)(:[:vnseries_ifvn*:]:)" +
  "(: ([:chapter_pp_pages:]):)(:. \\emph{[:series_ifnovn*:]}:).\n" +
  "\\newblock (:[:address*:]: :)(:[:publisher:]:).\n" +
  "(:\\newblock [:note*:].\n:)"
$styles['incollection'] = "(:[:author:]:) (:([:year:]):).\n" +
  "\\newblock (:[:c_title:]:).\n" +
  "\\newblock In (:[:editor*:], :)(:\\emph{[:booktitle:]}:)(:[:bookoptions*:]:)" +
  "(: ([:chapter_pp_pages*:]):).\n" +
  "\\newblock (:[:address*:]: :)(:[:publisher:]:).\n"
$styles['inproceedings'] = "(:[:author:]:) (:([:year:]):).\n" +
  "\\newblock (:[:c_title:]:).\n" +
  "\\newblock In (:[:editor*:], :)(:\\emph{[:booktitle:]}:)(:[:bookoptions*:]:)" +
  "(: ([:volume_pp_pages*:]):).\n" +
  "(:\\newblock [:organization_address_publisher*:].\n:)" +
  "(:\\newblock [:note*:].\n:)"
$styles['manual'] = "(:[:author_or_title:]:)(: ([:year*:]):).\n" +
  "(:\\newblock \\emph{[:title_ifauthor*:]}.\n:)" +
  "(:\\newblock [:manualoptions*:].\n:)" +
  "(:\\newblock [:note*:].\n:)"
$styles['mastersthesis'] = "(:[:author:]:) (:([:year:]):).\n" +
  "\\newblock (:[:c_title:]:).\n" +
  "\\newblock (:[:mastersthesistype:]:), (:[:address*:]: :)(:[:school:]:).\n" +
  "(:\\newblock [:note*:].\n:)"
$styles['misc'] = "(:[:author_or_title*:]:)(: ([:year*:]):)(:[:period_ifaty*:]:)\n" +
  "(:\\newblock \\emph{[:title_ifauthor*:]}.\n:)" +
  "(:\\newblock [:howpublished*:].\n:)" +
  "(:\\newblock [:note*:].\n:)"
$styles['phdthesis'] = "(:[:author:]:) (:([:year:]):).\n" +
  "\\newblock (:\\emph{[:c_title:]}:).\n" +
  "\\newblock (:[:phdthesistype:]:), (:[:address*:]: :)(:[:school:]:).\n" +
  "(:\\newblock [:note*:].:)"
$styles['proceedings'] = "(:[:editor_or_title:]:) (:([:year:]):).\n" +
  "(:\\newblock \\emph{[:title_ifeditor*:]}.\n:)" +
  "(:\\newblock [:proceedingsoptions:].\n:)" +
  "(:\\newblock [:organization_address_publisher*:].\n:)" +
  "(:\\newblock [:note*:].\n:)"
$styles['techreport'] = "(:[:author:]:) (:([:year:]):).\n" +
  "\\newblock (:\\emph{[:c_title:]}:) ((:[:techreporttype:]:)(: [:number*:]:)).\n" +
  "(:\\newblock [:institution:].\n:)"
$styles['unpublished'] = "(:[:author:]:)(: ([:year*:]):).\n" +
  "\\newblock (:[:c_title:]:).\n" +
  "\\newblock (:[:note:]:).\n"

# XXX: cross reference entries
$styles['inbook_xref'] = "(:[:author_xref:]:) (:([:year_xref:]):).\n" +
  "\\newblock (:[:title:]:)(: ([:chapter_pages:]):).\n" +
  "\\newblock In (:[:xrefcite:]:).\n"

$author_namestyle = '(:[:vv||~:]~:)(:[:ll||~:]:)(: [:jj||~:]:)(:, [:f|.| :]:)'
$author_andspecs = [ ', \& ', ', \& ' ]
$editor_namestyle = '(:[:f|.| :] :)(:[:vv||~:]~:)(:[:ll||~:]:)(: [:jj||~:]:)'
$editor_andspecs = [ ', \& ', ', \& ' ]
$sort_namestyle = '(:[:vv||~:]~:)(:[:ll||~:]:)(: [:ff||~:]:)'
$sort_andspecs = [ ' ', ' ' ]

# Samples
# $author_namestyle = '(:[:ff|| :] :)(:[:vv||~:]~:)(:[:ll||~:]:)(:, [:jj||~:]:)'
# $author_andspecs = [ ' and ', ', and ' ]

class Formatter
  include NameFormatter
  include MonthFormatter
  include MiscFormatter

  def f_author
    a = $db[$cite]['author']
    if a.nil?
      return nil
    else
      names, numauthor = format_names(a, $author_namestyle, $author_andspecs)
      return names
    end
  end

  def f_author_xref
    s = f_author
    if s
      return s
    end
    xrefcite = $db[$cite]['crossref']
    if $db[xrefcite]['author']
      names, num = format_names($db[xrefcite]['author'], $author_namestyle, $author_andspecs)
      return names
    else
      $log.puts "Required field missing: no author for #{$cite} including the cited entry #{xrefcite}"
      return nil
    end
  end

  def f_editor
    e = $db[$cite]['editor']
    if e
      names, numeditor = format_names(e, $editor_namestyle, $editor_andspecs)
      if numeditor == 1
	return names + ' (Ed.)'
      else
	return names + ' (Eds.)'
      end
    else
      return nil
    end
  end

  def f_author_editor
    a = $db[$cite]['author']
    e = $db[$cite]['editor']

    if a and e
      $log.puts "Redundant fields: author and editor for #{$cite}; taking author"
    end
    if a
      names, num = format_names(a, $author_namestyle, $author_andspecs)
      return names
    elsif e
      names, num = format_names(e, $editor_namestyle, $editor_andspecs)
      if num == 1
	return names + ' (Ed.)'
      else
	return names + ' (Eds.)'
      end
    else
      return nil
    end
  end

  def f_author_or_title
    a = $db[$cite]['author']
    t = $db[$cite]['title']
    if a
      names, num = format_names(a, $author_namestyle, $author_andspecs)
      return names
    elsif t
      return "\\emph{#{t}}"
    else
      return nil
    end
  end

  def f_author_or_journal
    a = $db[$cite]['author']
    j = $db[$cite]['journal']
    if a
      names, num = format_names(a, $author_namestyle, $author_andspecs)
      return names
    elsif j
      return "\\emph{#{j}}"
    else
      return nil
    end
  end

  def f_editor_or_title
    e = $db[$cite]['editor']
    t = $db[$cite]['title']
    if e
      names, num = format_names(e, $editor_namestyle, $editor_andspecs)
      if num == 1
	return names + ' (Ed.)'
      else
	return names + ' (Eds.)'
      end
    elsif t
      return "\\emph{#{t}}"
    else
      return nil
    end
  end

  def f_title
    $db[$cite]['title']
  end

  def f_c_title
    t = $db[$cite]['title']
    if t
      capitalize_toplevel(t)
    else
      nil
    end
  end

  def f_booktitle
    capitalize_toplevel($db[$cite]['booktitle'])
  end

  def f_year
    $db[$cite]['year']
  end

  def f_year_xref
    s = f_year
    if s
      return s
    end
    xrefcite = $db[$cite]['crossref']
    return $db[xrefcite]['year']
  end

  def f_journal
    $db[$cite]['journal']
  end

  def f_volume
    $db[$cite]['volume']
  end

  def f_number
    $db[$cite]['number']
  end

  def f_pages
    $db[$cite]['pages']
  end

  def f_volume_number_pages
    v = $db[$cite]['volume']
    n = $db[$cite]['number']
    p = $db[$cite]['pages']
    s = ''
    if v
      s += "\\emph{#{v}}"
    end
    if n
      s += "(#{n})"
    end
    if p
      if s == ''
	s = p
      else
	s += ", #{p}"
      end
    end
    if s == ''
      nil
    else
      s
    end
  end

  def f_pp_pages
    pages = $db[$cite]['pages']
    if pages.nil?
      return nil
    elsif /[-+]/ =~ pages
      return 'pp.~' + pages
    else
      return 'p.~' + pages
    end
  end

  def f_chapter_pp_pages
    c = $db[$cite]['chapter']
    p = $db[$cite]['pages']
    t = $db[$cite]['type']
    s = ''
    if c
      if t
	s = "#{lowercase_toplevel(t)} #{c}"
      else
	s = "Chap.~#{c}"
      end
    end
    if p
      if /[-+]/ =~ p
	if c
	  pp = p
	else
	  pp = 'pp.~' + p
	end
      else
	pp = 'p.~' + p
      end
    end
    if p
      if c
	s += ", " + pp
      else
	s = pp
      end
    end
    if s == ''
      return nil
    else
      return s
    end
  end

  def f_volume_pp_pages
    v = $db[$cite]['volume']
    p = $db[$cite]['pages']
    s = ''
    if v
      s = "Vol.~#{v}"
    end
    if p
      if /[-+]/ =~ p
	pp = 'pp.~' + p
      else
	pp = 'p.~' + p
      end
    end
    if p
      if v
	s += ", " + pp
      else
	s = pp
      end
    end
    if s == ''
      nil
    else
      s
    end
  end

  def f_chapter_pages
    c = $db[$cite]['chapter']
    p = $db[$cite]['pages']
    if p
      if /[-+]/ =~ p
	pp = 'pp.~' + p
      else
	pp = 'p.~' + p
      end
    end
    if c and p
      return 'chapter ' + c + ', ' + pp
    elsif c
      return 'chapter ' + c
    elsif p
      return pp
    else
      return nil
    end
  end

  def f_address
    $db[$cite]['address']
  end

  def f_publisher
    $db[$cite]['publisher']
  end

  def f_howpublished
    $db[$cite]['howpublished']
  end

  def f_institution
    $db[$cite]['institution']
  end

  def f_school
    $db[$cite]['school']
  end

  def f_bookoptions
    n = $db[$cite]['number']
    s = $db[$cite]['series']
    e = $db[$cite]['edition']
    t = ''
    if s
      t = ", \\emph{#{s}}"
    end
    if n
      if t == ''
	t = n
      else
        t += ", \\emph{#{n}}"
      end
    end
    if e
      if t == ''
	t = " (#{e} ed.)"
      else
	t += " (#{e} ed.)"
      end
    end
    # $stderr.puts "debug: f_bookoptions returning #{t}"
    if t != ''
      "#{t}"
    else
      nil
    end
  end

  def f_proceedingsoptions
    v = $db[$cite]['volume']
    n = $db[$cite]['number']
    s = $db[$cite]['series']
    t = nil
    if v and n
      $log.puts "Warning: volume and number exist for #{$cite}; taking volume"
      t = "volume #{v}"
    elsif v
      t = "volume #{v}"
    elsif n
      t = "number #{n}"
    else
      t = nil
    end
    if s
      if t
	if v
	  t += " of \\emph{#{s}}"
	else
	  t += " in \\emph{#{s}}"
	end
      else
	t = "\\emph{#{s}}"
      end
    end
    s
  end

  def f_articleoptions
    a = $db[$cite]['author']
    j = $db[$cite]['journal']
    v = $db[$cite]['volume']
    n = $db[$cite]['number']
    p = $db[$cite]['pages']
    vnp = f_volume_number_pages
    s = ''
    if a
      s += "\\emph{#{j}}"
      if vnp
	s += ", " + vnp
      end
    else
      # no author; the entire journal is specified.
      # This case, the journal appears at the top;
      # we do not need to place it here.
      if vnp
	s += vnp
      end
    end
    if s == ''
      nil
    else
      s
    end
  end

  def f_period_ifaty
    if $db[$cite]['author'] or $db[$cite]['title'] or $db[$cite]['year']
      '.'
    else
      nil
    end
  end

  def f_vnseries_ifvn
    if $db[$cite]['volume'] or $db[$cite]['number']
      f_bookoptions
    else
      nil
    end
  end

  def f_series_ifnovn
    if $db[$cite]['volume'] or $db[$cite]['number']
      nil
    else
      $db[$cite]['series']
    end
  end

  def f_title_ifauthor
    return $db[$cite]['title'] if $db[$cite]['author']
  end

  def f_journal_ifauthor
    return $db[$cite]['journal'] if $db[$cite]['author']
  end

  def f_title_ifeditor
    return $db[$cite]['title'] if $db[$cite]['editor']
  end

  def f_bookletoptions
    a = $db[$cite]['address']
    h = $db[$cite]['howpublished']
    s = ''
    if a
      s += "#{a}: "
    end
    if h
      s += "#{h}"
    end
    if s != ''
      return s
    else
      return nil
    end
  end

  def f_manualoptions
    s = ''
    o = $db[$cite]['organization']
    a = $db[$cite]['address']
    e = $db[$cite]['edition']
    if e
      s += "#{capitalize_toplevel(e)} edition."
      if a or o
	s += " "
      end
    end
    if a and o
      s += "#{a}: #{o}."
    elsif a
      s += "#{a}."
    elsif o
      s += "#{o}."
    end
    if s == ''
      nil
    else
      s
    end
  end

  def f_organization_address_publisher
    o = $db[$cite]['organization']
    a = $db[$cite]['address']
    p = $db[$cite]['publisher']
    s = ''
    if o
      s += o
    end
    if a
      if o
	s += ", #{a}"
      else
	s = a
      end
    end
    if p
      if a
	s += ": " + p
      elsif o
	s += ", " + p
      else
	s = p
      end
    end
    if s == ''
      return nil
    else
      return s
    end
  end

  def f_phdthesistype
    if $db[$cite]['type']
      return $db[$cite]['type']
    else
      return 'PhD thesis'
    end
  end

  def f_mastersthesistype
    if $db[$cite]['type']
      return $db[$cite]['type']
    else
      return 'Masters thesis'
    end
  end

  def f_techreporttype
    if $db[$cite]['type']
      return $db[$cite]['type']
    else
      return 'Technical report'
    end
  end

  def f_note
    $db[$cite]['note']
  end

  def f_xrefcite
    xref = $db[$cite]['crossref']
    if xref
      return "\\cite{#{xref}}"
    else
      $stderr.puts "Cross reference is missing: from #{$cite}"
      return nil
    end
  end

  #
  # interface
  #

  def widestlabel
    # $stderr.puts "debug: widestlabel: $cites.size is #{$cites.size}"
    if $cites.size <= 0
      $log.puts "Only #{$cites.size} citations found"
      "9"
    else
      (10**(Math.log10($cites.size).to_i+1)-1).to_s	# e.g., 21 -> 99
    end
  end

  def sort
    $cites.sort! do |a, b|
      if $db[a].nil? and $db[b].nil?
	0
      elsif $db[a].nil?
	-1
      elsif $db[b].nil?
	1
      else
	aauthor = $db[a]['author']
	bauthor = $db[b]['author']
	aeditor = $db[a]['editor']
	beditor = $db[b]['editor']
	akey = $db[a]['key']
	bkey = $db[b]['key']
	# XXX: cross references ignored
	if aauthor
	  namesa, numa = format_names(aauthor, $sort_namestyle, $sort_andspecs)
	elsif aeditor
	  namesa, numa = format_names(aeditor, $sort_namestyle, $sort_andspecs)
	elsif akey
	  namesa = akey
	else
	  namesa = 'zzz'	# XXX: cannot figure out; put it to the end
	end
	if bauthor
	  namesb, numb = format_names(bauthor, $sort_namestyle, $sort_andspecs)
	elsif beditor
	  namesb, numb = format_names(beditor, $sort_namestyle, $sort_andspecs)
	elsif bkey
	  namesb = bkey
	else
	  namesb = 'zzz'	# XXX: cannot figure out; put it to the end
	end

	namesa = namesa.gsub(/~/, ' ').gsub(/[^\w. -]/){|c| ''}.downcase
	namesb = namesb.gsub(/~/, ' ').gsub(/[^\w. -]/){|c| ''}.downcase

	# $stderr.puts "debug: sort #{namesa} <=> #{namesb}"
	namesa <=> namesb
      end
    end
  end
end

# EOF
