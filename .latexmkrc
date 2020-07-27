#!/usr/bin/env perl

## latex command 共通 options
$latex_options = '-synctex=1 -halt-on-error -file-line-error -interaction=nonstopmode';

## OS 判定
if ($^O eq 'MSWin32') { # Windows の場合
  $latex   = "uplatex %O $latex_options -kanji=utf8 -no-guess-input-enc %S";
} else { # Windows 以外の OS の場合 (Linux, macOS)
  $latex   = "uplatex %O $latex_options %S";
}
$pdflatex  = "pdflatex %O $latex_options %S";
$lualatex  = "lualatex %O $latex_options %S";
$xelatex   = "xelatex %O $latex_options -no-pdf -shell-escape %S";
$biber     = "biber %O --bblencoding=utf8 -u -U --output_safechars %B";
$bibtex    = "upbibtex %O %B";
$makeindex = "upmendex %O -o %D %S";
$dvipdf    = "dvipdfmx %O -o %D %S";
$dvips     = "dvips %O -z -f %S | convbkmk -u > %D";
$ps2pdf    = "ps2pdf.exe %O %S %D";

## PDF の作成方法を指定するオプション
# $pdf_mode = 0; # PDF を作成しません。
# $pdf_mode = 1; # $pdflatex を利用して PDF を作成します。
# $pdf_mode = 2; # $ps2pdf を利用して .ps ファイルから PDF を作成します。
$pdf_mode = 3; # $dvipdf を利用して .dvi ファイルから PDF を作成します。
# $pdf_mode = 4; # $lualatex を利用して .dvi ファイルから PDF を作成します。
# $pdf_mode = 5; # xdvipdfmx を利用して .xdv ファイルから PDF を作成します。

## PDF ビュアーの設定（OS 別）
if ($^O eq 'MSWin32') { # Windows の場合
  ## Windows では SyncTeX が利用できる SumatraPDF が推奨されている。
  ## SumatraPDF: https://www.sumatrapdfreader.org/free-pdf-reader.html
  if (-f 'C:/Program Files/SumatraPDF/SumatraPDF.exe') {
    $pdf_previewer = '"C:/Program Files/SumatraPDF/SumatraPDF.exe" -reuse-instance';
  } elsif (-f 'C:/Program Files (x86)/SumatraPDF/SumatraPDF.exe') {
    $pdf_previewer = '"C:/Program Files (x86)/SumatraPDF/SumatraPDF.exe" -reuse-instance';
  } else {
    ## SumatraPDF が存在しない場合は、TeXworks で開くように設定されている。
    ## 別のアプリケーション(Adobe Reader 等)で開きたい場合はここに実行ファイルのパスを設定する
    $pdf_previewer = 'texworks';
  }
} elsif ($^O eq 'darwin') { # macOS の場合
  ## 一時ファイルの作成を抑止するオプション(0: 抑止)
  ## Skim 等の変更検知機構のあるビュアーで変更箇所を検知できるようにするため
  $pvc_view_file_via_temporary = 0;
  ## macOS では SyncTeX が利用できる Skim が推奨されている。
  $pdf_previewer = "open -ga /Applications/Skim.app";
} else { # Linux の場合
  ## Linux ではディストリビューションによってインストールされているアプリケーションが
  ## 異なるため、ディストリビューションに依存しない xdg-open で開くようにする
  $pdf_previewer = "xdg-open";
}

## スタイルファイル（.sty）を探索する場所（パス）を追加
# $ENV{'TEXINPUTS'} = './sty//;' . './tex//;';
$ENV{'TEXINPUTS'} = './sty//;' . '../sty//;' . '../../sty//;' . './tex//;' . '../../tex//;';

## フォントを探索する場所（パス）を追加
$ENV{'OPENTYPEFONTS'} = './fonts//;' . '../fonts//;' . '../../fonts//;';


# ## - - - - 句読点を自動置換 - - - - - - - -

# # @texfiles = glob("{*.tex,tex/*/*.tex,tex/*/*/*.tex}");

# ##--- finding tex files
# use 5.010;
# use Encode::Locale;
# use File::Find;

# my @texfiles;
# find(
#   {
#     wanted => sub {
#       push @texfiles, Encode::decode locale_fs => $File::Find::name if $File::Find::name =~ /\.tex$/;
#     },
#   },
#   ".",
# );
# # say $_ for @texfiles;
# ##---

# print "%%----------\n";
# print "Running 'kaishi/.latexmkrc'\n";
# print "以下のファイルの句読点を置換しました：\n";

# foreach my $file(@texfiles)
# {
#   print "  ".$file."\n";
#   rename($file, $file.'-tmp');
#   open(IN, '<', $file.'-tmp') or die $!;
#   open(OUT, '>', $file) or die $!;
#   while(<IN>)
#   {
#     $_ =~ s/、/，/g;
#     $_ =~ s/。/．/g;
#     print OUT $_;
#   }
#   close(IN);
#   close(OUT);
#   unlink($file.'-tmp'); # delete tmp file
# }
# print "%%----------\n";
# ## - - - - - - - - - - - - - - - - - - - - - -