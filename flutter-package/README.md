<p align="center">
  <img   height="120px" src="https://github.com/jamesblasco/flutter_preview/blob/master/screenshots/flutter_preview.jpg?raw=true" />
</p>


<p align="center">
  <br/>
          Create samples of you widgets and preview them in real time
    <br/>
    <br/>
  <img   width="640px" src="https://github.com/jamesblasco/flutter_preview/blob/master/screenshots/flutter_preview_header.png?raw=true" />

</p>

 

## Getting Started

### Install

  - Install the vscode Flutter Preview extension. [Instructions here](https://marketplace.visualstudio.com/items?itemName=jamesblasco.flutter-preview)
  - Add the `preview package` to your flutter project. [Instructions here](https://pub.dev/packages/preview#-installing-tab-)

### Run the preview

  <img align="right"  height="200px" src="https://github.com/jamesblasco/flutter_preview/blob/master/screenshots/preview_button.jpg?raw=true" />

  - Open a dart file in vscode and the preview button will appear
  
  - Click the button to launch Flutter Preview
  
### Adding a preview

  A vscode snippet is availabe for creating a preview, just type `preview` and it will appear.
  
  - Create a new class that extends `PreviewProvider`
  
  ```dart
  
  class MyPreview extends PreviewProvider {
  
    List<Preview> get previews {
      return [
        
      ];
    }
  }
  ```
  
  - Add as many Preview widgets as samples you want to display 
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
  
  And and the examples will appear in the preview window as soon as you save your file.
  
  They will appear there every time you come back to that file.
  
## Taking the most of Flutter Preview
  
###  Preview Widget

The `Preview` widget allows you to give default values that will impact your widget inside. The current availabe values are:
- theme: Add your app theme to see your widget with your styles.
- height, width: Set the size you want to set to the widget in case the widget has not size specified.
- frame: See widget in different device scenarios: an android phone? or maybe an apple watch? More than 20 models and you can create your own
  (This is done thanks to the amazing package [device_frame](https://pub.dev/packages/device_frame) built by Aloïs Deniel
- Need more? We are working to add more in a close future: Locale, Brightness, constraints...

Also you can set a update mode for each preview from hot-reload to hot-restart;

###  PreviewProvider


You can use multiple classes that extend `PreviewProvider` and they will be displayed in different tabs.

By default the name of the tab will be the class name but you can override the `title` param to customize it.

### Custom Providers

PreviewProvider allows you to group different `Previews` in a single file. While this can be enough for most, you might want to create your own previews.
For that you can extend any widget that extends `StatelessWidget` and make it implement the mixin `Previewer`;

```dart
class MyCustomPreview extends StatelessWidget with Previewer {
 @override
 Widget build(BuildContext context) {
    return Container();
  }
}
```

It is important to add `with Previewer` always when extending any class, otherwise it won't be recognized by Flutter Preview.

A already built-in custom provider is `ResizablePreviewProvider` that gives you the freedom to resize a widget to see how it could look in different scenarios.

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

You can build any other previews or use any packages if you respect this two important rules
  - All preview providers except the default one needs to have `with Previewer`
  - They need to have an empty constructor without any params.
  
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

<td> <img align="right"  height="300" width="383" src="https://github.com/jamesblasco/flutter_preview/blob/master/screenshots/custom_preview.png?raw=true" />  </td>
</tr>

</table>


###  Something is not working as expected?

Create a [new issue](https://github.com/jamesblasco/flutter_preview/issues/new) and I will take it a look


  
