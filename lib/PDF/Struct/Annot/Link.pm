use v6;

use PDF::Struct::Annot;

class PDF::Struct::Annot::Link
    is PDF::Struct::Annot {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;

    # See [PDF 1.7 TABLE 8.24 Additional entries specific to a link annotation]
    has Hash $.A is entry;             #| (Optional; PDF 1.1) An action to be performed when the link annotation is activated (see Section 8.5, “Actions”).
    has $.Dest is entry;               #| (Optional; not permitted if an A entry is present) A destination to be displayed when the annotation is activated
    subset HName of PDF::DAO::Name where 'N'|'I'|'O'|'P';
    has HName $.H is entry;            #| (Optional; PDF 1.2) The annotation’s highlighting mode, the visual effect to be used when the mouse button is pressed or held down inside its active area:
                                       #| N(None)    - No highlighting.
                                       #| I(Invert)  - Invert the contents of the annotation rectangle.
                                       #| O(Outline) - Invert the annotation’s border.
                                       #| P(Push)    - Display the annotation as if it were being pushed below the surface of the page;
                                       #| Default value: I.
    has Hash $.PA is entry;            #| (Optional; PDF 1.3) A URI action
    has Numeric @.QuadPoints is entry; #| (Optional; PDF 1.6) An array of 8 × n numbers specifying the coordinates of nquadrilaterals in default user space that comprise the region in which the link should be activated. The coordinates for each quadrilateral are given in the order: x1 y1 x2 y2 x3 y3 x4 y4, specifying the four vertices of the quadrilateral in counterclockwise order.

}