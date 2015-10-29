use v6;
use Test;

plan 44;

use PDF::Storage::IndObj;
use PDF::DOM::Type;
use PDF::Grammar::Test :is-json-equiv;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::DAO::Stream;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
4 0 obj
<<
  /Type /Page
  /Parent 3 0 R
  /Resources << /Font << /F1 7 0 R >>/ProcSet 6 0 R >>
  /MediaBox [0 0 595 842]
>>
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my $ast = $/.ast;
my $ind-obj = PDF::Storage::IndObj.new( |%$ast);
is $ind-obj.obj-num, 4, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $page = $ind-obj.object;
isa-ok $page, ::('PDF::DOM::Type')::('Page');
is $page.Type, 'Page', '$.Type accessor';
my $dummy-stream = PDF::DAO::Stream.new( :decoded('%dummy stream') );
is $page<Parent>, (:ind-ref[3, 0]), '$page<Parent>';
is $page.Resources, { :Font{ :F1( :ind-ref[7, 0] )}, :ProcSet( :ind-ref[6, 0]) }, '$.Resources accessor';

is-json-equiv $ind-obj.ast, $ast, 'ast regeneration';

$page.Contents = $dummy-stream;
is-deeply $page.Contents, ($dummy-stream), '$.Contents accessor';
is-deeply $page.content-streams, [$dummy-stream], '$.contents accessor';
is-deeply $page.contents, '%dummy stream', '$.contents accessor';

my $font = $page.core-font( 'Helvetica' );
isa-ok $font, ::('PDF::DOM::Type::Font::Type1');
is $font.font-obj.FontName, 'Helvetica', '.FontName';
my $font-again = $page.core-font( 'Helvetica' );
is-deeply $font-again, $font, 'core font caching';
is-deeply [$page.Resources<Font>.keys.sort], [<F1 F2>], 'font resource entries';
my $font2 = $page.core-font( :family<Helvetica>, :weight<bold> );
is $font2.font-obj.FontName, 'Helvetica-Bold', '.FontName';
is-deeply [$page.Resources<Font>.keys.sort], [<F1 F2 F3>], 'font resource entries';

is-json-equiv $page.MediaBox, [0, 0, 595, 842], '$.MediaBox accessor';
is-json-equiv $page.media-box, [0, 0, 595, 842], '$.media-box accessor';
is-json-equiv $page.crop-box, $page.media-box, '$.crop-box accessor';
is-json-equiv $page.bleed-box, $page.media-box, '$.bleed-box accessor';
is-json-equiv $page.art-box, $page.crop-box, '$.art-box - accessor';
is-json-equiv $page.trim-box, $page.crop-box, '$.trim-box - accessor';

$page<MediaBox>:delete;
is-json-equiv $page.media-box, [0, 0, 612, 792], 'media-box - default';
is-json-equiv $page.bleed-box, $page.media-box, '$.bleed-box - default';

$page.media-box(150,200);
is-json-equiv $page.media-box, [0, 0, 150, 200], 'media-box - 2 arg setter';

$page.media-box(-10,-10,260,310);
$page.crop-box(0,0,250,300);
$page.bleed-box(-3,-3,253,303);
is-json-equiv $page.media-box, [-10, -10, 260, 310], 'media-box - 4 arg setter';
is-json-equiv $page.MediaBox, [-10, -10, 260, 310], '.MediaBox accessor';
is-json-equiv $page<MediaBox>, [-10, -10, 260, 310], '<MediaBox> accessor';
is-json-equiv $page.crop-box, [0, 0, 250, 300], '$.crop-box - updated';
is-json-equiv $page.bleed-box, [-3, -3, 253, 303], '$.bleed-box - updated';
is-json-equiv $page.trim-box, $page.crop-box, '$trim-box - get';
is-json-equiv $page.art-box, $page.crop-box, '$.art-box - get';
$page.art-box(10,10,240,290);
is-json-equiv $page.art-box, [10,10,240,290], '$.art-box - updated';
$page.media-box('a3');
is-json-equiv $page.media-box, [0,0,842,1190], 'media-box page-name setter';
$page.media-box('a3', :landscape);
is-json-equiv $page.media-box, [0,0,1190,842], 'media-box page-name setter :landscape';

$page.gfx.ops(['BT', :Tj[ :literal('Hello, world!') ], 'ET']);
$page.cb-finish;

my $contents = $page.Contents;
isa-ok $contents, Array, 'finished Contents';
is-deeply +$contents, 3, 'finished Contents count';

isa-ok $contents[0], ::('PDF::DAO::Stream'), 'finished Contents';
is $contents[0].decoded, "q\n", 'finished Contents pretext';
is $contents[1].decoded, '%dummy stream', 'finished Contents existing text';
is-deeply [$contents[2].decoded.lines], ['', 'Q', 'BT', '  (Hello, world!) Tj', 'ET'], 'finished Contents post-text';

my $xobject = $page.to-xobject;
isa-ok $xobject, ::('PDF::DOM::Type::XObject::Form');
is-deeply $xobject.BBox, $page.trim-box, 'xobject copied trim-box';
is-deeply [$xobject.decoded.lines], ['q',
                                     '%dummy stream',
                                     'Q', 'BT', '  (Hello, world!) Tj', 'ET' ], 'xobject decoded';


