
Simple LAS input stream reader for well log analysis

## Features

* LAS reading based on stream of strings (lines);


## Getting started

Add the package to your project and use it.

## Usage

```dart
    final reader = LASReader();
    final file = File('my-file.las');
    final lasData$ = reader.readFile(file);
    lasData$.then( (lasdata) {
       final depthCurve = lasData.getCurve('DEPTH');  
       final depths = depthCurve.values;
       depths.forEach( (d) => /* do something */ );
    });
```


