use v6;

use PDF::Struct::Function;

#| /FunctionType 4 - PostScript
# see [PDF 1.7 Section 3.9.4 Type 4 (PostScript Calculator) Functions]
class PDF::Struct::Function::PostScript
    is PDF::Struct::Function {

    method parse(Str $decoded = $.decoded) {
	use PDF::Grammar::Function;
	use PDF::Grammar::Function::Actions;
	state $actions //= PDF::Grammar::Function::Actions.new;
	PDF::Grammar::Function.parse($decoded, :$actions)
	    // die "unable to parse postscript function: $decoded";
	$/.ast
    }

}