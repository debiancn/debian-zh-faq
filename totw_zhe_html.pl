#!/usr/bin/perl -p

# �o�{�ǬO�Ψӹ� debian-tutorial �c�餤�媩�@�X���u����B�z�v�A�ĤG���C
# �u�ۡv����ؼg�k�K�K
#
# �@�̡G�N�F�F Anthony Fok <foka@debian.org>

next if /^%/;
1 while (s/^((?:[\x00-\x7F]|[\x80-\xFF].)*)\<\<��\>\>/$1��/);

# ����
