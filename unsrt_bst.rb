# coding: utf-8
#
# plain_bst.rb - RubyBTeX plain style file
#
# Copyright (c) 2014 Kazuto Tominaga
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

require_relative 'rubybsup.rb'

=begin
--- $entrytypes
  Types of entries in .bib files.  Any type can be added,
  but it is better to stick to the standard entry types.
=end
$entrytypes = [ 'article', 'book', 'booklet', 'conference',
  'inbook', 'incollection', 'inproceedings', 'manual', 'mastersthesis',
  'misc', 'phdthesis', 'proceedings', 'techreport', 'unpublished' ]

=begin
--- $styles
  Style definitions.  The string for an entry type defines
  the output format.  It is a Ruby's double-quoted string,
  so special sequences such as \n and #{...} are processed
  by the Ruby interpreter, and the result is output.
  Besides that, the following two types of sequences are
  handled in special ways.

  : (:<Part A>[:<Part B>:]<Part C>:)

    This substring makes a call to the function named "f_<Part B>".
    For example, (:[:c_title:]:) calls the function f_c_title.
    These f_ functions must be defined in the class Formatter,
    which is defined in this file.  <Part B> can have an asterisk
    at the end: it means that the field is optional; otherwise,
    the field is required.  This only affects whether to show
    warning messages or not.

    The call to the f_ function results in two cases.

    * The call returned nil.

      In this case, the substring is replaced with
      the empty string ("").  If the field is required,
      a warning message is displayed.

    * The call returned a non-nil string, say, <String>.

      In this case, the substring is replaced with
      <Part A><String><Part B>.

    No nesting is allowed other than the form "(: [: :] :)".
    The order of calling functions is not defined.

  : . (period)

    After all the replacements are done, periods are processed.
    This period adds '.' to the preceding string if it does not
    end with a period.  Suppose the format string is "(:[:name:]:).".
    If f_name returns "Kay Tom", the string becomes "Kay Tom.".
    If f_name returns "Tom, K.", the string becomes "Tom, K.".

    Writing "\." avoids this processing.

  Style processing requires that curly braces are balanced.
  (It handles escaping by backslash, so "{\{}" is valid.)

  Hints for writing a style definition:
  * Starting from required fields is an easy way.
  * Separators such as commas usually go well when they are
    included in optional fields.
  * It's difficult to handle cases where required fields are
    missing; better to compromise.
=end

$styles['article'] = "(:[:author_or_journal:]:).\n" +
  "(:\\newblock [:c_title*:].\n:)" +
  "(:\\newblock [:articleoptions*:],\n:)" +
  "\\newblock (:[:month*:] :)(:[:year:]:).\n" +
  "(:\\newblock [:note*:].\n:)"
$styles['book'] = "(:[:author_editor:]:).\n" +
  "\\newblock (:\\emph{[:title:]}:)(:, [:bookoptions*:]:).\n" +
  "\\newblock (:[:publisher:]:)(:, [:address*:]:)" +
  "(:, [:edition*:] edition:), (:[:month*:] :)(:[:year:]:).\n" +
  "(:\\newblock [:note*:].\n:)"
$styles['booklet'] = "(:[:author_or_c_title:]:).\n" +
  "(:\\newblock [:c_title_ifauthor*:].\n:)" +
  "(:\\newblock [:bookletoptions*:].\n:)" +
  "(:\\newblock [:note*:].\n:)"
$styles['inbook'] = "(:[:author_editor:]:).\n" +
  "\\newblock (:\\emph{[:title:]}:)(:, [:vnseries_ifvn*:]:)" +
  "(:, [:chapter_pp_pages:]:)(:. \\emph{[:series_ifnovn*:]}:).\n" +
  "\\newblock (:[:publisher:]:)(:, [:address*:]:)(:, [:edition*:] edition:), " +
  "(:[:month*:] :)(:[:year:]:).\n" +
  "(:\\newblock [:note*:].\n:)"
$styles['incollection'] = "(:[:author:]:).\n" +
  "\\newblock (:[:c_title:]:).\n" +
  "\\newblock In (:[:editor*:], :)(:\\emph{[:booktitle:]}:)(:, [:volume_number_series*:]:)" +
  "(:, [:chapter_pp_pages*:]:).\n" +
  "\\newblock (:[:publisher:]:)(:, [:address*:]:)(:, [:edition*:] edition:), " +
  "(:[:month*:] :)(:[:year:]:).\n" +
  "(:\\newblock [:note*:].\n:)"
$styles['inproceedings'] = "(:[:author:]:).\n" +
  "\\newblock (:[:c_title:]:).\n" +
  "\\newblock In (:[:editor*:], :)(:\\emph{[:booktitle:]}:)(:, [:volume_number_series*:]:)" +
  "(:, [:pp_pages*:]:)(:, [:address*:]:), (:[:month*:] :)(:[:year:]:).\n" +
  "(:\\newblock [:organization_publisher*:].\n:)" +
  "(:\\newblock [:note*:].\n:)"
$styles['manual'] = "(:[:author_or_title:]:).\n" +
  "(:\\newblock \\emph{[:title_ifauthor*:]}.\n:)" +
  "(:\\newblock [:manualoptions*:].\n:)" +
  "(:\\newblock [:note*:].\n:)"
$styles['mastersthesis'] = "(:[:author:]:).\n" +
  "\\newblock (:[:c_title:]:).\n" +
  "\\newblock (:[:mastersthesistype:]:), (:[:school:]:)(:, [:address*:]:), " +
  "(:[:month*:] :)(:[:year:]:)." +
  "(:\\newblock [:note*:].\n:)"
$styles['misc'] = "(:[:author_or_title*:]:)(:[:period_ifat*:]\n:)" +
  "(:\\newblock [:title_ifauthor*:].\n:)" +
  "(:\\newblock [:miscoptions*:].\n:)" +
  "(:\\newblock [:note*:].\n:)"
$styles['phdthesis'] = "(:[:author:]:).\n" +
  "\\newblock (:\\emph{[:title:]}:).\n" +
  "\\newblock (:[:phdthesistype:]:), (:[:school:]:)(:, [:address*:]:), " +
  "(:[:month*:] :)(:[:year:]:).\n" +
  "(:\\newblock [:note*:].:)"
$styles['proceedings'] = "(:[:editor_or_organization_or_title:]:).\n" +
  "\\newblock (:\\emph{[:title_ifeoro*:]}, :)" +
  "(:[:volume_number_series*:], :)(:[:address*:], :)(:[:month*:] :)(:[:year:]:).\n" +
  "(:\\newblock [:proceedingsoptions*:].\n:)" +
  "(:\\newblock [:note*:].\n:)"
$styles['techreport'] = "(:[:author:]:).\n" +
  "\\newblock (:[:c_title:]:).\n" +
  "\\newblock (:[:techreporttype:]:)(: [:number*:]:)(:, [:institution:]:)(:, [:address*:]:), " +
  "(:[:month*:] :)(:[:year:]:).\n" +
  "(:\\newblock [:note*:].\n:)"
$styles['unpublished'] = "(:[:author:]:).\n" +
  "\\newblock (:[:c_title:]:).\n" +
  "\\newblock (:[:note:]:)(:, [:month_year*:]:).\n"

# XXX: cross reference entries
$styles['inbook_xref'] = "(:[:author_xref:]:) (:([:year_xref:]):).\n" +
  "\\newblock (:[:title:]:)(: ([:chapter_pages:]):).\n" +
  "\\newblock In (:[:xrefcite:]:).\n"

=begin
--- namestyle, andspec
  namestyle and andspec are parameters for NameFormatter#format_names.
  namestyle specifies how the names shall be formatted, and
  andspec specifies the style for using "and" before the last author name.

  An element of a namestyle is of the form
  "(:<Part A>[:<NameSpec>|<AbbrevLetter>|<Space>:]<Part C>:)".
  <NameSpec> specifies what part of the name shall appear in what form,
  and is one of the following.  Please see the BibTeX document(*1) for terminology.

  (*1) Oren Patashnik: Helpful Hints, section 4 of BibTeXing.  February 1988.

  *ff: The First part.
  *f:  Initial of the First part.
  *vv: The von part.
  *v:  Initial of the von part.
  *ll: The Last part.
  *l:  Initial of the Last part.
  *jj: The Jr part.
  *j:  Initial of the Jr part.

  <AbbrevLetter> is a letter to mean that the name is abbreviated.
  This is usually a period (.) or nothing.

  One element (:<Part A>[:<NameSpec>|<AbbrevLetter>|<Space>:]<Part C>:) is
  replaced with a string according to the name to process as follows.

  * If the name does not have the specified part, the element becomes "".
  * If the name has the specified part, each name in that part replaces
    <NameSpec> followed by <AbbrevLetter>, and they are concatenated
    with the delimiter <Space>.  Then the result (let it be <Result>) is
    placed between <Part A> and <Part C> to form a string.

  Examples: if the element is (:---[:f|.|~:]+++:) and the First part
  of the name is "Foo Bar", the processing results "---F.~B.+++".

  The process is applied to each names in the name list.
  If the number of names is two, the first element of andspec is used;
  if there are more, the second element is used.  For example, if
  andspec is [' and ', ', and'], results are like:

    Aaa Bbb and Ccc Ddd
    Aaa Bbb, Ccc Ddd, and Eee Fff

  The order of replacement is not defined.
=end

=begin
--- $author_namestyle, $author_andspecs
  Used to format author names.
--- $editor_namestyle, $editor_andspecs
  Used to format editor names.
--- $sort_namestyle, $sort_andspecs
  Used to sort the bibliography list.
=end
$author_namestyle = '(:[:ff|| :] :)(:[:vv||~:]~:)(:[:ll||~:]:)(:, [:jj||~:]:)'
$author_andspecs = [ ' and ', ', and ' ]
$editor_namestyle = '(:[:ff|| :] :)(:[:vv||~:]~:)(:[:ll||~:]:)(:, [:jj||~:]:)'
$editor_andspecs = [ ' and ', ', and ' ]
$sort_namestyle = '(:[:vv||~:]~:)(:[:ll||~:]:)(: [:ff||~:]:)'
$sort_andspecs = [ ' ', ' ' ]

# Samples
# $author_namestyle = '(:[:vv||~:]~:)(:[:ll||~:]:)(: [:jj||~:]:)(:, [:f|.| :]:)'
# $author_andspecs = [ ' \& ', ', \& ' ]

=begin
--- Formatter
  This class should define the following methods.

  :f_ functions
    f_ functions that appear in the style lines above must be defined.
    They should not have side effects, since the order of calling is
    not defined.

  :Formatter#widestlabel
    This function should return a string that is to be specified as
    the parameter of \begin{thebibliography}{<here>}.

  :Formatter#sort
    The function to sort the array $cite, whose order is the order
    of the bibliography list.
=end
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
	return names + ', editor'
      else
	return names + ', editors'
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
	return names + ', editor'
      else
	return names + ', editors'
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

  def f_author_or_c_title
    a = $db[$cite]['author']
    t = $db[$cite]['title']
    if a
      names, num = format_names(a, $author_namestyle, $author_andspecs)
      return names
    elsif t
      return capitalize_toplevel(t)
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

  def f_editor_or_organization_or_title
    e = $db[$cite]['editor']
    o = $db[$cite]['organization']
    t = $db[$cite]['title']
    if e
      names, num = format_names(e, $editor_namestyle, $editor_andspecs)
      if num == 1
	return names + ', editor'
      else
	return names + ', editors'
      end
    elsif o
      return o
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
    $db[$cite]['booktitle']
  end

  def f_year
    $db[$cite]['year']
  end

  def f_month
    m = $db[$cite]['month']
    if m.nil?
      ms = nil
    else
      ms = format_month(m)
    end
    ms
  end

  def f_month_year
    m = $db[$cite]['month']
    y = $db[$cite]['year']
    s = nil
    if y
      if m
	s = format_month(m) + ' ' + y
      else
	s = y
      end
    elsif m
      $log.puts "Month without year is specified for #{$cite}"
      s = format_month(m)
    end
    s
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
      s += v
    end
    if n
      s += "(#{n})"
    end
    if p
      if s == ''
	s = p
      else
	s += ":#{p}"
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
      return 'pages~' + pages
    else
      return 'page~' + pages
    end
  end

  def f_chapter_pp_pages
    c = $db[$cite]['chapter']
    p = $db[$cite]['pages']
    t = $db[$cite]['type']
    s = ''
    if p
      if /[-+]/ =~ p
	pp = 'pages~' + p
      else
	pp = 'page~' + p
      end
    end
    if c
      if t
	s = "#{lowercase_toplevel(t)} #{c}"
      else
	s = "chapter #{c}"
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

  def f_edition
    e = $db[$cite]['edition']
    if e
      lowercase_toplevel(e)
    else
      nil
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
	  t += " in #{s}"
	end
      else
	t = s
      end
    end
    t
  end

  def f_volume_number_series
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
	  t += " in #{s}"
	end
      else
	t = s
      end
    end
    t
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
      # (XXX: author is required, but the BibTeX examples include this type of entry.)
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

  def f_miscoptions
    h = $db[$cite]['howpublished']
    m = $db[$cite]['month']
    y = $db[$cite]['year']
    s = ''
    if h
      s = h
    end
    if y
      s += ', ' if s != ''
      if m
	s += format_month(m) + " " + y
      else
	s += y
      end
    else
      if m
	$log.puts "Month without year is specified for #{$cite}"
	if s == ''
	  s = format_month(m)
	else
	  s += ', ' + format_month(m)
	end
      end
    end
    if s == ''
      nil
    else
      s
    end
  end

  def f_period_ifat
    if $db[$cite]['author'] or $db[$cite]['title']
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

  def f_c_title_ifauthor
    if $db[$cite]['author']
      t = $db[$cite]['title']
      if t
	capitalize_toplevel(t)
      else
	nil
      end
    else
      nil
    end
  end

  def f_journal_ifauthor
    return $db[$cite]['journal'] if $db[$cite]['author']
  end

  def f_title_ifeoro
    return $db[$cite]['title'] if $db[$cite]['editor'] or $db[$cite]['organization']
  end

  def f_bookletoptions
    h = $db[$cite]['howpublished']
    a = $db[$cite]['address']
    m = $db[$cite]['month']
    y = $db[$cite]['year']
    s = ''
    if h
      s += "#{h}"
    end
    if a
      if s == ''
	s = a
      else
	s += ", #{a}"
      end
    end
    if y
      s += ', ' if s != ''
      if m
	s += format_month(m) + " " + y
      else
	s += y
      end
    else
      if m
	$log.puts "Month without year is specified for #{$cite}"
	if s == ''
	  s = format_month(m)
	else
	  s += ', ' + format_month(m)
	end
      end
    end
    if s != ''
      return s
    else
      return nil
    end
  end

  def f_manualoptions
    o = $db[$cite]['organization']
    a = $db[$cite]['address']
    e = $db[$cite]['edition']
    m = $db[$cite]['month']
    y = $db[$cite]['year']
    s = ''
    if o
      s += o
    end
    if a
      if s == ''
	s = a
      else
	s += ", " + a
      end
    end
    if e
      if s == ''
	s = e + " edition"
      else
	s += ", " + lowercase_toplevel(e) + " edition"
      end
    end
    if y
      s += ', ' if s != ''
      if m
	s += format_month(m) + " " + y
      else
	s += y
      end
    else
      if m
	$log.puts "Month without year is specified for #{$cite}"
	if s == ''
	  s = format_month(m)
	else
	  s += ', ' + format_month(m)
	end
      end
    end
    if s == ''
      nil
    else
      s
    end
  end

  def f_organization_publisher
    o = $db[$cite]['organization']
    p = $db[$cite]['publisher']
    s = ''
    if o
      s += o
    end
    if p
      if o
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

  def f_proceedingsoptions
    e = $db[$cite]['editor']
    o = $db[$cite]['organization']
    p = $db[$cite]['publisher']
    s = ''
    if o and e
      s += o
    else
      # (if no editor, organization should have appeared at the top)
    end
    if p
      if s == ''
	s = p
      else
	s += ", " + p
      end
    end
    if s == ''
      return nil
    else
      return s
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
      return capitalize_toplevel($db[$cite]['type'])
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

  def f_note
    $db[$cite]['note']
  end

  def f_techreporttype
    t = $db[$cite]['type']
    if t
      t
    else
      'Technical report'
    end
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
  end
end

# EOF
