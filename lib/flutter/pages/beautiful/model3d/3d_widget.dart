library flutter_3d_obj;

import 'dart:io';
import 'dart:math' as Math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutterdemo/dart/version_2x/TypeDemo.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';
import 'package:meta/meta.dart';
import 'package:vector_math/vector_math.dart' show Vector3;
import 'package:vector_math/vector_math.dart' as V;

//https://blog.csdn.net/m0_37667770/article/details/81042916#comments
class Model3DPage extends StatefulWidget {
  @override
  _Model3DPageState createState() => _Model3DPageState();
}

class _Model3DPageState extends State<Model3DPage> {
  var array = [MyImgs.BBMODEL, MyImgs.NVPOSEMODEL];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Model3DPage"),
        actions: <Widget>[
          RaisedButton(
            onPressed: () {
              setState(() {
                index += 1;
                if (index > array.length) {
                  index = 0;
                }
              });
            },
            child: Text("加载下一个模型"),
          )
        ],
      ),
      body: Widght_3D(
        asset: true,
        path: array[index],
        size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
        zoom: 20.0,
      ),
    );
  }
}

//1.0开始创建小部件
class Widght_3D extends StatefulWidget {
  Widght_3D(
      {required this.size,
      required this.path,
      required this.asset,
      this.angleX,
      this.angleY,
      this.angleZ,
      this.zoom = 100.0}) {
    if (angleX != null || angleY != null || angleZ != null) {
      angleValue = false;
    }
  }

  Size size;
  bool asset;
  String path;
  double zoom;
  double? angleX;
  double? angleY;
  double? angleZ;
  bool angleValue = true;

  @override
  _Widght_3DState createState() => new _Widght_3DState();
}

class _Widght_3DState extends State<Widght_3D> {
  //TODO  //2.0加载资源
  _Widght_3DState();

  double angleX = 15.0;
  double angleY = 45.0;
  double angleZ = 0.0;

  double _previousX = 0.0;
  double _previousY = 0.0;

  double? zoom;
  String object = "V 1 1 1 1";

  File? file;
  @override
  void initState() {
    super.initState();
    print("path ${widget.path}   =================");
    if (widget.asset) {
      rootBundle.loadString(widget.path).then((String value) {
        setState(() {
          object = value;
        });
      });
    } else {
      File file = new File(widget.path);
      file.readAsString().then((String value) {
        setState(() {
          object = value;
        });
      });
    }
  }

  void _updateCube(DragUpdateDetails data) {
    if (angleY > 360.0) {
      angleY = angleY - 360.0;
    }
    if (_previousY > data.globalPosition.dx) {
      setState(() {
        angleY = angleY - 1;
      });
    }
    if (_previousY < data.globalPosition.dx) {
      setState(() {
        angleY = angleY + 1;
      });
    }
    _previousY = data.globalPosition.dx;

    if (angleX > 360.0) {
      angleX = angleX - 360.0;
    }
    if (_previousX > data.globalPosition.dy) {
      setState(() {
        angleX = angleX - 1;
      });
    }
    if (_previousX < data.globalPosition.dy) {
      setState(() {
        angleX = angleX + 1;
      });
    }
    _previousX = data.globalPosition.dy;
  }

  void _updateY(DragUpdateDetails data) {
    _updateCube(data);
  }

  void _updateX(DragUpdateDetails data) {
    _updateCube(data);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      //TODO 3.0这里手势来监听拖缀的方向，目前这里只在水平和数值方向做了处理。所以可以左右和上下在二维界面里面拖动图片。
      child: new CustomPaint(
        //TODO 4.0 一个小部件，提供在绘制阶段绘制的画布。
        painter: new _ObjectPainter(widget.size, object, widget.angleValue ? angleX : widget.angleX,
            widget.angleValue ? angleY : widget.angleY, widget.angleValue ? angleZ : widget.angleZ, widget.zoom),
        size: widget.size,
        isComplex: true,
      ),
      onHorizontalDragUpdate: _updateY, //TODO 4.0这里进行监听水平拖缀并更新
      onVerticalDragUpdate: _updateX, //TODO 5.0这里进行监听数值拖缀
    );
  }
}

class _ObjectPainter extends CustomPainter {
  double _zoomFactor = 100.0;

  final double _rotation = 5.0; // in degrees
  double _translation = 0.1 / 100;
  final double _scalingFactor = 10.0 / 100.0; // in percent

  final double ZERO = 0.0;

  final String object;

  double _viewPortX = 0.0, _viewPortY = 0.0;

  List<Vector3>? vertices;
  List<dynamic>? faces;
  late V.Matrix4 T;
  late Vector3 camera;
  late Vector3 light;

  double? angleX;
  double? angleY;
  double? angleZ;

  late Color color;

  Size size;

  _ObjectPainter(this.size, this.object, this.angleX, this.angleY, this.angleZ, this._zoomFactor) {
    _translation *= _zoomFactor;
    camera = new Vector3(0.0, 0.0, 0.0);
    light = new Vector3(0.0, 0.0, 100.0);
    color = new Color.fromARGB(255, 255, 255, 255);
    _viewPortX = (size.width / 2).toDouble();
    _viewPortY = (size.height / 2).toDouble();
  }

  Map<String, List> _parseObjString(String objString) {
    List vertices = <Vector3>[];
    List faces = <List<int>>[];
    List<int> face = [];

    List lines = objString.split("\n");

    Vector3 vertex;

    lines.forEach((line) {
      //在行尾，句点后跟着额外的空格
      line = line.replaceAll(new RegExp(r"\s+$"), "");
      List<String> chars = line.split(" ");
      // vertex
      if (chars[0] == "v") {
        print("chars[1] ${chars[1]} chars[2] ${chars[2]} chars[3] ${chars[3]}");
        if (chars[1] == " " || chars[1] == "" || chars[1] == null) {
          vertex = new Vector3(double.parse(chars[2]), double.parse(chars[3]), double.parse(chars[4]));
        } else {
          vertex = new Vector3(double.parse(chars[1]), double.parse(chars[2]), double.parse(chars[3]));
        }

        vertices.add(vertex);

        // face
      } else if (chars[0] == "f") {
        for (var i = 1; i < chars.length; i++) {
          face.add(int.parse(chars[i].split("/")[0]));
        }

        faces.add(face);
        face = [];
      }
    });

    return {'vertices': vertices, 'faces': faces};
  }

  bool _shouldDrawFace(List face) {
    var normalVector = _normalVector3(vertices![face[0] - 1], vertices![face[1] - 1], vertices![face[2] - 1]);

    var dotProduct = normalVector.dot(camera);
    double vectorLengths = normalVector.length * camera.length;

    double angleBetween = dotProduct / vectorLengths;

    return angleBetween < 0;
  }

  Vector3 _normalVector3(Vector3 first, Vector3 second, Vector3 third) {
    Vector3 secondFirst = new Vector3.copy(second);
    secondFirst.sub(first);
    Vector3 secondThird = new Vector3.copy(second);
    secondThird.sub(third);

    return new Vector3(
        (secondFirst.y * secondThird.z) - (secondFirst.z * secondThird.y),
        (secondFirst.z * secondThird.x) - (secondFirst.x * secondThird.z),
        (secondFirst.x * secondThird.y) - (secondFirst.y * secondThird.x));
  }

  double _scalarMultiplication(Vector3 first, Vector3 second) {
    return (first.x * second.x) + (first.y * second.y) + (first.z * second.z);
  }

  Vector3 _calcDefaultVertex(Vector3 vertex) {
    T = new V.Matrix4.translationValues(_viewPortX, _viewPortY, ZERO);
    T.scale(_zoomFactor, -_zoomFactor);

    T.rotateX(_degreeToRadian(angleX != null ? angleX! : 0.0));
    T.rotateY(_degreeToRadian(angleY != null ? angleY! : 0.0));
    T.rotateZ(_degreeToRadian(angleZ != null ? angleZ! : 0.0));

    return T.transform3(vertex);
  }

  double _degreeToRadian(double degree) {
    return degree * (Math.pi / 180.0);
  }

  List<dynamic> _drawFace(List<Vector3> verticesToDraw, List face) {
    List<dynamic> list = <dynamic>[];
    Paint paint = new Paint();
    Vector3 normalizedLight = new Vector3.copy(light).normalized();

    var normalVector =
        _normalVector3(verticesToDraw[face[0] - 1], verticesToDraw[face[1] - 1], verticesToDraw[face[2] - 1]);

    Vector3 jnv = new Vector3.copy(normalVector).normalized();

    double koef = _scalarMultiplication(jnv, normalizedLight);

    if (koef < 0.0) {
      koef = 0.0;
    }

    Color newColor = new Color.fromARGB(255, 0, 0, 0);

    Path path = new Path();

    newColor = newColor.withRed((color.red.toDouble() * koef).round());
    newColor = newColor.withGreen((color.green.toDouble() * koef).round());
    newColor = newColor.withBlue((color.blue.toDouble() * koef).round());
    paint.color = newColor;
    paint.style = PaintingStyle.fill;

    bool lastPoint = false;
    double firstVertexX, firstVertexY, secondVertexX, secondVertexY;

    for (int i = 0; i < face.length; i++) {
      if (i + 1 == face.length) {
        lastPoint = true;
      }

      if (lastPoint) {
        firstVertexX = verticesToDraw[face[i] - 1][0].toDouble();
        firstVertexY = verticesToDraw[face[i] - 1][1].toDouble();
        secondVertexX = verticesToDraw[face[0] - 1][0].toDouble();
        secondVertexY = verticesToDraw[face[0] - 1][1].toDouble();
      } else {
        firstVertexX = verticesToDraw[face[i] - 1][0].toDouble();
        firstVertexY = verticesToDraw[face[i] - 1][1].toDouble();
        secondVertexX = verticesToDraw[face[i + 1] - 1][0].toDouble();
        secondVertexY = verticesToDraw[face[i + 1] - 1][1].toDouble();
      }

      if (i == 0) {
        path.moveTo(firstVertexX, firstVertexY);
      }

      path.lineTo(secondVertexX, secondVertexY);
    }
    var z = 0.0;
    face.forEach((x) {
      z += verticesToDraw[x - 1].z;
    });

    path.close();
    list.add(path);
    list.add(paint);
    return list;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //TODO 绘画到画布上面

    Map parsedFile = _parseObjString(object);
    vertices = parsedFile["vertices"];
    faces = parsedFile["faces"];

    List<Vector3> verticesToDraw = [];
    vertices!.forEach((vertex) {
      verticesToDraw.add(new Vector3.copy(vertex));
    });

    for (int i = 0; i < verticesToDraw.length; i++) {
      verticesToDraw[i] = _calcDefaultVertex(verticesToDraw[i]);
    }

    final List avgOfZ = <Map>[];
    for (int i = 0; i < faces!.length; i++) {
      List face = faces![i];
      double z = 0.0;
      face.forEach((x) {
        z += verticesToDraw[x - 1].z;
      });
      Map data = <String, dynamic>{
        "index": i,
        "z": z,
      };
      avgOfZ.add(data);
    }
    avgOfZ.sort((var a, var b) => a['z'].compareTo(b['z']));

    for (int i = 0; i < faces!.length; i++) {
      List face = faces![avgOfZ[i]["index"]];
      if (_shouldDrawFace(face) || true) {
        final List<dynamic> faceProp = _drawFace(verticesToDraw, face);
        canvas.drawPath(faceProp[0], faceProp[1]);
      }
    }
  }

  @override
  bool shouldRepaint(_ObjectPainter old) =>
      old.object != object ||
      old.angleX != angleX ||
      old.angleY != angleY ||
      old.angleZ != angleZ ||
      old._zoomFactor != _zoomFactor;
}
