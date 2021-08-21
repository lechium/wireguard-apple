
//Needed header interfaces

@interface LSPlugInKitProxy: NSObject

+(id)pluginKitProxyForURL:(id)url;

@end

%hook LSApplicationWorkspace

-(id)pluginsMatchingQuery:(id)arg1 applyFilter:(id)arg2 {
    %log; 
    NSArray *r = %orig; 
    if ([r count] == 0) {
	//only adjust the query if nothing is returned, least intrusive way to do this.
	NSString *identifier = [arg1 objectForKey:@"NSExtensionIdentifier"];
	if ([identifier isEqualToString:@"com.nito.wireguard-ios.network-extension"]) {
	    NSString *path = @"/Applications/WireGuardtvOS.app/PlugIns/WireGuardNetworkExtensiontvOS.appex";
	    id plugin = [%c(LSPlugInKitProxy) pluginKitProxyForURL: [NSURL fileURLWithPath:path]];
	    HBLogDebug(@"plugin: %@", plugin);
	    return @[plugin];

	}
    }
    return r; 
}

%end
