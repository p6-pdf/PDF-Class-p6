use v6;

use PDF::COS::Tie::Hash;

role PDF::Filespec
    does PDF::COS::Tie::Hash {

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::COS::ByteString;
    use PDF::COS::TextString;
    use PDF::COS::Dict;
    use PDF::COS::Stream;

    has PDF::COS::Name $.Type is entry where 'Filespec'; #| (Required if an EF or RF entry is present; recommended always) The type of PDF object that this dictionary describes; shall be Filespec for a file specification dictionary.
    has PDF::COS::Name $.FS is entry; #| (Optional) The name of the file system that shall be used to interpret this file specification. If this entry is present, all other entries in the dictionary shall be interpreted by the designated file system. PDF shall define only one standard file system name, URL (see 7.11.5, "URL Specifications"); an application can register other names (see Annex E). This entry shall be independent of the F, UF, DOS, Mac, and Unix entries.
    has PDF::COS::ByteString $.F is entry; #| (Required if the DOS, Mac, and Unix entries are all absent; amended with the UF entry for PDF 1.7) A file specification string of the form described in 7.11.2, "File Specification Strings," or (if the file system is URL) a uniform resource locator, as described in 7.11.5, "URL Specifications."
    has PDF::COS::TextString $.UF is entry; #| (Optional, but recommended if the F entry exists in the dictionary; PDF 1.7) A Unicode text string that provides file specification of the form described in 7.11.2, "File Specification Strings." This is a text string encoded using PDFDocEncoding or UTF-16BE with a leading byte-order marker (as defined in 7.9.2.2, "Text String Type"). The F entry should be included along with this entry for backwards compatibility reasons.
    has PDF::COS::ByteString $.DOS is entry; #| (Optional) A file specification string representing a DOS file name. This entry is obsolescent and should not be used by conforming writers.
    has PDF::COS::ByteString $.Mac is entry; #| (Optional) A file specification string representing a Mac OS file name. This entry is obsolescent and should not be used by conforming writers.
    has PDF::COS::ByteString $.Unix is entry; #| (Optional) A file specification string representing a UNIX file name. This entry is obsolescent and should not be used by conforming writers.
    has PDF::COS::ByteString @.D is entry(:len(2)); #| (Optional) An array of two byte strings constituting a file identifier that should be included in the referenced file.
    has Bool $.V is entry; #| (Optional; PDF 1.2) A flag indicating whether the file referenced by the file specification is volatile (changes frequently with time). If the value is true, applications shall not cache a copy of the file. For example, a movie annotation referencing a URL to a live video camera could set this flag to true to notify the conforming reader that it should re-acquire the movie each time it is played. Default value: false.
    has PDF::COS::Stream %.EF is entry; #| (Required if RF is present; PDF 1.3; amended to include the UF key in PDF 1.7) A dictionary containing a subset of the keys F, UF, DOS, Mac, and Unix, corresponding to the entries by those names in the file specification dictionary. The value of each such key shall be an embedded file stream containing the corresponding file. If this entry is present, the Type entry is required and the file specification dictionary shall be indirectly referenced. The F and UF entries should be used in place of the DOS, Mac, or Unix entries.
    has Array %.RF is entry; #| (Optional; PDF 1.3) A dictionary with the same structure as the EF dictionary, which shall be present. Each key in the RF dictionary shall also be present in the EF dictionary. Each value shall be a related files array (see 7.11.4.2, "Related Files Arrays") identifying files that are related to the corresponding file in the EF dictionary. If this entry is present, the Type entry is required and the file specification dictionary shall be indirectly referenced.
    has PDF::COS::TextString $.Desc is entry; #| (Optional; PDF 1.6) Descriptive text associated with the file specification. It shall be used for files in the EmbeddedFiles name tree (see 7.7.4, "Name Dictionary").
    has PDF::COS::Dict $.CI is entry(:indirect); #| (Optional; shall be indirect reference; PDF 1.7) A collection item dictionary, which shall be used to create the user interface for portable collections.
}
