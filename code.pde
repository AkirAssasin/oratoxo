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
    slimes.add(new Slime(100,random(width),random(height)));
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
  for (int i=arrows.size()-1; i>=0; i--) {
    Particle ar = (Arrow) arrows.get(i);
    ar.update();
  }
  for (int i=slimes.size()-1; i>=0; i--) {
    Particle s = (Slime) slimes.get(i);
    s.update();
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
    float r;
    float s;

    Slime(os,ox,oy) {
      s = os;
      x = ox;
      y = oy;
      
    }

    void draw() {
      ellipse(x,y,s,s); 
    }

    void update() {
      r = atan2(py - y, px - x) / PI * 180;
      x += cos(r/180*PI);
      y += sin(r/180*PI);
      for (int i=arrows.size()-1; i>=0; i--) {
        Particle ar = (Arrow) arrows.get(i);
        if (dist(ar.x,ar.y,x,y) <= s/2) {
          slimes.add(new Slime(s/2,ar.x,ar.y));
          s /= 2;
          arrows.remove(i);
        } 
      }
    }
}
