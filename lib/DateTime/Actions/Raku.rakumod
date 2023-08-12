use v6.d;


class DateTime::Actions::Raku {
    method TOP($/) {
        make $/.values[0].made;
    }

    method datetime-param-spec($/) {
        make $/.values[0].made;
    }

    method datetime-spec($/) {
        make $/.values[0].made;
    }

    method rfc3339-date($/) {
        make DateTime.new(|$<date>.made, |$<time>.made);
    }

    method rfc1123-date($/) {
        make DateTime.new(|$<date>.made, |$<time>.made, |$<gmt-or-numeric-tz>.made);
    }

    method rfc850-date($/) {
        make DateTime.new(|$<date>.made, |$<time>.made, |$<gmt-or-numeric-tz>.made);
    }

    method rfc850-var-date($/) {
        make DateTime.new(|$<date>.made, |$<time>.made, |$<gmt-or-numeric-tz>.made);
    }

    method gmt-or-numeric-tz($/) {
        $/.make: %( timezone =>
        "$/" eq 'UTC' | 'GMT' | 'Z' ?? 0 !! +$/ * 36
        );
    }

    method rfc850-var-date-two($/) {
        make DateTime.new(|$<date>.made, |$<time>.made, |$<gmt-or-numeric-tz>.made);
    }

    method asctime-date($/) {
        my $date = $<date>.made;
        $date<year> = $<year>.made;

        my $tz = ($<asctime-tz>.made<offset-hours> // 0) × 3600;

        make DateTime.new(|$<date>.made, |$<time>.made, :timezone($tz));
    }

    method nginx-date($/) {
        make DateTime.new(|$<date>.made, |$<time>.made);
    }

    method mysql-date ($/) {
        make DateTime.new(
          year   => $<date5><year>.made,
          month  => $<date5><month>.made,
          day    => $<date5><day>.made,
          hour   => $<time><hour>.made,
          minute => $<time><minute>.made,
          second => $<time><second>.made
        );
    }

    method !genericDate($/) {
        make { year => $<year>.made, month => $<month>.made, day => $<day>.made };
    }

    method date-spec($/) {
        my %res = $/.values[0].made;
        make DateTime.new(|%res);
    }

    method date1($/) { # e.g., 02 Jun 1982
        self!genericDate($/);
    }

    method date2($/) { # e.g., 02-Jun-82
        self!genericDate($/);
    }

    method date3($/) { # e.g., Jun  2
        self!genericDate($/);
    }

    method date4($/) { # e.g., 02-Jun-1982
        self!genericDate($/);
    }

    method date5($/) { # e.g. 1996-12-19
        self!genericDate($/);
    }

    method date6($/) { # e.g. 28/Mar/2018
        self!genericDate($/);
    }

    method date7($/) { # e.g. 28 March 2018
        self!genericDate($/);
    }

    method date8($/) { # e.g. March 23 2018
        self!genericDate($/);
    }

    method date9($/) { # e.g. 2/23/2018
        self!genericDate($/);
    }

    my %timezones =
            UTC => 0,
            GMT => 0,
            ;

    method asctime-tz($/) {
        my $offset = (%timezones{$<asctime-tzname>.made} // 0) + ($<time-houroffset>.made // 0);

        make { offset-hours => $offset };
    }

    method asctime-tzname($/) {
        make ~$/;
    }

    method time-houroffset($/) {
        make +$/;
    }

    method time($/) {
        make { hour => +$<hour>, minute => +$<minute>, second => +$<second> };
    }

    method time2($/) {
        my $p = $<part>;
        my $offset = 0;
        unless $<offset> eq 'Z'|'z' {
            if ~$<offset><offset><sign> eq '-' {
                $offset = 3600 * ~$<offset><offset><hour>.Int;
                $offset += 60 * ~$<offset><offset><minute>.Int;
            }
        }
        my %res = hour => ~$p<hour>, minute => ~$p<minute>, second => ~$p<second>, timezone => -$offset;
        make %res;
    }

    method time3($/) {
        my Int $offset = 0;

        $offset += +$<time-numoffset><hour> × 60;
        $offset += +$<time-numoffset><minute>;

        make {
            hour     => +$<time><hour>,
            minute   => +$<time><minute>,
            second   => +$<time><second>,
            timezone => $offset,
        };
    }

    my %wkday = Mon => 0, Tue => 1, Wed => 2, Thu => 3, Fri => 4, Sat => 5, Sun => 6;
    method wkday($/) {
        make %wkday{$/.Str.tc};
    }

    my %weekday = Monday => 0, Tuesday => 1, Wednesday => 2, Thursday => 3,
                  Friday => 4, Saturday => 5, Sunday => 6;
    method weekday($/) {
        make %weekday{$/.Str.tc};
    }

    method month($/) {
        make $/.values[0].made;
    }

    my %month-short-name = Jan => 1, Feb => 2, Mar => 3, Apr =>  4, May =>  5, Jun =>  6,
                Jul => 7, Aug => 8, Sep => 9, Oct => 10, Nov => 11, Dec => 12;
    method month-short-name($/) {
        make %month-short-name{$/.Str.tc};
    }

    my %month-name = January => 1, February => 2, March => 3, April =>  4, May =>  5, June =>  6,
                           July => 7, August => 8, September => 9, October => 10, Novemver => 11, December => 12;
    method month-name($/) {
        make %month-name{$/.Str.tc};
    }

    method day($/) {
        make +$/;
    }

    method D4-year($/) {
        make +$/;
    }

    method D2-year($/) {
        my $yy = +$/;
        make $yy < 34 ?? 2000 + $yy !! 1900 + $yy;
    }

    method D2($/) {
        make +$/;
    }

    method D2upto($/) {
        make +$/;
    }

    method day-spec($/) {
        make do given $/.Str.trim {
            when 'today' { Date.today.DateTime }
            when 'yesterday' { Date.today.earlier( :1day).DateTime }
            when 'tomorrow' { Date.today.later(:1day).DateTime }
        }
    }
}
