# coding: utf-8
#
# rubybsup.rb - Supporting modules for RubyBTeX
#
# Copyright (c) 2014 Kazuto Tominaga
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

module NameFormatter
  def analyze_name(name)
    # XXX: does not treat latex commands correctly
    firstpart = []
    jrpart = []
    vonpart = []
    lastpart = []
    # (1) First von Last
    # (2) von Last, First
    # (3) von Last, Jr, First"
    if /,.*,/ =~ name
      # (3) von Last, Jr, First"
      a = name.split(/,/)
      vonlast = a[0].split
      vonlast.each do |n|
	if /^[a-z]/ =~ n
	  vonpart << n
	else
	  lastpart << n
	end
      end
      jrpart = a[1].split
      firstpart = a[2].split
    elsif /,/ =~ name
      # (2) von Last, First
      a = name.split(/,/)
      vonlastjr = a[0].split
      vonlastjr.each do |n|
	if /^[a-z]/ =~ n
	  vonpart << n
	elsif /^[A-Z]r\.?\z/ =~ n
	  jrpart << n
	else
	  lastpart << n
	end
      end
      firstpart = a[1].split
    else
      # (1) First von Last
      a = name.split
      state = :jr
      a.reverse_each do |n|
	case state
	when :jr
	  if /^[A-Z]r\.?\z/ =~ n
	    jrpart << n
	  else
	    lastpart << n
	    state = :von
	  end
	when :von
	  if /^[a-z]/ =~ n
	    vonpart << n
	  else
	    firstpart << n
	    state = :first
	  end
	else # :first
	  firstpart << n
	end
      end
      firstpart.reverse!
      vonpart.reverse!
      lastpart.reverse!
      jrpart.reverse!
    end
    h = Hash.new
    h[:first] = firstpart
    h[:von] = vonpart
    h[:last] = lastpart
    h[:jr] = jrpart
    h
  end
  private :analyze_name

  def getinitial(name)
    initial = nil
    if /^[A-Z]/ =~ name
      initial = $&
    elsif /^[a-z]/ =~ name
      initial = $&.upcase
      $stderr.puts "Warning: got initial #{initial} for name #{name}"
    elsif name[0..0] == '{'
      # try to imitate what TeX does
      n = name.dup
      s = ''
      level = 0
      state = :notbackslashed
      while true
	if n == ''
	  $stderr.puts "Cannot get the initial of name #{name}"
	  exit 1
	end
	c = n[0..0]
	n = n[1..-1]
	case c
	when '\\'
	  s += c
	  state = :backslashed
	when '{'
	  s += c
	  if state == :backslashed
	    state = :notbackslashed
	  else
	    level += 1
	  end
	when '}'
	  s += c
	  if state == :backslashed
	    state = :notbackslashed
	  else
	    level -= 1
	    if level == 0
	      break
	    end
	  end
	else
	  s += c
	  state = :notbackslashed
	end
      end
      initial = s
      # $stderr.puts "Please confirm; got initial #{initial} for name #{name} (might be wrong)"
    else
      $stderr.puts "This implementation cannot get initial of name #{name}"
      exit 1
    end
    initial
  end
  private :getinitial

  def repname(form, letter, names)
    t = ''
    if /^\(:(.*?)\[:(.*?)\|(.*?)\|(.*?):\](.*?):\)\z/ !~ form
      $stderr.puts "invalid pattern in name style #{form}"
      exit 1
    end
    left = $1
    body = $2
    suf = $3
    sep = $4
    right = $5
    # $stderr.puts "left '#{left}' body '#{body}' suf '#{suf}' sep '#{sep}' right '#{right}'"
    full = nil
    double = Regexp.new(letter + letter)
    if double =~ body
      reg = double
      initial = false
    else
      reg = Regexp.new(letter)
      initial = true
    end
    # leftmost part
    t += left
    # repetitive part
    if reg !~ body
      $stderr.puts "invalid body pattern for name style #{form}"
      exit 1
    end
    nleft = $`
    nright = $'
    a = []
    names.each do |n|
      if initial
	if /-/ =~ n				# Foo-Bar
	  b = n.split(/-/)
	  b.map!{|n| getinitial(n) + suf}	# F.-B.
	  n = b.join('-')
	else					# Kazuto
	  n = getinitial(n) + suf		# K.
	end
      end
      # $stderr.puts "debug: '#{nleft}'+'#{n}'+'#{nright}'"
      a << (nleft + n + nright)
    end
    t += a.join(sep)
    # rightmost part
    t += right
    # $stderr.puts "debug: repname returning #{t}"
    t
  end
  private :repname

  def format_name(name, style)
    h = analyze_name(name)
    s = style.dup
    while /\(:(.*?):\)/ =~ s
      # $stderr.puts "debug: format_name '#{s}'"
      pre = $`
      form = $&
      post = $'
      t = ''
      part = nil
      a = nil
      if /f/ =~ form
	part = 'f'
	a = h[:first]
      elsif /v/ =~ form
	part = 'v'
	a = h[:von]
      elsif /l/ =~ form
	part = 'l'
	a = h[:last]
      elsif /j/ =~ form
	part = 'j'
	a = h[:jr]
      else
	$stderr.puts "strange name format #{form} in #{s}"
	exit 1
      end
      if a.size > 0
	t = repname(form, part, a)
	s = pre + t + post
      else
	s = pre + post
      end
    end
    s
  end
  private :format_name

  def format_names(namestr, style, andspecs)
    rawnames = namestr.split(/ and /i)
    a = []
    numnames = rawnames.size
    rawnames.each do |n|
      if n == 'others'
	a << 'et al.'
      else
	a << format_name(n, style)
      end
    end
    numnames = a.size
    names = ''
    if numnames == 1
      names = a[0]
    else
      names = a[0..(numnames-2)].join(', ')
      if numnames == 2
	names += andspecs[0]
      else
	names += andspecs[1]
      end
      names += a[numnames-1]
    end
    return [ names, numnames ]
  end
  public :format_names
end

module MonthFormatter
  def format_month(mon)
    m = mon.dup
    m.gsub!(/jan/, 'January')
    m.gsub!(/feb/, 'February')
    m.gsub!(/mar/, 'March')
    m.gsub!(/apr/, 'April')
    m.gsub!(/may/, 'May')
    m.gsub!(/jun/, 'June')
    m.gsub!(/jul/, 'July')
    m.gsub!(/aug/, 'August')
    m.gsub!(/sep/, 'September')
    m.gsub!(/oct/, 'October')
    m.gsub!(/nov/, 'November')
    m.gsub!(/dec/, 'December')
    m
  end
end

module MiscFormatter
  def cu_toplevel(str, cu)
    if cu != :capitalize and cu != :lowercase
      $stderr.puts "internal error: cu_toplevel called with #{cu.to_str}"
      exit 1
    end
    s = str.dup
    t = ''
    level = 0
    state = :notbackslashed
    cstate = :initial
    while s.size > 0
      c = s[0..0]
      s = s[1..-1]
      # $stderr.puts "debug: cu_toplevel: c=#{c} state=#{state.to_s} cstate=#{cstate.to_s} level=#{level} s=#{s}"
      case c
      when '\\'
	if state == :backslashed
	  state = :notbackslashed
	else
	  state = :backslashed
	end
	t += c
      when '{'
	if state == :notbackslashed
	  level += 1
	else
	  state = :notbackslashed
	end
	t += c
      when '}'
	if state == :notbackslashed
	  level -= 1
	else
	  state = :notbackslashed
	end
	t += c
      else
	if /\s/ =~ c
	  t += c
	elsif /[a-z]/ =~ c
	  if cstate == :initial and cu == :capitalize and level == 0
	    t += c.upcase
	  else
	    t += c
	  end
	  cstate = :trailer
	elsif /[A-Z]/ =~ c
	  if cu == :capitalize
	    if cstate == :initial
	      t += c
	    elsif level == 0
	      t += c.downcase
	    else
	      t += c
	    end
	  else	# cu == :lowercase
	    if level == 0
	      t += c.downcase
	    else
	      t += c
	    end
	  end
	  cstate = :trailer
	elsif /[.:]/ =~ c
	  cstate = :initial if cu == :capitalize
	  t += c
	else
	  t += c
	  cstate = :trailer
	end
      end
    end
    if level != 0
      $log.puts "Warning: imbalance braces in string #{str}"
    end
    t
  end
  private :cu_toplevel

  def capitalize_toplevel(s)
    cu_toplevel(s, :capitalize)
  end

  def lowercase_toplevel(s)
    cu_toplevel(s, :lowercase)
  end
end

# EOF
