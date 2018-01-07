use v6;

use PDF::DAO::Dict;
use PDF::Class::Type;

#| /Type /OBJR - a node in the page tree
class PDF::OBJR
    is PDF::DAO::Dict
    does PDF::Class::Type {

    # see [PDF 1.7 TABLE 10.12 Entries in an object reference dictionary]
    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    use PDF::Page;
    my subset Name-OBJR of PDF::DAO::Name where 'OBJR';
    has Name-OBJR $.Type is entry(:required);
    has PDF::Page $.Pg is entry(:indirect);       #| (Optional; must be an indirect reference) The page object representing the page on which the object is rendered. This entry overrides any Pg entry in the structure element containing the object reference; it is required if the structure element has no such entry.
    has $.Obj is entry(:required,:indirect); #| (Required; must be an indirect reference) The referenced object.

}
