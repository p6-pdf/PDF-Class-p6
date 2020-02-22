use v6;
use Test;
use PDF::Class;

my $read-me = "README.md".IO.slurp;

$read-me ~~ /^ $<waffle>=.*? +%% ["```" \n? $<code>=.*? "```" \n?] $/
    or die "README.md parse failed";

my $n = 0;

for @<code> {
    my $snippet = ~$_;
    # assume anything else is code.
    $snippet = $snippet.subst('DateTime.now;', 'DateTime.new( :year(2015), :month(12), :day(25) );' );
    # disable say
    sub say(|c) { }
    # ensure consistant document ID generation
    srand(123456);
    lives-ok {quietly EVAL $snippet}, 'code sample'
	or warn "eval error: $snippet\n$!";
}

done-testing;
