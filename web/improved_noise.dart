part of infinite_mario_bros;

class ImprovedNoise {
  Random _random = new Random();
  List<int> _p = new List<int>(512);

  ImprovedNoise() {
    _shuffle();
  }

  _shuffle() {
    var permutation = new List<int>.generate(256, (index) => index);

    for (var i = 0; i < permutation.length; i++) {
      var j = _random.nextInt(256 - i) + i;
      var temporary = permutation[i];
      permutation[i] = permutation[j];
      permutation[j] = temporary;
      _p[i + 256] = _p[i] = permutation[i];
    }
  }

  perlinNoise(Point point) {
    var result = 0;

    for (var i = 0; i < 8; i++) {
      var stepSize = 64 / pow(2, i);
      result +=
          _noise(point.x / stepSize, point.y / stepSize, 128) * 1 / pow(2, i);
    }

    return result;
  }

  _noise(num x, num y, num z) {
    var nx = x.floor() & 0xff;
    var ny = y.floor() & 0xff;
    var nz = z.floor() & 0xff;
    x -= x.floor();
    y -= x.floor();
    z -= x.floor();
    var u = _fade(x);
    var v = _fade(y);
    var w = _fade(z);
    var a = _p[nx] + ny;
    var aa = _p[a] + nz;
    var ab = _p[a + 1] + nz;
    var b = _p[nx + 1] + ny;
    var ba = _p[b] + nz;
    var bb = _p[b + 1] + nz;

    return _lerp(w,
                 _lerp(v,
                       _lerp(u,
                             _grad(_p[aa], x, y, z),
                             _grad(_p[ba], x - 1, y, z)),
                       _lerp(u,
                             _grad(_p[ab], x, y - 1, z),
                             _grad(_p[bb], x - 1, y - 1, z))),
                 _lerp(v,
                       _lerp(u,
                             _grad(_p[aa + 1], x, y, z - 1),
                             _grad(_p[ba + 1], x - 1, y, z - 1)),
                       _lerp(u,
                             _grad(_p[ab + 1], x, y - 1, z - 1),
                             _grad(_p[bb + 1], x - 1, y - 1, z - 1))));
  }

  num _fade(num t) => pow(t, 3) * (t * (t * 6 - 15) + 10);

  num _lerp(num t, num a, num b) => a + t * (b - a);

  num _grad(int hash, num x, num y, num z) {
    int h = hash & 0xf;
    num u = h < 8 ? x : y;
    num v = h < 4 ? y : (h == 12 || h == 14 ? x : z);
    return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
  }
}