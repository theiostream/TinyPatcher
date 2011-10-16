// TinyPatcher.mm
// File Patcher; the core of TinyPatcher's patching

// TODO: - Add a nice dictionary handling implementation kinda like the array thing
//       - Make alternatives for stuff like "FullyFeatured" or "MT Gestures Theme" with TinyPatcher, so your system plists can stay safe for other extensions.

void printUsage(void) {
	printf("[TinyPatcher Usage Error] Use TinyPatcher with patcher.sh script OR head to <http://matoe.co.cc/patcher.txt>\n");
}
	
int main(int argc, char **argv, char **envp) {
	printf("Hey. Welcome to TinyPatcher!\n");
	
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	
	if (!argv[1]) { printUsage(); return 1; }
	if (!argv[2]) { printUsage(); return 1; }
	
	NSMutableDictionary *oldf = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:argv[1]]];
	NSDictionary *newf = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:argv[2]]];
	
	NSArray *nkeys = [newf allKeys];
	if (!nkeys) printf("[TinyPatcher] Error. Plist couldn't be read.\n");

	for (unsigned int i=0; i<[nkeys count]; i++) {
		// ====== array crap -- optional shit
		if (argv[3]) {
			if ([[NSString stringWithUTF8String:argv[3]] isEqualToString:@"arr"]) {
				if ([[newf objectForKey:[nkeys objectAtIndex:i]] isKindOfClass:[NSArray class]]) {
					NSMutableArray *indexes = [NSMutableArray arrayWithArray:[oldf objectForKey:[nkeys objectAtIndex:i]]];
					
					// optional flag
					if (argv[4]) {
						if ([[NSString stringWithUTF8String:argv[4]] isEqualToString:@"rep"]) {
							// recursive substitution; add crap on end
							for (unsigned int d=0; d<[[newf objectForKey:[nkeys objectAtIndex:i]] count]; d++) {
								if ([[[newf objectForKey:[nkeys objectAtIndex:i]] objectAtIndex:d] isKindOfClass:[NSString class]]) {
									if ([[[newf objectForKey:[nkeys objectAtIndex:i]] objectAtIndex:d] isEqualToString:@"keep"]) {
										continue;
									}
								}
								
								if ([[newf objectForKey:[nkeys objectAtIndex:i]] count] > [[oldf objectForKey:[nkeys objectAtIndex:i]] count]) {
									if ((d+1) >= [[oldf objectForKey:[nkeys objectAtIndex:i]] count]) {
										[indexes addObject:[[newf objectForKey:[nkeys objectAtIndex:i]] objectAtIndex:d]];
										continue;
									}
								}
								
								[indexes replaceObjectAtIndex:d withObject:[[newf objectForKey:[nkeys objectAtIndex:i]] objectAtIndex:d]];
								
							}
							
							[oldf setObject:indexes forKey:[nkeys objectAtIndex:i]];
							continue;
						}
					}
					
					// add crap
					for (unsigned int a=0; a<[[newf objectForKey:[nkeys objectAtIndex:i]] count]; a++) {
						[indexes addObject:[[newf objectForKey:[nkeys objectAtIndex:i]] objectAtIndex:a]];
					}
					
					[oldf setObject:indexes forKey:[nkeys objectAtIndex:i]];
					continue;
				}
			}
		}
		// ======
		
		[oldf setObject:[newf objectForKey:[nkeys objectAtIndex:i]] forKey:[nkeys objectAtIndex:i]];
	}
	
	[oldf writeToFile:[NSString stringWithUTF8String:argv[1]] atomically:YES];
	
	[p drain];
	return 0;
}

