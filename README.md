# QtQuickUtils

A set of useful QML components based on **QtQuick Controls 2**

### Dependencies

 * **Qt** 5.15 or higher

### How to use

Include the `QtQuickUtils.pri` file in your qmake project:

```javascript
include(QtQuickUtils/QtQuickUtils.pri)
```
set Qt Quick style to `Material` in `main.cpp` of your app before loading qml engine:

```c++
QQuickStyle::setStyle("Material");
```

add qrc path to qml import pathes in your `main.cpp`:

```c++
QQmlApplicationEngine engine;
engine.addImportPath("qrc:///");
```

then you can include **QtQuickUtils** module in any qml file:

```qml
import QtQuickUtils 1.0
```

and define any of the components:

```qml
SwipeArea {
    onSwipeRight: {
        ...
    }
}
```

to enable using virtual keyboard, set the relevant environment variable before loading qml engine:

```c++
qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
```

and set this context property:

```c++
engine.rootContext()->setContextProperty(
        "HASVIRTUALKEYBOARD",
        QProcessEnvironment::systemEnvironment().value("QT_IM_MODULE") ==
            "qtvirtualkeyboard");
```

Check the provided example in the source code if you have any confusion.

In case you want to use individual components in your source code without using `ExtendedApplicationWindow` as the main type in `main.qml`, 
you should define a font loader for **FontAwesome** in your `main.qml` as it's the font for icons of components:

```qml
FontLoader {
        id: fontAwesome
        source: "qrc:/path/to/Font Awesome 6 Free-Solid-900.otf"
}
```

## Components

#### ExtendedApplicationWindow

Extends ApplicationWindow with the following features:

 * Dark and light themes with Roboto font and Font Awesome for icons
 * Login dialog, splash screen and about dialog
 * UI scaling
 * Virtual keyboard

#### ExtendedDialog

Extends Dialog and adds icon, close button, ability to move and common YES/NO/OK/CANCEL buttons in footer


#### AuthenticationDialog

A Dialog to ask username and password

#### AvatarControl

Control that shows user profile image or an abbreviation of user name and surname

#### BusyIndicator2

Another busyindicator with a different look

#### ColorPicker

A control to select color from predefined ones or custom color

#### DoubleSpinBox

A spinbox for double values with specified decimals

#### DurationPicker

Component to define and select time duration in hours, minutes and seconds

#### FlowComboBox, FlowSpinBox, FlowTextField

Combobox, Spinbox and Textfield respectively with titles flowing based on width

#### IconButton, IconRoundButton, IconTabButton

Button, RoundButton and TabButton with ability to define Font Awesome icon

#### IconMenu, IconMenuItem

Menu and MenuItem with a Font Awesome icon

#### ImagePreview

A dialog to preview images with ability to zoom and pan

#### LoginDialog

A login dialog with utiltiy components suitable for start of application

#### MessagePanel

An auto opening/closing panel to show appilcation messages with icons

#### MessagePopup

A popup to show a specific message or alarm to user

#### PasswordTextField

 Textfield suitable for passwords and option to view entered value

#### SplashScreen

An auto-hiding splashscreen window

#### SwipeArea

A MouseArea that detects swipe left/right/up/down gestures

#### VirtualKeyboard

 A component that defines and handles a virtual keyboard for application
