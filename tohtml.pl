#!/usr/bin/perl -p

BEGIN {
    $english = 0;
    $verbatim = 0;
}

s/^%LaTeX2HTMLonly%//;

next if /^%/;

# Work around a LaTeX2HTML bug that ignores \/ or \textcompwordmark{}
# for breaking up "---" and "--" ligatures.

s%(-\\/-\\/-)%\\latexhtml\{$1\}\{\\begin\{rawhtml\}---\\end\{rawhtml\}\}%g;
s%(-\\/-(?!\\/-))%\\latexhtml\{$1\}\{\\begin\{rawhtml\}--\\end\{rawhtml\}\}%g;


# Isolate the areas where CJKtilde is in effect.

if (/\\end\{englishtext\}/) { $english  = 0; next; }
if (/\\end\{lyxcode\}/)     { $verbatim = 0; next; }
if (/\\begin\{englishtext\}/) { $english  = 1; next; } 
if (/\\begin\{lyxcode\}/)     { $verbatim = 1; next; }
next if ($english == 1) or ($verbatim == 1);

chomp;

if (/\\texttt\{/) {
    my $pos = 0;
    my $level = 0;
    my $line = '';
    while (/\\texttt\{/) {
	$pos = index($_, '\texttt{') + 8;
	$str = substr($_, 0, $pos, "");
	while ($str =~ s/^((?:[\x00-\x7f]|[\x80-\xff].)*)~/$1 /) {}
	$line .= $str;

	$level = 1;
	while ($level > 0) {
	    $pos = index($_, '}') + 1;
	    last if $pos == -1;
	    $str = substr($_, 0, $pos, "");
	    $line .= $str;
	    if ($str =~ /\{/) {
		$level++;
	    } else {
		$level--;
	    }
	}
    }
    1 while (s/^((?:[\x00-\x7f]|[\x80-\xff].)*)~/$1 /);
    $line .= $_;
    $_ = $line;
}
else {
#    1 while (s/^((?:[\x00-\x7f]|[\x80-\xff].)*)~/$1 /);
     1 while (s/^((?:[\x00-\x2e\x30-\x7f]|[\x80-\xff].)*)~/$1 /);
}

s/\\nbs(?:\{\}|\s*)/~/g;
s/\s+(¡B|¡A|¡C|¡G|¡I|¡H|¡]|¡^|¡u|¡v)/$1/g;
s/(¡B|¡A|¡C|¡G|¡I|¡H|¡]|¡^|¡u|¡v)\s+/$1/g;
$_ .= "\n";
