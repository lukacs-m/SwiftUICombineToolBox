# SwiftUICombineToolBox

[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20watchOS%20%7C%20-lightgrey.svg)](https://github.com/lukacs-m/SwiftUICombineToolBox)
[![SPM compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)
[![Swift](https://img.shields.io/badge/Swift-5.3-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-12.4-blue.svg)](https://developer.apple.com/xcode)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)

SwiftUICombineToolBox is a collection of **SwiftUI/Combine extensions**. It contains helpfull methods, syntactic sugar, and usefull Tools for iOS, watchOS.

## Requirements

- **iOS** 10.0+ / **watchOS** 7.0+
- Swift 5.0+


## Installation

<details>
<summary>Swift Package Manager</summary>
</br>
<p>You can use <a href="https://swift.org/package-manager">The Swift Package Manager</a> to install <code>SwiftUICombineToolBox</code> by adding the proper description to your <code>Package.swift</code> file:</p>

<pre>
```
dependencies: [
    .package(url: "https://github.com/lukacs-m/SwiftUICombineToolBox", from: "0.0.13"),
]
```
</pre>

Or in Xcode via File > Swift Packages > Add Package Dependency...

</details>


## List of All Extensions

<details>
<summary>Combine Extensions</summary>
</br>
<ul>
<li><a href="https://github.com/lukacs-m/SwiftUICombineToolBox/blob/master/Sources/SwiftUICombineToolBox/Extensions/Combine/Publishers%2BExtensions.swift"><code>Publisher extensions</code></a></li>
<li><a href="https://github.com/lukacs-m/SwiftUICombineToolBox/blob/master/Sources/SwiftUICombineToolBox/Extensions/Combine/AnyPublishers%2BExtensions.swift"><code>AnyPublisher extensions</code></a></li>
<li><a href="https://github.com/lukacs-m/SwiftUICombineToolBox/blob/master/Sources/SwiftUICombineToolBox/Extensions/Combine/Just%2BExtensions.swift"><code>Just extensions</code></a></li>
</ul>
</details>


<details>
<summary>SwiftUI Extensions</summary>
</br>
<ul>
<li><a href="https://github.com/lukacs-m/SwiftUICombineToolBox/blob/master/Sources/SwiftUICombineToolBox/Extensions/SwiftUI/Views%2BExtensions.swift"><code>View extensions</code></a></li>
</ul>
</details>


<details>
<summary>UIElements</summary>
</br>
<ul>
<li><a href="https://github.com/lukacs-m/SwiftUICombineToolBox/blob/master/Sources/SwiftUICombineToolBox/UIElements/Components/LazyView.swift"><code>LazyView</code></a></li>
<li><a href="https://github.com/lukacs-m/SwiftUICombineToolBox/blob/master/Sources/SwiftUICombineToolBox/UIElements/SwiftUIPreviews/UIScenePreview.swift"><code>SwiftUIPreviews</code></a></li>
</ul>
</details>


<details>
<summary>Tools</summary>
</br>
<ul>
<li><a href="https://github.com/lukacs-m/SwiftUICombineToolBox/blob/master/Sources/SwiftUICombineToolBox/Tools/Services/ReachabilityService.swift"><code>ReachabilityService</code></a></li>
<li><a href="https://github.com/lukacs-m/SwiftUICombineToolBox/blob/master/Sources/SwiftUICombineToolBox/Tools/Utilities/CancelBag.swift"><code>CancelBag</code></a></li>
</ul>
</details>


## License

SwiftUICombineToolBox is released under the MIT license.
