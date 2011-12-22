var Canvas, CanvasSprite, CharSprite, Color, GameRenderer, GroundSprite, ImageSprite, MonsterSprite, PlayerSprite, Sprite, TileSprite, Util, abs, cos, include, sin, sqrt,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

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

Sprite = (function() {

  function Sprite(x, y, scale) {
    this.x = x != null ? x : 0;
    this.y = y != null ? y : 0;
    this.scale = scale != null ? scale : 10;
  }

  Sprite.prototype.render = function(g) {
    g.beginPath();
    g.arc(this.x, this.y, 15, 0, Math.PI * 2, true);
    return g.stroke();
  };

  Sprite.prototype.get_distance = function(target) {
    var xd, yd;
    xd = Math.pow(this.x - target.x, 2);
    yd = Math.pow(this.y - target.y, 2);
    return Math.sqrt(xd + yd);
  };

  Sprite.prototype.find_obj = function(group_id, targets, range) {
    var _this = this;
    return targets.filter(function(t) {
      return t.group === group_id && _this.get_distance(t) < range;
    });
  };

  return Sprite;

})();

ImageSprite = (function() {

  function ImageSprite(src, size) {
    this.size = size;
    this.img = new Image;
    this.img.src = src;
  }

  ImageSprite.prototype.draw = function(context) {
    return context.g.drawImage(this.img, x, y);
  };

  return ImageSprite;

})();

CanvasSprite = (function() {

  function CanvasSprite(size) {
    var buffer;
    this.size = size != null ? size : 32;
    buffer = document.createElement('canvas');
    buffer.width = buffer.height = this.size;
    this.shape(buffer.getContext('2d'));
    this.img = new Image;
    this.img.src = buffer.toDataURL();
  }

  CanvasSprite.prototype.p2ism = function(x, y) {
    return [(x + y) / 2, (x - y) / 4];
  };

  CanvasSprite.prototype.draw = function(context, x, y) {
    var dx, dy;
    dx = dy = ~~(context.scale / 2);
    return context.g.drawImage(this.img, x - dx, y - dy);
  };

  return CanvasSprite;

})();

CharSprite = (function(_super) {

  __extends(CharSprite, _super);

  function CharSprite() {
    CharSprite.__super__.constructor.apply(this, arguments);
  }

  CharSprite.prototype.shape = function(g) {
    var cx, cy, xx, yy, _i, _len, _ref, _ref2;
    cx = cy = 16;
    g.init(Color.i(64, 255, 64));
    g.arc(cx, cy - 7, 3, 0, 2 * Math.PI);
    g.fill();
    g.beginPath();
    g.moveTo(cx, cy);
    _ref = [[cx - 4, cy - 3], [cx + 4, cy - 3]];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      _ref2 = _ref[_i], xx = _ref2[0], yy = _ref2[1];
      g.lineTo(xx, yy);
    }
    g.lineTo(cx, cy);
    return g.fill();
  };

  return CharSprite;

})(CanvasSprite);

PlayerSprite = (function(_super) {

  __extends(PlayerSprite, _super);

  function PlayerSprite() {
    PlayerSprite.__super__.constructor.apply(this, arguments);
  }

  PlayerSprite.prototype.shape = function(g) {
    var cx, cy, xx, yy, _i, _len, _ref, _ref2;
    cx = cy = 16;
    g.init(Color.i(64, 64, 255));
    g.arc(cx, cy - 7, 3, 0, 2 * Math.PI);
    g.fill();
    g.beginPath();
    g.moveTo(cx, cy);
    _ref = [[cx - 4, cy - 3], [cx + 4, cy - 3]];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      _ref2 = _ref[_i], xx = _ref2[0], yy = _ref2[1];
      g.lineTo(xx, yy);
    }
    g.lineTo(cx, cy);
    return g.fill();
  };

  return PlayerSprite;

})(CanvasSprite);

MonsterSprite = (function(_super) {

  __extends(MonsterSprite, _super);

  function MonsterSprite() {
    MonsterSprite.__super__.constructor.apply(this, arguments);
  }

  MonsterSprite.prototype.shape = function(g, color) {
    var cx, cy, xx, yy, _i, _len, _ref, _ref2;
    cx = cy = 16;
    g.init(color || Color.i(255, 64, 64));
    g.arc(cx, cy - 7, 3, 0, 2 * Math.PI);
    g.fill();
    g.beginPath();
    g.moveTo(cx, cy);
    _ref = [[cx - 4, cy - 3], [cx + 4, cy - 3]];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      _ref2 = _ref[_i], xx = _ref2[0], yy = _ref2[1];
      g.lineTo(xx, yy);
    }
    g.lineTo(cx, cy);
    return g.fill();
  };

  return MonsterSprite;

})(CanvasSprite);

TileSprite = (function(_super) {

  __extends(TileSprite, _super);

  function TileSprite() {
    TileSprite.__super__.constructor.apply(this, arguments);
  }

  TileSprite.prototype.shape = function(g) {
    var x, y, _i, _len, _ref, _ref2;
    g.init(Color.Black);
    g.moveTo(0, 32);
    _ref = [[16, 24], [32, 16], [16, 8]];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      _ref2 = _ref[_i], x = _ref2[0], y = _ref2[1];
      g.lineTo(x, y);
    }
    g.lineTo(0, 16);
    return g.fill();
  };

  TileSprite.prototype.draw = function(g, x, y) {
    return g.drawImage(this.img, x, y);
  };

  return TileSprite;

})(CanvasSprite);

GroundSprite = (function(_super) {

  __extends(GroundSprite, _super);

  function GroundSprite(map, scale) {
    var gr, x, y, _ref;
    this.map = map;
    this.scale = scale != null ? scale : 32;
    this.i_scale = 18;
    this.ip = [500, 2000];
    _ref = [this.map.length, this.map[0].length], x = _ref[0], y = _ref[1];
    gr = document.createElement('canvas');
    gr.width = this.scale * x * 2 + this.ip[0];
    gr.height = this.scale * y + this.ip[1];
    this.gr = gr;
    this.shape(gr.getContext('2d'));
    this.ground = new Image;
    this.ground.src = gr.toDataURL('image/gif');
  }

  GroundSprite.prototype.p2ism = function(x, y) {
    var ix, iy, _ref;
    _ref = this.ip, ix = _ref[0], iy = _ref[1];
    return [(x + y) / 2 + ix, (x - y) / 4 + iy];
  };

  GroundSprite.prototype.shape = function(g, u) {
    var i, j, vx, vy, x, y, _j, _ref, _results;
    _results = [];
    for (i = 0, _ref = this.map.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
      _results.push((function() {
        var _i, _len, _ref2, _ref3, _ref4, _ref5, _results2;
        _results2 = [];
        for (_j = 0, _ref2 = this.map[i].length; 0 <= _ref2 ? _j < _ref2 : _j > _ref2; 0 <= _ref2 ? _j++ : _j--) {
          j = this.map[i].length - _j - 1;
          _ref3 = this.p2ism(i * this.i_scale, j * this.i_scale), vx = _ref3[0], vy = _ref3[1];
          if (!this.map[i][j]) {
            g.init(Color.i(128, 128, 128));
            g.moveTo(vx, vy);
            _ref4 = [[vx + this.i_scale / 2, vy + this.i_scale / 4], [vx + this.i_scale, vy], [vx + this.i_scale / 2, vy - this.i_scale / 4]];
            for (_i = 0, _len = _ref4.length; _i < _len; _i++) {
              _ref5 = _ref4[_i], x = _ref5[0], y = _ref5[1];
              g.lineTo(x, y);
            }
            g.lineTo(vx, vy);
            _results2.push(g.fill());
          } else {

          }
        }
        return _results2;
      }).call(this));
    }
    return _results;
  };

  GroundSprite.prototype.draw = function(context, cx, cy) {
    var fx, fy, internal_x, internal_y, ix, iy, size_x, size_y, _ref;
    _ref = this.ip, ix = _ref[0], iy = _ref[1];
    size_x = context.scale * context.x;
    size_y = context.scale * context.y;
    internal_x = this.i_scale * context.x;
    internal_y = this.i_scale * context.y;
    fx = (cx - size_x / 2) * this.i_scale / context.scale;
    fy = (cy - size_y / 2) * this.i_scale / context.scale;
    try {
      return context.g.drawImage(this.ground, fx + ix, fy + iy, internal_x, internal_y, 0, 0, size_x, size_y);
    } catch (e) {
      console.log('from', fx + ix, fy + iy);
      console.log('to', fx + ix + internal_x, fy + iy + internal_y);
      return console.log('size', this.gr.width, this.gr.height);
    }
  };

  return GroundSprite;

})(CanvasSprite);

GameRenderer = (function() {

  GameRenderer.prototype.getkey = function(keyCode) {
    switch (keyCode) {
      case 68:
      case 39:
        return 'right';
      case 65:
      case 37:
        return 'left';
      case 87:
      case 38:
        return 'up';
      case 83:
      case 40:
        return 'down';
      case 32:
        return 'space';
      case 17:
        return 'ctrl';
      case 48:
        return '0';
      case 49:
        return '1';
      case 50:
        return '2';
      case 51:
        return '3';
      case 52:
        return '4';
      case 53:
        return '5';
      case 54:
        return '6';
      case 55:
        return '7';
      case 56:
        return '8';
      case 57:
        return '9';
    }
    return String.fromCharCode(keyCode).toLowerCase();
  };

  function GameRenderer(x, y, scale) {
    var config,
      _this = this;
    this.x = x;
    this.y = y;
    this.scale = scale;
    this.uid = null;
    this.cam = [0, 0];
    this._camn = [0, 0];
    this.mouse = [0, 0];
    this.canvas = document.getElementById("game");
    this.g = this.canvas.getContext('2d');
    this.canvas.width = this.x * this.scale;
    this.canvas.height = this.y * this.scale;
    this.player_sp = new PlayerSprite(this.scale);
    this.char_sp = new CharSprite(this.scale);
    this.monster_sp = new MonsterSprite(this.scale);
    this.tile_sp = new TileSprite(this.scale);
    window.onkeydown = function(e) {
      var key;
      console.log(e.keyCode);
      e.preventDefault();
      key = _this.getkey(e.keyCode);
      return socket.emit("keydown", {
        code: key
      });
    };
    window.onkeyup = function(e) {
      var key;
      e.preventDefault();
      key = _this.getkey(e.keyCode);
      if (key === 'c') {
        return $('#config').click();
      } else {
        return socket.emit("keyup", {
          code: key
        });
      }
    };
    this.canvas.onmousedown = function(e) {
      var cx, cy, dx, dy, rx, ry, _ref, _ref2, _ref3;
      _ref = [e.offsetX - _this.scale * _this.x / 2, e.offsetY - _this.scale * _this.y / 2], dx = _ref[0], dy = _ref[1];
      _ref2 = [dx + 2 * dy, dx - 2 * dy], rx = _ref2[0], ry = _ref2[1];
      _ref3 = _this._camn, cx = _ref3[0], cy = _ref3[1];
      console.log(cx + rx / _this.scale, cy + ry / _this.scale);
      return socket.emit("click_map", {
        x: ~~(cx + rx / _this.scale),
        y: ~~(cy + ry / _this.scale)
      });
    };
    if (localStorage.config) {
      config = JSON.parse(localStorage.config);
    } else {
      config = {
        src: '/audio/kouya.mp3',
        volume: 0.5,
        muted: false
      };
      localStorage.config = JSON.stringify(config);
    }
    this.bgm = new Audio('/audio/kouya.mp3');
    this.bgm.volume = config.volume;
    this.bgm.loop = true;
    this.bgm.muted = true;
    if (config.volume > 0) this.bgm.play();
  }

  GameRenderer.prototype.change_scale = function(scale) {
    this.scale = scale;
    this.canvas.width = this.x * this.scale;
    return this.canvas.height = this.y * this.scale;
  };

  GameRenderer.prototype.create_map = function(map) {
    return this.gr_sp = new GroundSprite(map, this.scale);
  };

  GameRenderer.prototype.to_ism_native = function(x, y) {
    return [(x + y) / 2, (x - y) / 4];
  };

  GameRenderer.prototype.to_ism = function(x, y) {
    var cx, cy, _ref;
    _ref = this.cam, cx = _ref[0], cy = _ref[1];
    return [this.scale * this.x / 2 - cx + (x + y) / 2, this.scale * this.y / 2 - cy + (x - y) / 4];
  };

  GameRenderer.prototype.ism2pos = function(x, y) {
    var cx, cy, dx, dy, _ref, _ref2;
    _ref = [x - this.scale * this.x / 2, y - this.scale * this.y / 2], dx = _ref[0], dy = _ref[1];
    _ref2 = this.cam, cx = _ref2[0], cy = _ref2[1];
    return [dx + 2 * dy, dx - 2 * dy];
  };

  GameRenderer.prototype.render = function(data) {
    var PI, cx, cy, gx, gy, hp, i, id, lv, n, objs, oid, tid, toid, tvx, tvy, tx, ty, vx, vy, x, y, _i, _j, _len, _len2, _ref, _ref10, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
    if (data == null) data = {};
    objs = data.objs;
    for (_i = 0, _len = objs.length; _i < _len; _i++) {
      i = objs[_i];
      _ref = i.o, x = _ref[0], y = _ref[1], id = _ref[2], oid = _ref[3];
      if (id === this.uid) {
        this._camn = [x, y];
        this.cam = this.to_ism_native(x * this.scale, y * this.scale);
        break;
      }
    }
    _ref2 = this.cam, cx = _ref2[0], cy = _ref2[1];
    this.g.clearRect(0, 0, 640, 480);
    if ((_ref3 = this.gr_sp) != null) _ref3.draw(this, cx, cy);
    for (_j = 0, _len2 = objs.length; _j < _len2; _j++) {
      i = objs[_j];
      _ref4 = i.o, x = _ref4[0], y = _ref4[1], id = _ref4[2], oid = _ref4[3];
      _ref5 = i.s, n = _ref5.n, hp = _ref5.hp, lv = _ref5.lv;
      _ref6 = this.to_ism(x * this.scale, y * this.scale), vx = _ref6[0], vy = _ref6[1];
      if ((-64 < vx && vx < 706) && (-48 < vy && vy < 528)) {
        if (id === this.uid) {
          this.player_sp.draw(this, vx, vy);
          this.g.init(Color.Blue);
        }
        if (id > 1000) {
          this.char_sp.draw(this, vx, vy);
          this.g.init(Color.Green);
        } else {
          this.monster_sp.draw(this, vx, vy);
          this.g.init(Color.Red);
        }
        if (i.t) {
          _ref7 = i.t, tx = _ref7[0], ty = _ref7[1], tid = _ref7[2], toid = _ref7[3];
          _ref8 = this.to_ism(tx * this.scale, ty * this.scale), tvx = _ref8[0], tvy = _ref8[1];
          this.g.globalAlpha = 0.7;
          this.g.beginPath();
          this.g.moveTo(vx, vy);
          this.g.lineTo(tvx, tvy);
          this.g.stroke();
          PI = Math.PI;
          this.g.beginPath();
          this.g.arc(tvx + this.scale / 8, tvy, ~~(this.scale / 2), -PI / 6, PI / 6, false);
          this.g.stroke();
          this.g.beginPath();
          this.g.arc(tvx + this.scale / 8, tvy, ~~(this.scale / 2), 5 * PI / 6, 7 * PI / 6, false);
          this.g.stroke();
          this.g.stroke();
        }
        this.g.init(Color.White);
        this.g.initText(this.scale / 10, 'Georgia');
        this.g.fillText('' + ~~hp, vx - 6, vy - this.scale / 4);
        this.g.fillText(n + ".Lv" + lv, vx - 10, vy + 6);
      }
    }
    _ref9 = this.events.goal, gx = _ref9[0], gy = _ref9[1];
    _ref10 = this.to_ism(gx * this.scale, gy * this.scale), vx = _ref10[0], vy = _ref10[1];
    this.g.init(Color.i(64, 64, 255), 0.8);
    this.g.arc(vx, vy, this.scale / 2, 0, 2 * Math.PI);
    return this.g.fill();
  };

  return GameRenderer;

})();
