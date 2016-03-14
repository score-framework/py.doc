#!/usr/bin/gawk -f

BEGIN {
    in_license_block = 0;
}

/^License$/ {
    in_license_block = 1;
}

/^=+$/ && in_license_block == 2 {
    print last_line;
    in_license_block = 0;
}

/^=+$/ && in_license_block == 1 {
    in_license_block = 2;
}

in_license_block {
    last_line = $0;
}

(!in_license_block) {
    print $0;
}
