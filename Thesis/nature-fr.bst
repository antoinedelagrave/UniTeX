% 1.05 2015 Sept 15  French version modifided by Jean Olivier Simoneau, Sherbrooke, Qc(Canada)
%           Fixed encoding dependancy in "Mémoire de Maîtrise".
%           Masters Thesis title always displayed, as books and Phd Thesis.
%           Fixed string concatenation issue in format.date
%           French abbreviations and accentuation for edition number.
%           French translation of format.bvolume.
%           French translation of months.
%
%           Added show.title to display tiles, adapted function article.
%           Added support for displaying doi/arXiv/url references.
%             - Controlled via variables show.doi 
%             - Preference is DOI -> arXiv -> URL.
%             - Only displays arXiv if archiveprefix is "arXiv".
%           Added hyperref support.
%           (Requires the \href function from hyperref package)
%             - If use.hyperref is 1
%               - If show.doi is true, displayed ref will be a hyperlink.
%               - Else, journal/vol/num/pages/thesis will be a hyperlink.
%               - For books we display it even if show.doi is 0.
%           Added use.etal option to truncate list of authors.
%             - 0 or 1: all authors are shown.
%             - i: number of autors truncated to i, with "et al" if required.
%             - heavily modified function format.names for this.
%           Added show.month to allow displaying months.
%           Added support for doi/arxiv entries set as urls
%
%
% 1.05 2009 Jan 09  French version modified by Yann Lemonnier, Sherbrooke, Qc(Canada)
%		    Accents are now written without encoding dependancies.
% 		    Corrected format.editors to reflect format.authors
%		    Added translation for "In collection" and other TDS format
%
% 1.05 2005 Nov 23  French version made by Alexandre Langlois, Sherbrooke, Qc(Canada)
%                   I just made some modifications so the output would be written in french, for example , the "and" 
%                   before the last author's name has been replaced by "et", "Master's Thesis"->"Mémoire de Maîtrise", "PHD Thesis"->"Thèse de Doctorat"                  
%                    TDS format for the names.
                    
% version = 1.05 of nature.bst 1992 June 29

% 1.01 1991 July 3  last name first
%                   bold face volume numbers
%                   volume followed by comma, not colon
%                   parenthesis around year
%                   no comma after page numbers (not done yet!)
% 1.02 1991 Aug 7   Titles removed in FUNCTION {format.title}.
%                   (Should put \nocite{TitlesOn}
%                   mechanism in from jmb.bst next)
% 1.03 1991 Aug 29  in inproceedings, book title preceeds the editors!!
% 1.04 1991 Aug 30  year at end of inproceedings
%                   no 'pages' in inproceedings
%                   when no comma, don't put space instead
% 1.04 1992 Jun 29  Fix format.vol.num.pages to use field.or.null to
%                   correctly handle case of missing volume.
%                   [Nelson H. F. Beebe <beebe@plot79.math.utah.edu>]

% from:
% BibTeX standard bibliography style `unsrt'
        % version 0.99a for BibTeX versions 0.99a or later, LaTeX version 2.09.
        % Copyright (C) 1985, all rights reserved.
        % Copying of this file is authorized only if either
        % (1) you make absolutely no changes to your copy, including name, or
        % (2) if you do make changes, you name it something other than
        % btxbst.doc, plain.bst, unsrt.bst, alpha.bst, and abbrv.bst.
        % This restriction helps ensure that all standard styles are identical.
        % The file btxbst.doc has the documentation for this style.

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
    doi
    eprint
    archiveprefix
    url
  }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block
           docomma show.title show.doi show.arxiv use.hyperref use.etal 
           show.month }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=

  #1 'docomma :=    % if it is 0 then don't do commas, otherwise do them.

  % Custom options follow
  #1 'show.title :=         % 1 to show titles
  #0 'show.month :=         % 1 to show months
  #0 'use.etal :=           % 0,1: show all authors. i: "et al" if i+1 authors

  #1 'show.doi :=           % 1 to show doi
  #1 'use.hyperref :=       % 1 if the hyperref package is used
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { % doing a comma is controlled specifically using docomma
      docomma #0 =
      { "" * write$ } % TDS nothing if no comma
      { ", " * write$ }
      if$
    }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=  % TDS
%    { s nameptr "{vv~}{ll}{, jj}{, f.}" format.name$ 't := % last name first
      nameptr #1 =
        { t }
        { numnames nameptr =
            { " et " * t * }
            { nameptr use.etal =
                { " et~al" * 
                  #0 'namesleft :=  % break
                }
                { ", " * t * }
              if$
            }
          if$
        }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
    %  editor num.names$ #1 >
    %   { ", editors" * }
    %   { ", editor" * }
    % if$
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { show.title
        { title "t" change.case$ } % For titles
        { "" }  % TDS NO TITLES
      if$
    }
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {format.date}
{ year empty$
    { month empty$
        { "" }
        { "there's a month but no year in " cite$ * warning$
          month
        }
      if$
    }
    { month empty$
%        'year                       % TDS
%        { month " " * year * }      % TDS
        { " (" year * ")" * }
        { show.month
            { " " month * " " * " (" year * ")" * * }
            { " (" year * ")" * }
          if$
        }
%         { " " month * " " * " (" year * ")" * * }
%The preceding line was modified by Alan Rogers on 6/26/92.  It used to
%look like this: { month " " * " (" year * ")" * * }
      if$
    }
  if$
}

FUNCTION {format.btitle}
{ title emphasize
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "volume" volume tie.or.space.connect
      series empty$
        'skip$
        { " de " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { output.state mid.sentence =
            { "number" }
            { "Number" }
          if$
          number tie.or.space.connect
          series empty$
            { "there's a number but no series in " cite$ * warning$ }
            { " in " * series * }
          if$
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { edition "1" =
        { output.state mid.sentence =
            { edition "l" change.case$ "re \'edition" * }
            { edition "t" change.case$ "re \'edition" * }
          if$
        }
        { output.state mid.sentence =
            { edition "l" change.case$ "e \'edition" * }
            { edition "t" change.case$ "e \'edition" * }
          if$
        }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
%        { "pages" pages n.dashify tie.or.space.connect }
%        { "page" pages tie.or.space.connect }
% no word in nature!
        { "" pages n.dashify tie.or.space.connect }
        { "" pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.vol.num.pages}
{ "{ \bf " volume field.or.null * "}" * % make volume bold face
  number empty$
    'skip$
    { "(" number * ")" * *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
%        { ":" * pages n.dashify * } % TDS
        { ", " * pages n.dashify * } % comma, not colon TDS
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { "chapitre" }
        { type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
        { "Dans " booktitle emphasize * }
%       { "In " format.editors * ", " * booktitle emphasize * }
        { % book title preceeds the editors!! TDS
          "Dans "
          booktitle
          ", "
          *
          emphasize
          *
          format.editors
          *
          }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
        { "need key or journal for " cite$ * " to crossref " * crossref *
          warning$
          ""
        }
        { "In {\em " journal * "\/}" * }
      if$
    }
    { "In " key * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
        'skip$
        { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " et~al." * }
            { " et " * editor #2 "{vv~}{ll}" format.name$ * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "Dans "
    }
    { "Volume" volume tie.or.space.connect
      " de " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { series empty$
            { "need editor, key, or series for " cite$ * " to crossref " *
              crossref * warning$
              "" *
            }
            { "{\em " * series * "\/}" * }
          if$
        }
        { key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { booktitle empty$
            { "need editor, key, or booktitle for " cite$ * " to crossref " *
              crossref * warning$
              ""
            }
            { "Dans {\em " booktitle * "\/}" * }
          if$
        }
        { "Dans " key * }
      if$
    }
    { "Dans " format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

INTEGERS{ l } 

FUNCTION{ string.length } % From tame the beast goo.gl/6J26he
{ #1 'l :=
    {duplicate$ duplicate$ #1 l substring$ = not}
    {l #1 + 'l :=}
  while$
  pop$ l
}

STRINGS{ replace find text }

INTEGERS{ find_length }

FUNCTION{find.replace}  % From tame the beast goo.gl/6J26he
{ 'replace :=
  'find :=
  'text :=
  find string.length 'find_length :=
  ""
    { text empty$ not }
    { text #1 find_length substring$ find =
        { replace *
          text #1 find_length + global.max$ substring$ 'text :=
        }
        { text #1 #1 substring$ *
          text #2 global.max$ substring$ 'text :=
        }
      if$
    }
  while$
}

FUNCTION {arxiv.valid}
{ archiveprefix missing$ eprint missing$ or
    { #0 }
    { archiveprefix "arXiv" =
        { #1 }
        { #0 }
      if$
    }
  if$
}

FUNCTION {strip.doi}
{ doi "http://" "" find.replace 
    "dx.doi.org/" "" find.replace 
} 

FUNCTION {strip.arxiv}
{ eprint "http://" "" find.replace 
    "arxiv.org/abs/" "" find.replace 
}

FUNCTION {url.doi}
{
  "http://dx.doi.org/" strip.doi *
}

FUNCTION {url.arxiv}
{
  "http://arxiv.org/abs/" strip.arxiv *
}

FUNCTION {url.fallback}
{ url missing$ not
    { use.hyperref
        { "\href{" url "}{" url "}" * * * *}
        { url }
      if$
    }
    { "" }
  if$
}

FUNCTION {href.arxiv}
{ arxiv.valid
    { use.hyperref
        { "\href{" url.arxiv "}{arXiv\string:" strip.arxiv "}"  * * * * }
        { "arXiv\string:" strip.arxiv  * }
      if$
    }     
    { url.fallback }
  if$

}

FUNCTION {href.doi}
{ doi missing$ not
    { use.hyperref
        { "\href{" url.doi "}{doi\string:" strip.doi "}"  * * * * }
        { "doi\string:" strip.doi  * }
      if$
    }
    { href.arxiv }
  if$
}

FUNCTION {format.doiarxiv}
{ show.doi
    { href.doi }
    { "" }
  if$
}

FUNCTION {format.doiarxiv.book}
{ show.doi use.hyperref or
    { href.doi }
    { "" }
  if$
}

FUNCTION {style.journal}
{ journal emphasize
  #0 'docomma :=    % TURN COMMAS OFF
  format.vol.num.pages * % these now do their own comma!!
}

FUNCTION {url.fallback.journal}
{ url missing$ not
    { "\href{" url "}{" style.journal "}" * * * *}
    { style.journal }
  if$
}

FUNCTION {href.arxiv.journal}
{ arxiv.valid
    { "\href{" url.arxiv "}{" style.journal "}"  * * * * }
    { url.fallback.journal }
  if$
}

FUNCTION {href.doi.journal}
{ doi missing$ not
    { "\href{" url.doi "}{" style.journal "}"  * * * * }
    { href.arxiv.journal }
  if$
}

FUNCTION {format.journal}
{ use.hyperref show.doi not and
    { href.doi.journal }
    { style.journal }
  if$
}

FUNCTION {url.fallback.theses}
{ 't :=
  url missing$ not
    { "\href{" url "}{" t "}"  * * * * } 
    { t }
  if$
}

FUNCTION {href.arxiv.theses}
{ 't :=
  arxiv.valid
    { "\href{" url.arxiv "}{" t "}"  * * * * } 
    { t url.fallback.theses}
  if$
}

FUNCTION {href.doi.theses}
{ 't := 
  doi missing$ not
    { "\href{" url.doi "}{" t "}"  * * * * } 
    { t href.arxiv.theses}
  if$
}

FUNCTION {format.theses}
{ 't :=  % Nom COMPLET du type de these, maitrise/doctoral
  use.hyperref show.doi not and
    { t href.doi.theses }
    { t }
  if$
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title show.title 
                 {"title" output.check}
                 {output}
               if$ % Fixes empty title warning if show.title=0
  new.block
  crossref missing$
    {
      format.journal "journal" output.check
      format.date "year" output.check
      #1 'docomma :=    % TURN COMMAS ON
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$

  new.block
  format.doiarxiv output
  new.block
  note output
  fin.entry
}


FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output
      new.block
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date "year" output.check
  new.block 
  format.doiarxiv.book output
  new.block
  note output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.title "title" output.check
  howpublished address new.block.checkb
  howpublished output
  address output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output
      format.chapter.pages "chapter and pages" output.check
      new.block
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
      #0 'docomma :=    % TURN COMMAS OFF
  format.date "year" output.check
      #1 'docomma :=    % TURN COMMAS ON
  new.block
  note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.chapter.pages output
      new.sentence
      publisher "publisher" output.check
      address output
      #0 'docomma :=    % TURN COMMAS OFF
      format.edition output
      format.date "year" output.check
      #1 'docomma :=    % TURN COMMAS ON
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.pages output
      address empty$
        { organization publisher new.sentence.checkb
          organization output
          publisher output
          format.date "year" output.check
        }
        {
%          new.sentence
      #0 'docomma :=    % TURN COMMAS OFF
          " (" output.nonnull
          organization output
          publisher output
      #1 'docomma :=    % TURN COMMAS ON
      address output.nonnull
% year is at the end TDS
%          format.date "year" output.check
%zzz
          year ")" * output
        }
      if$
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
        'skip$
        { organization output.nonnull
          address output
        }
      if$
    }
    { format.authors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  author empty$
    { organization empty$
        { address new.block.checka
          address output
        }
        'skip$
      if$
    }
    { organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle "title" output.check % btitle: displayed, title: hidden 
    % Changed to be similar to PhD Thesis, easier to find reference.
  new.block
  %"M\'emoire de Ma\^itrise" format.thesis.type output.nonnull
  "M\'emoire de Ma\^itrise" format.theses format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  format.doiarxiv output
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  format.date output
  new.block
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle "title" output.check
  new.block
  %"Th\`ese de Doctorat" format.thesis.type output.nonnull
  "Th\`ese de Doctorat" format.theses format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block 
  format.doiarxiv output
  new.block
  note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
        { publisher new.sentence.checka }
        { organization publisher new.sentence.checkb
          organization output
        }
      if$
      publisher output
      format.date "year" output.check
    }
    { address output.nonnull
      format.date "year" output.check
      new.sentence
      editor empty$
        'skip$
        { organization output }
      if$
      publisher output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  format.date "year" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  note "note" output.check
  format.date output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"Janvier"}

MACRO {feb} {"F\'evrier"}

MACRO {mar} {"Mars"}

MACRO {apr} {"Avril"}

MACRO {may} {"Mai"}

MACRO {jun} {"Juin"}

MACRO {jul} {"Juillet"}

MACRO {aug} {"Ao\^ut"}

MACRO {sep} {"Septembre"}

MACRO {oct} {"Octobre"}

MACRO {nov} {"Novembre"}

MACRO {dec} {"D\'ecembre"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

READ

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
