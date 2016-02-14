use v6;

use PDF::DAO::Dict;
use PDF::DAO::Stream;
use PDF::Doc::Type;
use PDF::Graphics::Contents;
use PDF::Graphics::Page;
use PDF::Graphics::PageNode;

# /Type /Page - describes a single PDF page

class PDF::Doc::Type::Page
    is PDF::DAO::Dict
    does PDF::Doc::Type
    does PDF::Graphics::Page
    does PDF::Graphics::PageNode {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;

    use PDF::Doc::Type::XObject::Form;
    use PDF::DAO::Stream;

    # see [PDF 1.7 TABLE 3.27 Entries in a page object]
    my subset Name-Page of PDF::DAO::Name where 'Page';
    has Name-Page $.Type is entry(:required);
    has Hash $.Parent is entry(:indirect);       #| (Required; must be an indirect reference) The page tree node that is the immediate parent of this page object.
    has Str $.LastModified is entry;             #| (Required if PieceInfo is present; optional otherwise; PDF 1.3) The date and time when the page’s contents were most recently modified
    use PDF::Doc::Type::Resources;
    has PDF::Doc::Type::Resources $.Resources is entry(:inherit);     #| (Required; inheritable) A dictionary containing any resources required by the page
    has Numeric @.MediaBox is entry(:inherit,:len(4));   #| (Required; inheritable) A rectangle, expressed in default user space units, defining the boundaries of the physical medium on which the page is intended to be displayed or printed
    has Numeric @.CropBox is entry(:inherit,:len(4));    #| Optional; inheritable) A rectangle, expressed in default user space units, defining the visible region of default user space. When the page is displayed or printed, its contents are to be clipped (cropped) to this rectangle and then imposed on the output medium in some implementation-defined manner
    has Numeric @.BleedBox is entry(:len(4));    #| (Optional; PDF 1.3) A rectangle, expressed in default user space units, defining the region to which the contents of the page should be clipped when output in a production environment
    has Numeric @.TrimBox is entry(:len(4));     #| Optional; PDF 1.3) A rectangle, expressed in default user space units, defining the intended dimensions of the finished page after trimming
    has Numeric @.ArtBox is entry(:len(4));      #| (Optional; PDF 1.3) A rectangle, expressed in default user space units, defining the extent of the page’s meaningful content (including potential white space) as intended by the page’s creator
    has Hash $.BoxColorInfo is entry;            #| (Optional; PDF 1.4) A box color information dictionary specifying the colors and other visual characteristics to be used in displaying guidelines on the screen for the various page boundaries
    subset StreamOrArray of Any where PDF::DAO::Stream | Array;
    has StreamOrArray $.Contents is entry;       #| (Optional) A content stream (see Section 3.7.1, “Content Streams”) describing the contents of this page. If this entry is absent, the page is empty
    subset NinetyDegreeAngle of Int where { $_ %% 90}
    has NinetyDegreeAngle $.Rotate is entry(:inherit);     #| (Optional; inheritable) The number of degrees by which the page should be rotated clockwise when displayed or printed
    has Hash $.Group is entry;                   #| (Optional; PDF 1.4) A group attributes dictionary specifying the attributes of the page’s page group for use in the transparent imaging model
    has PDF::DAO::Stream $.Thumb is entry;       #| (Optional) A stream object defining the page’s thumbnail image
    has @.B is entry(:indirect);                 #| (Optional; PDF 1.1; recommended if the page contains article beads) An array of indirect references to article beads appearing on the page
    has Numeric $.Dur is entry;                  #| (Optional; PDF 1.1) The page’s display duration (also called its advance timing): the maximum length of time, in seconds, that the page is displayed during presentations before the viewer application automatically advances to the next page
    has Hash $.Trans is entry;                   #| (Optional; PDF 1.1) A transition dictionary describing the transition effect to be used when displaying the page during presentations
    use PDF::Doc::Type::Annot;
    has PDF::Doc::Type::Annot @.Annots is entry; #| (Optional) An array of annotation dictionaries representing annotations associated with the page
    has Hash $.AA is entry;                      #| (Optional; PDF 1.2) An additional-actions dictionary defining actions to be performed when the page is opened or closed
    has PDF::DAO::Stream $.Metadata is entry;    #| (Optional; PDF 1.4) A metadata stream containing metadata for the page
    has Hash $.PieceInfo is entry;               #| (Optional; PDF 1.3) A page-piece dictionary associated with the page
    has UInt $.StructParents is entry;           #| (Required if the page contains structural content items; PDF 1.3) The integer key of the page’s entry in the structural parent tree
    has Str $.ID is entry;                       #| (Optional; PDF 1.3; indirect reference preferred) The digital identifier of the page’s parent Web Capture content set
    has Numeric $.PZ is entry;                   #| (Optional; PDF 1.3) The page’s preferred zoom (magnification) factor
    has Hash $.SeparationInfo is entry;          #| (Optional; PDF 1.3) A separation dictionary containing information needed to generate color separations for the page
    has PDF::DAO::Name $.Tabs is entry;          #| (Optional; PDF 1.5) A name specifying the tab order to be used for annotations on the page
    has PDF::DAO::Name $.TemplateInstantiated is entry; #| (Required if this page was created from a named page object; PDF 1.5) The name of the originating page object
    has Hash $.PressSteps is entry;              #| (Optional; PDF 1.5) A navigation node dictionary representing the first node on the pag
    has Numeric $.UserUnit is entry;             #| (Optional; PDF 1.6) A positive number giving the size of default user space units, in multiples of 1 ⁄ 72 inch
    has $.VP is entry;                           #| Optional; PDF 1.6) An array of viewport dictionaries

}

