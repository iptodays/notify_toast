# notify_toast

## Use it

### Depend on it

```yaml
dependencies:
  notify_toast: 0.0.3
```

### Import it

```dart
import 'package:notify_toast/notify_toast.dart';
```

## Example

```dart
NotifyToast().show(
  context,
  bgColor: Colors.green.withOpacity(0.6),
  progressColor: Colors.blueGrey,
  progressHeight: 4,
  child: Container(
    padding: EdgeInsets.only(
    top: MediaQuery.of(context).padding.top + 16,
    bottom: 24,
  ),
    child: Row(
      children: [
        const Expanded(
          child: Text(
            'NotifyToast',
          ),
        ),
        IconButton(
          onPressed: () {
            NotifyToast().hide();
          },
          icon: const Icon(
            Icons.close_rounded,
          ),
        ),
      ],
    ),
  ),
);
```