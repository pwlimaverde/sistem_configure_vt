enum Routes {
  initial(caminho: "/"),
  auth(caminho: "/auth");

  final String caminho;
  const Routes({required this.caminho});
}
