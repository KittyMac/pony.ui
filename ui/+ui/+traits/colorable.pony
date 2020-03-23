
trait Colorable
  var _color:RGBA val = RGBA.white()
  
  be color(rgba:RGBA) => _color = rgba
  
  be clear() => _color = RGBA.clear()
  be white() => _color = RGBA.white()
  be black() => _color = RGBA.black()
  be gray() => _color = RGBA.gray()
  be red() => _color = RGBA.red()
  be green() => _color = RGBA.green()
  be blue() => _color = RGBA.blue()
  be yellow() => _color = RGBA.yellow()
  be magenta() => _color = RGBA.magenta()
  be cyan() => _color = RGBA.cyan()
