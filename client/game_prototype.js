var Canvas, Color, Util, abs, cos, include, sin, sqrt;

Array.prototype.remove = function(obj) {
  return this.splice(this.indexOf(obj), 1);
};

Array.prototype.size = function() {
  return this.length;
};

Array.prototype.first = function() {
  return this[0];
};

Array.prototype.last = function() {
  return this[this.length - 1];
};

Array.prototype.each = Array.prototype.forEach;

cos = Math.cos, sin = Math.sin, sqrt = Math.sqrt, abs = Math.abs;

Color = {
  Red: "rgb(255,0,0)",
  Blue: "rgb(0,0,255)",
  Green: "rgb(0,255,0)",
  White: "rgb(255,255,255)",
  Black: "rgb(0,0,0)",
  i: function(r, g, b) {
    return "rgb(" + r + "," + g + "," + b + ")";
  }
};

Canvas = CanvasRenderingContext2D;

Canvas.prototype.init = function(color, alpha) {
  if (color == null) color = Color.i(255, 255, 255);
  if (alpha == null) alpha = 1;
  this.beginPath();
  this.strokeStyle = color;
  this.fillStyle = color;
  return this.globalAlpha = alpha;
};

Canvas.prototype.initText = function(size, font) {
  if (size == null) size = 10;
  if (font == null) font = 'Arial';
  return this.font = "" + size + "pt " + font;
};

Canvas.prototype.drawLine = function(x, y, dx, dy) {
  this.moveTo(x, y);
  this.lineTo(x + dx, y + dy);
  return this.stroke();
};

Canvas.prototype.drawPath = function(fill, path) {
  var px, py, sx, sy, _ref, _ref2;
  _ref = path.shift(), sx = _ref[0], sy = _ref[1];
  this.moveTo(sx, sy);
  while (path.size() > 0) {
    _ref2 = path.shift(), px = _ref2[0], py = _ref2[1];
    this.lineTo(px, py);
  }
  this.lineTo(sx, sy);
  if (fill) {
    return this.fill();
  } else {
    return this.stroke();
  }
};

Canvas.prototype.drawDiffPath = function(fill, path) {
  var dx, dy, px, py, sx, sy, _ref, _ref2, _ref3, _ref4;
  _ref = path.shift(), sx = _ref[0], sy = _ref[1];
  this.moveTo(sx, sy);
  _ref2 = [sx, sy], px = _ref2[0], py = _ref2[1];
  while (path.size() > 0) {
    _ref3 = path.shift(), dx = _ref3[0], dy = _ref3[1];
    _ref4 = [px + dx, py + dy], px = _ref4[0], py = _ref4[1];
    this.lineTo(px, py);
  }
  this.lineTo(sx, sy);
  if (fill) {
    return this.fill();
  } else {
    return this.stroke();
  }
};

Canvas.prototype.drawLine = function(x, y, dx, dy) {
  this.moveTo(x, y);
  this.lineTo(x + dx, y + dy);
  return this.stroke();
};

Canvas.prototype.drawDLine = function(x1, y1, x2, y2) {
  this.moveTo(x1, y1);
  this.lineTo(x2, y2);
  return this.stroke();
};

Canvas.prototype.drawArc = function(fill, x, y, size, from, to, reverse) {
  if (from == null) from = 0;
  if (to == null) to = Math.PI * 2;
  if (reverse == null) reverse = false;
  this.arc(x, y, size, from, to, reverse);
  if (fill) {
    return this.fill();
  } else {
    return this.stroke();
  }
};

Util = {};

Util.prototype = {
  extend: function(obj, mixin) {
    var method, name;
    for (name in mixin) {
      method = mixin[name];
      obj[name] = method;
    }
    return obj;
  },
  include: function(klass, mixin) {
    return Util.prototype.extend(klass.prototype, mixin);
  },
  dup: function(obj) {
    var f;
    f = function() {};
    f.prototype = obj;
    return new f;
  }
};

include = Util.prototype.include;
