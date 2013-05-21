//
//  XMLParser.m
//  Music Find
//
//  Created by Memphis on 12/12/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

/*
 * Κατασκευαστής, αρχικοποίηση απαραιτήτων αντικειμένων και δημιουργία νήματος.
 */

- (id)initWithDelegate:(id)d url:(NSURL *)u
{
    self = [super init];
    delegate = d;
    url = u;
	thread = [NSThread currentThread];
    outstring = [[NSMutableString alloc] init];
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object: nil];
    outTitles = [[NSMutableArray alloc] init];
    tmp = [[NSMutableString alloc] init];
    [myThread start];
	return self;
}

/*
 * Μέθοδος που θα τρέχει στο καινούριο νήμα. Καλεί τις μεθόδους parse για εκκίνηση της ανάλυσης των δεδομένων XML και έπειτα καλεί τις μεθόδους στην κλάση-αντιπρόσωπο που θα χειριστεί τα αποτελέσματα.
 */

- (void)run:(id)param
{
    NSXMLParser *parser = [NSXMLParser alloc];
    parser = [parser initWithContentsOfURL: url];
    [parser setDelegate: self];
    [parser parse];
    NSLog(@"%@",outTitles);
    if ([delegate respondsToSelector:@selector(parseTitles:)])
        [delegate performSelector:@selector(parseTitles:) onThread: thread
                       withObject: outTitles waitUntilDone:NO];
    if ([delegate respondsToSelector:@selector(parseIDs:)])
        [delegate performSelector:@selector(parseIDs:) onThread: thread
                       withObject: outstring waitUntilDone:NO];
}

/*
 * Μέθοδος που καλείται κατα τον εντοπισμό νέου tag.
 */

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if (qName) elementName = qName;
    if (elementName)
    {
        current = [NSString stringWithString:elementName];
        [tmp setString:@""];
    }
}

/*
 * Μέθοδος που καλείται κατα το τέλος του tag.
 */

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([current isEqualToString:@"id"]) [outstring appendFormat:@"%@", @"\n"];
    if ([current isEqualToString:@"title"])
    {
        [outTitles addObject:[NSString stringWithString:tmp]];
    }
    current = nil;
}

/*
 * Μέθοδος που καλείται για την ανάλυση του περιεχομένου του tag.
 */

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (!current) return;
	if ([current isEqualToString:@"id"])
        [outstring appendFormat:@"%@", [[string componentsSeparatedByString:@"/item/"] lastObject]];
    if ([current isEqualToString:@"title"])
    {
        [tmp appendString:string];
    }
}

-(void) parserDidEndDocument:(NSXMLParser *)parser {}
-(void) parserDidStartDocument:(NSXMLParser *)parser {}

@end
