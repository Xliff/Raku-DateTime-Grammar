use v6.d;

role DateTime::Grammarish {

    token TOP ($*extended) {
        <datetime-param-spec>
    }

    token datetime-param-spec {
        [
          <rfc3339-date>     | <rfc1123-date>        | <rfc850-date>  |
          <rfc850-var-date>  | <rfc850-var-date-two> | <asctime-date> |
          <nginx-date>       | <mysql-date>          | <us-date>      |
          <intl-date>        | <auth-log-date>
        ]
          ||
        [ <day-spec> | <date-spec> ] <?{$*extended}>
    }

    token datetime-spec {
        <rfc3339-date>    | <rfc1123-date>        | <rfc850-date>  |
        <rfc850-var-date> | <rfc850-var-date-two> | <asctime-date> |
        <nginx-date>      | <day-spec>            | <date-spec>
    }

    token rfc3339-date {
        <date=.date5> <[Tt \x0020]> <time=.time2>
    }

    token nginx-date {
        <date=.date6> ':' <time=.time3>
    }

    token mysql-date {
      <date5> <.ws> <time=partial-time>
    }

    token us-date {
         <month=.D2> '/' <day=.D2> '/' <year=.D4-year>
    }

    rule auth-log-date {
      <month-short-name> <day=.D2upto> <time=partial-time>
    }

    token intl-date {
         <year=.D4-year> '/' <month=.D2> '/' <day=.D2>
    }

    token time2 {
        <part=.partial-time> <offset=.time-offset>
    }

    token time3 {
        <time=.partial-time> ' ' <time-numoffset>
    }

    token partial-time {
        <hour=.D2> ':' <minute=.D2> ':' <second=.D2> <frac=.time-secfrac>?
    }

    token time-secfrac {
        '.' \d+
    }

    token time-offset {
        ['Z' | 'z' | <offset=.time-numoffset>]
    }

    token time-numoffset {
        <sign=[+-]> <hour=.D2> ':'? <minute=.D2>
    }

    token time-houroffset {
        <sign=[+-]> <hour>
    }

    token hour {
        \d \d?
    }

    token gmt-or-numeric-tz {
        'GMT' | 'UTC' | [<[-+]>? <[0..9]> ** 4]
    }

    token rfc1123-date {
        <.wkday> ',' <.SP> <date=.date1> <.SP> <time> <.SP>
        <gmt-or-numeric-tz>
    }

    token rfc850-date {
        <.weekday> ',' <.SP> <date=.date2> <.SP> <time> <.SP>
        <gmt-or-numeric-tz>
    }

    token rfc850-var-date {
        <.wkday> ','? <.SP> <date=.date4> <.SP> <time> <.SP>
        <gmt-or-numeric-tz>
    }

    token rfc850-var-date-two {
        <.wkday> ','? <.SP> <date=.date2> <.SP> <time> <.SP>
        <gmt-or-numeric-tz>
    }

    token asctime-date {
        <.wkday> <.SP> <date=.date3> <.SP> <time> <.SP> <year=.D4-year>
        <asctime-tz>?
    }

    token asctime-tz {
        <.SP> <asctime-tzname> <time-houroffset>?
    }

    token asctime-tzname {
        \w+
    }

    token date-spec {
        <date1> | <date2> | <date3> | <date4> | <date5> | <date6> |
        <date7> | <date8> | <date9>
    }

    token date1 {
        # e.g., 02 Jun 1982
        <day=.D2> <.SP> <month> <.SP> <year=.D4-year>
    }

    token date2 {
        # e.g., 02-Jun-82
        <day=.D2> '-' <month> '-' <year=.D2>
    }

    token date3 {
        # e.g., Jun  2
        <month> <.SP> <day>
    }

    token date4 {
        # e.g., 02-Jun-1982
        <day=.D2> '-' <month> '-' <year=.D4-year>
    }

    token date5 {
        <year=.D4-year> '-' <month=.D2> '-' <day=.D2>
    }

    token date6 {
        <day=.D2> '/' <month> '/' <year=.D4-year>
    }

    token date7 {
        <day=.D2upto> \h+ <month> \h+ <year=.D4-year>
    }

    token date8 {
        <month> \h+ <day=.D2upto> \h+ <year=.D4-year>
    }

    token date9 {
        <month=.D2upto> '/' <day=.D2upto> '/' <year=.D4-year>
    }

    token time {
        <hour=.D2> ':' <minute=.D2> ':' <second=.D2>
    }

    token day {
        <.D1> | <.D2>
    }

    token wkday {
        :i
        'Mon' | 'Tue' | 'Wed' | 'Thu' | 'Fri' | 'Sat' | 'Sun'
    }

    token weekday {
        :i
        'Monday'   | 'Tuesday' | 'Wednesday' | 'Thursday' | 'Friday' |
        'Saturday' | 'Sunday'
    }

    token month { <month-name> | <month-short-name> }

    token month-short-name {
        :i
        'Jan' | 'Feb' | 'Mar' | 'Apr' | 'May' | 'Jun' | 'Jul' | 'Aug' |
        'Sep' | 'Oct' | 'Nov' | 'Dec'
    }

    token month-name {
        :i
        'January'  | 'February'  | 'March'     | 'April'    | 'May' | 'June' |
        'July'     | 'August'    | 'September' | 'October'  |
        'November' |  'December'
    }

    token D4-year {
        \d ** 4
    }

    token D2-year {
        \d ** 2
    }

    token SP {
        \s+
    }

    token D1 {
        \d
    }

    token D2 {
        \d ** 2
    }

    token D2upto {
        \d ** 1..2
    }

    token day-spec { :i 'yesterday' | 'today' | 'tomorrow' }
}
