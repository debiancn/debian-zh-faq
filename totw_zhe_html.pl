#!/usr/bin/perl -p

# 這程序是用來對 debian-tutorial 繁體中文版作出的「善後處理」，第二部。
# 「著」的兩種寫法……
#
# 作者：霍東靈 Anthony Fok <foka@debian.org>

next if /^%/;
1 while (s/^((?:[\x00-\x7F]|[\x80-\xFF].)*)\<\<著\>\>/$1著/);

# 結束
