use v6.d;

use DateTime::Grammarish;
use DateTime::Actions::Raku;

grammar DateTime::Grammar
        does DateTime::Grammarish {

}

#-----------------------------------------------------------
my $pCOMMAND = DateTime::Grammar;

my $actionsObj = DateTime::Actions::Raku.new();

sub datetime-parse(Str:D $spec,
                   Str:D :$rule = 'TOP',
                   Bool :$extended = True
                   ) is export {
    return $pCOMMAND.parse($spec, :$rule, args => $rule eq 'TOP' ?? ($extended,) !! Empty);
}

sub datetime-subparse(Str:D $spec,
                      Str:D :$rule = 'TOP',
                      Bool :$extended = True
                      ) is export {
    return $pCOMMAND.subparse($spec, :$rule, args => $rule eq 'TOP' ?? ($extended,) !! Empty);
}

#| Conversion of datetime specification into code. (For example, a Raku DateTime object.)
#| C<$spec> Specification string.
#| C<:$rule> Rule name to start the parsing with.
#| C<:$actions> Actions to use.
proto datetime-interpret(|) is export {*}

multi sub datetime-interpret(Str:D $spec,
                             Str:D :$rule = 'TOP',
                             :target(:$actions) is copy = $actionsObj,
                             Bool :$extended = True
                             ) is export {
    if $actions.isa(Whatever) || $actions ~~ Str && $actions.lc eq 'raku' { $actions = $actionsObj; }
    return $pCOMMAND.parse($spec, :$rule, :$actions, args => $rule eq 'TOP' ?? ($extended,) !! Empty).made;
}