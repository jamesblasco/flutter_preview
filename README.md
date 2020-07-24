<p align="center">
  <img   height="120px" src="https://github.com/jamesblasco/Flutter_preview/blob/master/screenshots/Flutter_preview.jpg?raw=true" />
</p>


<p align="center">
  <br/>
          Create samples of your widgets and preview them in real time
    <br/>
    <br/>
  <img   width="640px" src="https://github.com/jamesblasco/Flutter_preview/blob/master/screenshots/Flutter_preview_header.png?raw=true" />

</p>

This project is experimental but safe to use as no code is added during compilation.
It won't be stable until Flutter web or desktop reaches a stable version too.


## Getting Started

### Installation

  - Install the VS Code Flutter Preview extension. [Instructions here](https://marketplace.visualstudio.com/items?itemName=jamesblasco.Flutter-preview)
  - Add the `preview` package to your Flutter project. [Instructions here](https://pub.dev/packages/preview#-installing-tab-)

### Run the Preview

  <img align="right"  height="200px" src="https://github.com/jamesblasco/Flutter_preview/blob/master/screenshots/preview_button.jpg?raw=true" />

  - Open a dart file in VS Code and the preview button will appear
  
  - Click the button to launch Flutter Preview
  
  - If a device is not active yet, it will ask you to select the device where you want to run Flutter Preview.
    Read more about [how to choose a device](https://github.com/jamesblasco/Flutter_preview/issues/7) to run Flutter Preview.
      
     
     <img align="right"  height="100px" src="https://github.com/jamesblasco/Flutter_preview/blob/master/screenshots/macOS_helper.png?raw=true" />
         
   > **Using macOS?** 
   > We use the local network layer to communicate between the preview and the daemon service. macOS limits all network requests by default and so you will need to allow it during debug by adding:
   > <key>com.apple.security.network.client</key> <true/>
   > to macOS/Runner/DebugProfile.entitlements
   

   
### Adding a preview

  A VS Code snippet is available for creating a preview, just type `preview` and it will appear.
  
  - Create a new class that extends PreviewProvider
  
  ```dart
  
  class MyPreview extends PreviewProvider {
  
    List<Preview> get previews {
      return [
        
      ];
    }
  }
  ```
  
  - Add as many Preview widgets as samples that you want to display 
  ```dart
    List<Preview> get previews {
      return [
        Preview(
          frame: Frames.ipadPro12,
          child: MyApp(),
        ),
        Preview(
          frame: Frames.iphoneX,
          child: MyApp(),
        ),
      ];
    }
  
  ```
  
The examples will appear in the preview window as soon as you save your file.
  
  They will appear there every time you come back to that file.
  
## Taking the most of Flutter Preview
  
###  Preview Widget

The `Preview` widget allows you to give default values that will impact your widget inside. The currently available values are:
- theme: Add your app theme to see your widget with your styles.
- height, width: Set the size you want to set to the widget in case the widget's size has not been specified.
- frame: See your widget in different device scenarios: Want to see it on an Android phone? How about an Apple Watch? There are more than 20 device models and you can create your own!
  (This is done thanks to the amazing package [device_frame](https://pub.dev/packages/device_frame) built by Aloïs Deniel
- Need more? We are working to add more in a close future: Locale, Brightness, constraints...

You can also set an update mode for each preview from hot-reload to hot-restart;

###  PreviewProvider


You can use multiple classes that extend `PreviewProvider` and they will be displayed in different tabs.

By default, the name of the tab will be the class name but you can override the `title` param to customize it.

### Custom Providers

PreviewProvider allows you to group different `Previews` in a single file. While this can be enough for most, you might want to create your own previews.
For that you can extend any widget that extends `StatelessWidget` and make it implement the `Previewer` mixin;

```dart
class MyCustomPreview extends StatelessWidget with Previewer {
 @override
 Widget build(BuildContext context) {
    return Container();
  }
}
```

It is important to always add `with Previewer` when extending any class, otherwise, it won't be recognized by Flutter Preview.

`ResizablePreviewProvider` is an already built-in custom provider that gives you the freedom to resize a widget to see how it will look in different scenarios.

```dart
class Resizable extends ResizablePreviewProvider with Previewer {
  @override
  Preview get preview {
    return Preview(
      mode: UpdateMode.hotReload,
      child: MusicCard(
        title: 'Blond',
        singer: 'Frank Ocean',
        image: PreviewImage.asset('preview_assets/cover1.jpg'),
        onTap: () => {},
      ),
    );
  }
}
```

You can build any other previews or use any packages if you respect these two important rules
  - All preview providers except the default one need to have `with Previewer`
  - They need to have an empty constructor without any parameters.
  
Let's see a cool example using the [device_preview](https://pub.dev/packages/device_preview) package  
<table>

<tr>
<td>

```dart
class DevicePreviewProvider extends StatelessWidget with Previewer {
  @override
  String get title => 'Device Preview';

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      builder: (context) => MyApp(),
    );
  }
}
```


</td>

<td> <img align="right"  height="300" width="383" src="https://github.com/jamesblasco/Flutter_preview/blob/master/screenshots/custom_preview.png?raw=true" />  </td>
</tr>

</table>


###  Using sample assets

Adding sample assets to your Flutter app can needlessly increase the app size. 

For images, you can continue to use NetworkImage, but if you want to use local images, don't add them to your Flutter project! 

You can use PreviewImage instead.

```dart
// DON'T
AssetImage('images/example.png')

// DO
PreviewImage('debug_images/example.png')
```

<pre><code># pubspec.yaml

assets:
  <s>images/dart.png</s>

</code></pre>

Other assets will be supported soon.

##  Something is not working as expected?

Create a [new issue](https://github.com/jamesblasco/Flutter_preview/issues/new) and I will take it a look.


  
