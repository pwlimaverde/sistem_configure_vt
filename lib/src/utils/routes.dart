enum Routes {
  initial(caminho: "/"),
  home(caminho: "/home");

  final String caminho;
  const Routes({required this.caminho});
}
