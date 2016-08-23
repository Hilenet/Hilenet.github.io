Boss boss;
Ship ship;
PFont font;
boolean gameover;

//
void setup() {
  size(320, 320);
  frameRate(20);
  noCursor();        // clear mouse cursor
  rectMode(CENTER); // center mode
  
  ship = new Ship();
  boss = new Boss(320 / 2, 60, 40);
  
  font = createFont("FFScala", 24);
  textFont(font);
  
  gameover = false;
}
//
class Ship {
  int hp;
  int sx, sy;
  Ship() {
    hp = 255;
    sx = mouseX;
    sy = mouseY;
  }
  
  void hit() {
    hp-=32;
    if (hp <= 0)
      gameover = true;
  }
  //
  void update(int x, int y) {
    sx = x;
    sy = y;
    stroke(255,255,255);
    fill(255 - hp, 0, 0);
    triangle(x, y - 7, x - 10, y + 7, x + 10, y + 7);
  
    if (mousePressed) {
      line(x, y - 7, x, 0);
      if (abs(sx - boss.bx) < (boss.bw / 2))
        boss.hit();
    }
  }
}
//
class Tama {
  float tx, ty, tr, dx, dy;
  
  Tama(float x, float y, float r, float ldx, float ldy) {
    tx = x;
    ty = y;
    tr = r;
    dx = ldx;
    dy = ldy;
  }
  
  boolean update() {
    tx += dx;
    ty += dy;
    stroke(255, 255, 0);
    noFill();
    ellipse(tx, ty, tr, tr);

    // area check 
    if (ty > 320 || ty < 0 || tx > 320 || tx < 0) {
        return false;
    }
    // hit check
    if (dist(tx, ty, ship.sx, ship.sy) < (tr / 2) + 2)
      ship.hit();
    
    return true;
  }
}
//
class Boss {
  int hp, bw;
  float bx, by, bcx;
  ArrayList danmaku;
 
  Boss(float x, float y, int w) {
    bx = bcx = x;
    by = y;
    bw = w;
    hp = 256;
    danmaku = new ArrayList(); 
  }
  //
  void hit() {
    hp--;
    if (hp <= 0) 
      gameover = true;
  }
  //
  void fire_360(float x, float y) {  
    for (int i = 0; i < 360; i+= 10) { 
      float rad = radians(i);
      danmaku.add(new Tama(x, y, 15, cos(rad), sin(rad)));
    }
  }
  //
  void update() {
    // boss update
    float dx;
    dx = 75.0 * sin(radians(frameCount * 6));
    bx = bcx + dx;
    stroke(0,255,0);
    fill(256 - hp, 0, 0);
    rect(bx, by, bw, 20);
   
    // fire
    if (frameCount % 30 == 0)
      fire_360(bx, by);
   
    // danmaku update
    for (int i = danmaku.size() -1; i >= 0; i--) {
      Tama t = (Tama)danmaku.get(i);
      if (t.update() == false)
        danmaku.remove(i);
    }
  }
}
// print time
void print_time() {
  float ft = (float)millis() / 1000;
  
  textAlign(RIGHT);
  text(nf(ft, 1, 2), 320, 24);
}

//
void draw() {
  if (gameover) {  // game over
    textAlign(CENTER);
    if (ship.hp <= 0) {
      fill(255, 255, 255);  // blue
      text("YOU LOSE", 320 / 2, 320 / 2);
    } else {
      fill(255 * sin(frameCount), 255, 255 * cos(frameCount));  // red
      text("YOU WIN!", 320 / 2, 320 / 2);
    }
  } else {
    background(0); // clear
    ship.update(mouseX, mouseY - 20);
    boss.update();
    
    fill(255, 255, 255); 
   
    print_time();
  }
}
      