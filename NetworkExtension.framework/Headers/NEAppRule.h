/*
 * Copyright (c) 2013-2015, 2018 Apple Inc.
 * All rights reserved.
 */

#ifndef __NE_INDIRECT__
#error "Please import the NetworkExtension module instead of this file directly."
#endif

NS_ASSUME_NONNULL_BEGIN

/*!
 * @file NEAppRule.h
 * @discussion This file declares the NEAppRule API. The NEAppRule API is used to create rules that match network traffic by the source application of the traffic.
 *
 * This API is part of NetworkExtension.framework
 */

/*!
 * @interface NEAppRule
 * @discussion The NEAppRule class declares the programmatic interface for an object that contains the match conditions for a rule that is used to match network traffic originated by applications.
 *
 * NEAppRule is used in the context of a Network Extension configuration to specify what traffic should be made available to the Network Extension.
 *
 * Instances of this class are thread safe.
 */
API_AVAILABLE(macos(10.11), ios(9.0)) API_UNAVAILABLE(watchos) __WATCHOS_PROHIBITED
@interface NEAppRule : NSObject <NSSecureCoding,NSCopying>

/*!
 * @method initWithSigningIdentifier:
 * @discussion Initializes a newly-allocated NEAppRule object.
 * @param signingIdentifier The signing identifier of the executable that matches the rule.
 */
- (instancetype)initWithSigningIdentifier:(NSString *)signingIdentifier API_AVAILABLE(ios(9.0)) API_UNAVAILABLE(macos) __WATCHOS_PROHIBITED;

/*!
 * @method initWithSigningIdentifier:designatedRequirement:
 * @discussion Initializes a newly-allocated NEAppRule object.
 * @param signingIdentifier The signing identifier of the executable that matches the rule.
 * @param designatedRequirement The designated requirement of the executable that matches the rule.
 */
- (instancetype)initWithSigningIdentifier:(NSString *)signingIdentifier designatedRequirement:(NSString *)designatedRequirement API_AVAILABLE(macos(10.11)) API_UNAVAILABLE(ios, watchos, tvos);

/*!
 * @property matchSigningIdentifier
 * @discussion A string containing a signing identifier. If the code signature of the executable being evaluated has a signing identifier equal to this string and all other conditions of the rule match, then the rule matches.
 */
@property (readonly) NSString *matchSigningIdentifier API_AVAILABLE(macos(10.11), ios(9.0)) API_UNAVAILABLE(watchos) __WATCHOS_PROHIBITED;

/*!
 * @property matchDesignatedRequirement
 * @discussion A string containing a designated requirement. If the code signature of the exectuable being evaluated has a designated requirement equal to this string and all other conditions of the rule match, then the rule matches. This property is required on Mac OS X.
 */
@property (readonly) NSString *matchDesignatedRequirement API_AVAILABLE(macos(10.11)) API_UNAVAILABLE(ios, watchos, tvos);

/*!
 * @property matchPath
 * @discussion A string containing a file system path. If the file system path of the executable being evaluated is equal to this string and all other conditions of the rule match, then the rule matches. This property is optional.
 */
@property (copy, nullable) NSString *matchPath API_AVAILABLE(macos(10.11), ios(9.3)) API_UNAVAILABLE(watchos) __WATCHOS_PROHIBITED;

/*!
 * @property matchDomains
 * @discussion An array of strings. This property is actually read-only. If the destination host of the network traffic being evaluated has a suffix equal to one of the strings in this array and all other conditions of the rule match, then the rule matches. This property is optional.
 */
@property (copy, nullable) NSArray *matchDomains API_AVAILABLE(macos(10.11), ios(9.0)) API_UNAVAILABLE(watchos) __WATCHOS_PROHIBITED;

/*!
 * @property matchTools
 * @discussion An array of NEAppRule objects. Use this property to restrict this rule to only match network traffic that is generated by one or more "helper tool" processes that are spawned by the app that matches this rule.
 *     For example, to match network traffic generated by the "curl" command line tool when the tool is run from Terminal.app, create an NEAppRule for Terminal.app and set the app rule's matchTools property to an array that
 *     contains an NEAppRule for the "curl" command line tool.
 *     Set this property to nil (which is the default) to match all network traffic generated by the matching app and all helper tool processes spawned by the matching app.
 */
@property (copy, nullable) NSArray<NEAppRule *> *matchTools API_AVAILABLE(macos(10.15.4)) API_UNAVAILABLE(ios, watchos, tvos);

@end

NS_ASSUME_NONNULL_END
