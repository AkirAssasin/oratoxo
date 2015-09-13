/* @pjs font='fonts/font.ttf'; globalKeyEvents="true"; */ 

var myfont = loadFont("fonts/font.ttf"); 

ArrayList arrows;
ArrayList slimes;
ArrayList decors;
float width;
float height;
float pwidth;
float pheight;

float prs;
float px;
float py;
float pr;
float ps;
float pk;
float pa;

color cbg;
color obg;
color gbg;
color icbg;

float sdp;
float scdp;

color[] tbg = {
  color(179,251,251),
  color(247,189,76),
  color(18,16,94),
};
float dt;

void setup() {
    width = window.innerWidth;
    height = window.innerHeight;
    px = width/2;
    py = height/2;
    pk = 1;
    dt = 0;
    pa = 10;
    size(width, height);
    pwidth = width;
    pheight = height;
    arrows = new ArrayList();
    slimes = new ArrayList();
    decors = new ArrayList();
    textFont(myfont);
    obg = color(0,0,150);
    gbg = color((red(obg) + green(obg) + blue(obg))/3);
    cbg = gbg;
    decors.add(new Decor(width/2,height/2,"Time is what we want most, but what we use worst.",width/30));
    decors.add(new Decor(width/2,height/2 + width/50,"Time moves when you do. Click to shoot.",width/60));
    decors.add(new Decor(width/2,height/2 + width/50 + width/60,"The further your mouse, the faster you run,",width/60));
    decors.add(new Decor(width/2,height/2 + width/50 + width/30,"the slower you reload. Pick up arrows by going near them.",width/60));
}

 

Number.prototype.between = function (min, max) {
    return this > min && this < max;
};

void draw() {
    px = width/2;
    py = height/2;
    scdp = (900 - dist(dt,0,900,0))/900;
    sdp = (dt - 900)/900;
    icbg = color(255 - red(cbg),255 - green(cbg),255 - blue(cbg));
    background(cbg);
    pr = atan2(mouseY - py, mouseX - px) / PI * 180;
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    pwidth = width;
    pheight = height;
    
    fill(255);
    textAlign(CENTER,TOP);
    textSize(width/30);
    text(pa + " arrows left",width/2,0);
    if (pa > 0) {
      prs = dist(mouseX,mouseY,px,py)/dist(0,0,px,py);
    } else {prs = 1;}
    translate(px + sdp*5,py + 5);  
    rotate(pr/180*PI); 
    strokeWeight(5);
    stroke(0,255*(scdp/1.3));
    fill(0,0);
    arc(0, 0, 50, 50, PI*2.5/4, PI*5.5/4);
    strokeWeight(2);
    line(-10 + ps,0,-10,25);
    line(-10 + ps,0,-10,-25);
    if (ps >= 0) {
      strokeWeight(3*pk);
      line(-10 + ps,0, -55 + ps,0);
    }
    rotate(0-pr/180*PI);  
    translate(-px - sdp*5,- py - 5);
    
    translate(px,py);
    rotate(pr/180*PI); 
    strokeWeight(5);
    stroke(icbg);
    fill(0,0);
    arc(0, 0, 50, 50, PI*2.5/4, PI*5.5/4);
    strokeWeight(2);
    line(-10 + ps,0,-10,25);
    line(-10 + ps,0,-10,-25);
    if (prs < 0.05) {
      strokeWeight(1);
      stroke(red(icbg),green(icbg),blue(icbg),255*(0.05 - prs)/0.05);
      line(0,0,-100*(0.05 - prs)/0.05,0);
    }
    stroke(icbg);
    if (ps >= 0) {
      strokeWeight(3*pk);
      line(-10 + ps,0, -55 + ps,0);
    }
    rotate(0-pr/180*PI); 
    translate(-px,-py);
    
    for (int i=decors.size()-1; i>=0; i--) {
        Particle de = (Decor) decors.get(i);
        de.draw();
    }
    for (int i=arrows.size()-1; i>=0; i--) {
        Particle ar = (Arrow) arrows.get(i);
        ar.draw();
    }
    for (int i=slimes.size()-1; i>=0; i--) {
      Particle s = (Slime) slimes.get(i);
      s.draw();
    }
    if (mouseX != pmouseX || mouseY != pmouseY || (keyPressed && key != 'g')) {
      timeStep(true);
    } else {
      cbg = lerpColor(cbg,gbg,0.05);
    }
    if (mousePressed) {
      timeStep(false);
      if (ps >= 25) {
        if (pa >= 1) {
          pa -= 1;
          
        }
        ps = -5;
        for(int i = 0; i < pk; i++) {
          arrows.add(new Arrow(px,py,mouseX + random(-(pk - 1)*2,(pk - 1)*2),mouseY + random(-(pk - 1)*2,(pk - 1)*2)));
        }
        if (pk > 1) {pk -= 1;}
      }
    }
}

void timeStep(toMove) {
  if (dt < 1800) {
    dt += 0.15;
  } else {dt = 0;}
  if (dt <= 600) {
    obg = lerpColor(tbg[2],tbg[0],dt/600);
    if (random(1) > 0.993) {
      slimes.add(new Slime(true));
    }
  } else if (dt <= 900) {
    obg = tbg[0];
    if (random(1) > 0.992) {
      slimes.add(new Slime(false));
    }
  } else if (dt <= 1100) {
    obg = lerpColor(tbg[0],tbg[1],(dt - 900)/200);
    if (random(1) > 0.992) {
      slimes.add(new Slime(false));
    }
  } else if (dt <= 1300) {
    obg = lerpColor(tbg[1],tbg[2],(dt - 1100)/200);
    if (random(1) > 0.993) {
      slimes.add(new Slime(true));
    }
  } else {
    obg = tbg[2];
    if (random(1) > 0.99) {
      slimes.add(new Slime(true));
    }
  }
  cbg = lerpColor(cbg,obg,0.05);
  for (int i=decors.size()-1; i>=0; i--) {
    Particle de = (Decor) decors.get(i);
    de.x -= cos(pr/180*PI)*(0.2+prs);
    de.y -= sin(pr/180*PI)*(0.2+prs);
  }
  for (int i=arrows.size()-1; i>=0; i--) {
    Particle ar = (Arrow) arrows.get(i);
    ar.update();
    pk = max(pk,ar.k);
    ar.x -= cos(pr/180*PI)*(0.2+prs);
    ar.y -= sin(pr/180*PI)*(0.2+prs);
    if (ar.s <= 0 && dist(px,py,ar.x,ar.y) <= 25) {arrows.remove(i); pa += 1;}
  }
  for (int i=slimes.size()-1; i>=0; i--) {
    Particle s = (Slime) slimes.get(i);
    s.update();
    s.x -= cos(pr/180*PI)*(0.2+prs);
    s.y -= sin(pr/180*PI)*(0.2+prs);
    s.tx -= cos(pr/180*PI)*(0.2+prs);
    s.ty -= sin(pr/180*PI)*(0.2+prs);
    if (s.hp <= 0) {
      slimes.remove(i);
    }
  }
  if (toMove) {
    pk = min(pk,5);
    if (ps < 25 && pa > 0) {ps += max(0,1 - prs - pk/5);}
  }
}

class Decor {
    float x;
    float y;
    float s;
    String t;

    Decor(ox,oy,ot,os) {
      x = ox;
      y = oy;
      t = ot;
      s = os;
    }

    void draw() {
      textSize(s);
      fill(0,255*(scdp/1.3));
      textAlign(CENTER);
      text(t,x + sdp*5,y + 2);
        
      fill(icbg);
      text(t,x,y); 
        
      x *= width/pwidth;
      y *= height/pheight;
    }

    void update() {
      d += 0.25;
      x += cos(r/180*PI)*15;
      y += sin(r/180*PI)*15;
    }
}

class Arrow {
    float x;
    float y;
    float r;
    float k;
    float d;
    float s;
    float h;

    Arrow(ox,oy,otx,oty) {
      x = ox;
      y = oy;
      s = 15;
      r = atan2(y - oty, x - otx) / PI * 180;
      x += cos(r/180*PI)*55;
      y += sin(r/180*PI)*55;
      if (prs < 0.05) {
        d = 5 + 15*(0.05 - prs)/0.05;
      } else {
        d = 5;
      }
    }

    void draw() {
      strokeWeight(3);

      translate(x + sdp*5,y + 1 + 5*s/15);  
      rotate(r/180*PI); 
      stroke(0,255*(scdp/1.3));
      line(0,0,-55,0); 
      rotate(0-r/180*PI); 
      translate(-x - sdp*5,-y - 1 - 5*s/15);

      translate(x,y);  
      rotate(r/180*PI);
      stroke(icbg);
      line(0,0,-55,0); 
      rotate(0-r/180*PI); 
      translate(-x,-y);
        
      x *= width/pwidth;
      y *= height/pheight;
      if (x < -55 || y < -55 || x > width + 55 || y > height + 55) {
        stroke(icbg);
        fill(cbg);
        ellipse(constrain(x,5,width-5),constrain(y,5,height-5),5,5);
      }
    }

    void update() {
      d += 0.25;
      x += cos(r/180*PI)*s;
      y += sin(r/180*PI)*s;
      if (d == 20) {
        h += 1;
      }
      if (s > 0) {
        s -= h/10;
        s = max(0,s);
      } else {k = 0;}
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
    float hp;
    boolean flee;

    Slime(of) {
      flee = of;
      sp = 0;
      s = random(25,100);
      hp = s;
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
      if (!flee) {
        translate(x + sdp*5,y + 5);
        rotate(r/180*PI); 
        fill(0,255*(scdp/1.3)*(hp/s));
        stroke(0,0);
        rect(-s/2,-s/2,s,s); 
        rotate(-r/180*PI); 
        translate(-x - sdp*5,-y - 5);
      }
        
      translate(x,y);
      rotate(r/180*PI); 
      fill(icbg,255*(hp/s));
      stroke(0,0);
      rect(-s/2,-s/2,s,s); 
      rotate(-r/180*PI); 
      translate(-x,-y);
      x *= width/pwidth;
      y *= height/pheight;
    }

    void update() {
      sp += (1*((100-s)/100) - sp)/s;
      r = atan2(ty - y, tx - x) / PI * 180;
      if (dist(x,y,tx,ty) < s/2) {
        tx = px;
        ty = py;
        sp = 0;
      } 
      if (dist(x,y,px,py) < width/4) {
        tx = px;
        ty = py;
      }
      if (dist(x,y,px,py) < s/2) {
        window.location.reload();
      } 
      if (dt > 600 && dt <= 1300 && flee) {
        x -= cos(r/180*PI)*sp*1.5;
        y -= sin(r/180*PI)*sp*1.5; 
        hp -= 0.05;
      } else {
        x += cos(r/180*PI)*sp;
        y += sin(r/180*PI)*sp;
      }
      for (int i=arrows.size()-1; i>=0; i--) {
        Particle ar = (Arrow) arrows.get(i);
        if (dist(x,y,ar.x,ar.y) < s/2 && ar.s > 5) {
          hp -= ar.d;
          sp = 0;
          ar.h += 1;
          if (hp <= 0) {ar.k += 1;}
        }
      }
    }
}
