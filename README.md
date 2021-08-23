# [WireGuard](https://www.wireguard.com/) for iOS, macOS and tvOS
This project contains an application for iOS, macOS and tvOS as well as many components shared between the three of them. You may toggle between the three platforms by selecting the target from within Xcode.

## tvOS Notes

The tvOS functionality is now 1:1 with its iOS / macOS counterparts!

The tvOS support requires a jailbreak to function. there are a lot of 'unavailable' and foribben API's called, in conjunction with code signing entitlements that are not allowed on tvOS. 'ldid2' is used to fake codesign with the necessary entitlements, and to work around some golang jankiness re: tvOS the Makefile for the tvOS bridge is re-written as 2 shell scripts. A new post build script is also added to the new tvOS target to handle code-signing, creating a dpkg and scping over to a host specified in said shell script, some modifications are currently necessary to the tvOS SDK files to enable building in Xcode without code signing.

There is now a handy script to disable tvOS code signing in Xcode.

```
$ ./disable_TVOS_Codesign.sh
```
***The following information is just included for posterity, it should be handled by the script mentioned above!***

The script above will take the file found with the command run below:
```
$ open $(xcrun --show-sdk-path --sdk appletvos)/SDKSettings.plist
```
And change two string keys from `YES` to `NO` in  `DefaultProperties`: `ENTITLEMENTS_REQUIRED` & `CODE_SIGNING_REQUIRED`

There is a companion JSON file, the values *might* need to be changed in there as well, uncertain about that, if they do indeed need changing they will need to be changed manually for now.

## Building

- Clone this repo:

```
$ git clone https://git.zx2c4.com/wireguard-apple
$ cd wireguard-apple
```

- Rename and populate developer team ID file:

```
$ cp Sources/WireGuardApp/Config/Developer.xcconfig.template Sources/WireGuardApp/Config/Developer.xcconfig
$ vim Sources/WireGuardApp/Config/Developer.xcconfig
```

- Install swiftlint and go 1.15:

```
$ brew install swiftlint go
```

- Open project in Xcode:

```
$ open WireGuard.xcodeproj
```

- Flip switches, press buttons, and make whirling noises until Xcode builds it.

## WireGuardKit integration

1. Open your Xcode project and add the Swift package with the following URL:
   
   ```
   https://git.zx2c4.com/wireguard-apple
   ```
   
2. `WireGuardKit` links against `wireguard-go-bridge` library, but it cannot build it automatically
   due to Swift package manager limitations. So it needs a little help from a developer. 
   Please follow the instructions below to create a build target(s) for `wireguard-go-bridge`.
   
   - In Xcode, click File -> New -> Target. Switch to "Other" tab and choose "External Build 
     System".
   - Type in `WireGuardGoBridge<PLATFORM>` under the "Product name", replacing the `<PLATFORM>` 
     placeholder with the name of the platform. For example, when targeting macOS use `macOS`, or 
     when targeting iOS use `iOS`.
     Make sure the build tool is set to: `/usr/bin/make` (default).
   - In the appeared "Info" tab of a newly created target, type in the "Directory" path under 
     the "External Build Tool Configuration":
     
     ```
     ${BUILD_DIR%Build/*}SourcePackages/checkouts/wireguard-apple/Sources/WireGuardKitGo
     ```
     
   - Switch to "Build Settings" and find `SDKROOT`.
     Type in `macosx` if you target macOS, or type in `iphoneos` if you target iOS.
   
3. Go to Xcode project settings and locate your network extension target and switch to 
   "Build Phases" tab.
   
   - Locate "Dependencies" section and hit "+" to add `WireGuardGoBridge<PLATFORM>` replacing 
     the `<PLATFORM>` placeholder with the name of platform matching the network extension 
     deployment target (i.e macOS or iOS).
     
   - Locate the "Link with binary libraries" section and hit "+" to add `WireGuardKit`.
   
4. In Xcode project settings, locate your main bundle app and switch to "Build Phases" tab. 
   Locate the "Link with binary libraries" section and hit "+" to add `WireGuardKit`.
   
5. iOS only: Locate Bitcode settings under your application target, Build settings -> Enable Bitcode, 
   change the corresponding value to "No".
   
Note that if you ship your app for both iOS and macOS, make sure to repeat the steps 2-4 twice, 
once per platform.

## MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
