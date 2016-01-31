# RubyBTeX --- a BibTeX replacement written in Ruby

--------

## What is this

This is a set of Ruby script files that works like BibTeX.
They were developed to produce bibliographies according to
the style for [Artificial Life Journal](http://www.mitpressjournals.org/loi/artl).

Two style files are provided: plain and mitalife.
The former is like BibTeX's plain style
(with possible differences).
The latter is the one for ALJ.

Style files are written in Ruby, so it may be easier to customize them than doing it by adjusting BibTeX's .bst files.

### A bit of words about its history

I wrote this program in 2004 just for my need in submitting a paper.
At that time, I knew only little about Ruby,
so the code hardly uses Ruby's nice features (it's even not object-oriented!);
please do not expect much.

## Usage

1. Make a .tex file with \bibliographystyle and \bibliography in the same way as using BibTeX.
2. Run LaTeX on your .tex file to generate .aux file.
3. Run rubybtex to generate .bib file.
4. Run LaTeX (twice) on your .tex, .aux and .bib files to include the bibliography in .dvi.

A sample session is a follows:

    $ latex main
    $ rubybtex main
    $ latex main
    $ latex main 

## Bugs

RubyBTeX is not fully compatible with BibTeX; neither are the style files.

## License

This software is released under the MIT License; see LICENSE.txt.
