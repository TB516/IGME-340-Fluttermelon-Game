enum LangBallTypes {
  assembly(file: "Assembly.png", diameter: 25, mass: 10),
  cpp(file: "C++.png", diameter: 40, mass: 25),
  rust(file: "Rust.png", diameter: 55, mass: 40),
  go(file: "Go.png", diameter: 70, mass: 55),
  csharp(file: "C#.png", diameter: 85, mass: 75),
  javascript(file: "Javascript.png", diameter: 100, mass: 90),
  flutter(file: "Flutter.png", diameter: 115, mass: 120);

  final String file;
  final double diameter;
  final double mass;

  const LangBallTypes(
      {required this.file, required this.diameter, required this.mass});
}
