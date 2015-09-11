/* @pjs font='fonts/font.ttf' */ 

var myfont = loadFont("fonts/font.ttf"); 

ArrayList arrows;
ArrayList slimes;
float width;
float height;
float pwidth;
float pheight;

float px;
float py;
float pr;
float ps;

void setup() {
    width = window.innerWidth;
    height = window.innerHeight;
    px = width/2;
    py = height/2;
    size(width, height);
    pwidth = width;
    pheight = height;
    arrows = new ArrayList();
    slimes = new ArrayList();
    textFont(myfont);
    //document.documentElement.webkitRequestFullScreen();
}

 

Number.prototype.between = function (min, max) {
    return this > min && this < max;
};

void draw() {
    pr = atan2(mouseY - py, mouseX - px) / PI * 180;
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    pwidth = width;
    pheight = height;
    translate(px,py);
    rotate(pr/180*PI); 
    strokeWeight(5);
    stroke(0);
    fill(0,0);
    arc(0, 0, 50, 50, PI*2.5/4, PI*5.5/4);
    strokeWeight(2);
    line(-10 + ps,0,-10,25);
    line(-10 + ps,0,-10,-25);
    if (ps >= 0) {
      strokeWeight(3);
      line(-10 + ps,0, -55 + ps,0);
    }
    rotate(0-pr/180*PI); 
    translate(-px,-py);
    for (int i=arrows.size()-1; i>=0; i--) {
        Particle ar = (Arrow) arrows.get(i);
        ar.draw();
    }
    for (int i=slimes.size()-1; i>=0; i--) {
      Particle s = (Slime) slimes.get(i);
      s.draw();
    }
    if (mouseX != pmouseX || mouseY != pmouseY) {
      timeStep(true);
    }
    if (mousePressed) {
      timeStep(false);
      if (ps >= 25) {
        ps = -5;
        arrows.add(new Arrow(px,py,mouseX,mouseY));
      }
    }
}

void timeStep(toMove) {
  if (random(1) > 0.9) {
    slimes.add(new Slime());
  }
  for (int i=arrows.size()-1; i>=0; i--) {
    Particle ar = (Arrow) arrows.get(i);
    ar.update();
    if (ar.x < 0 || ar.y < 0 || ar.x > width || ar.y > height) {arrows.remove(i);}
  }
  for (int i=slimes.size()-1; i>=0; i--) {
    Particle s = (Slime) slimes.get(i);
    s.update();
    if (s.s <= 0) {
      slimes.remove(i);
    }
  }
  if (toMove) {
    px += cos(pr/180*PI);
    py += sin(pr/180*PI);
    if (ps < 25) {ps += 0.5;}
  }
}

class Arrow {
    float x;
    float y;
    float r;

    Arrow(ox,oy,otx,oty) {
      x = ox;
      y = oy;
      r = atan2(y - oty, x - otx) / PI * 180;
      x += cos(r/180*PI)*55;
      y += sin(r/180*PI)*55;
    }

    void draw() {
      strokeWeight(3);
      stroke(0);
      translate(x,y);  
      rotate(r/180*PI);  
      line(0,0,-55,0); 
      rotate(0-r/180*PI); 
      translate(-x,-y); 
    }

    void update() {
      x += cos(r/180*PI)*15;
      y += sin(r/180*PI)*15;
    }
}

class Slime {
    float x;
    float y;
    float tx;
    float ty;
    float r;
    float s;
    float sp;

    Slime() {
      sp = 0;
      s = random(100);
      switch(round(random(3))) {
        case 0:
          x = random(width);
          y = -s;
          break;
        case 1:
          x = random(width);
          y = height + s;
          break;
        case 2:
          y = random(height);
          x = -s;
          break;
        case 3:
          y = random(height);
          x = width + s;
          break;
      }
      tx = px;
      ty = py;
      r = atan2(ty - y, tx - x) / PI * 180;
    }

    void draw() {
      translate(x,y);
      rotate(r/180*PI); 
      rect(-s,-s,s,s); 
      rotate(-r/180*PI); 
      translate(-x,-y);
    }

    void update() {
    sp += (1 - sp)/10;
      r = atan2(ty - y, tx - x) / PI * 180;
      if (dist(x,y,tx,ty) < s) {
        tx = px;
        ty = py;
      } 
      x += cos(r/180*PI);
      y += sin(r/180*PI);
      for (int i=arrows.size()-1; i>=0; i--) {
        Particle ar = (Arrow) arrows.get(i);
        if (dist(x,y,ar.x,ar.y) < s) {
          s -= 10;
          sp = 0;
        }
      }
    }
}
