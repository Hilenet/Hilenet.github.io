Stage stage;
int sysflag = 0;  //0でメニュー 1以降でステージ 9で死亡
boolean pauseflag = false;
int difficult;  //1でeasy  応じて変種出していく
int time = 0;
int killNum = 0;

void setup() {
  size(500, 500);
  frameRate(30);
  ellipseMode(CENTER);
  imageMode(CENTER);  //描画基点を真ん中に
  noStroke();
  stage = new Stage();
}

void draw() {
  time++;
  if (pauseflag)
    stop();
  else {
    switch(sysflag) {
    case 0:
      menu();
      break;
    case 1 :
      switch(difficult) {
      case 1:
        stage.update();
        break;
      }
      break;
    case 9:
      death();
    }
  }
}

void death() {  //死亡処理
  background(255);
  fill(0);
  text("YOU DEAD", 100, 100);
  if (shift)
    sysflag = 0;
}

void stop() {  //ポーズ処理
  if (q)
    pauseflag = false;  //Qで脱出
}

void menu() {
  background(0);
  
  text("Click to start", 100, 100);
  if (shift || mousePressed) {
    sysflag = 1;
    difficult = 1;
  }
}

//カウント、爆破数、GAMEOVER条件を決め、終了時に表示
//スポーン速度も変える？

class Beauty {
  float x, y;
  float vx = 0;
  float vy = 0;
  float r;
  boolean life;
  PImage smile = loadImage("smile.png");
  PImage bomb = loadImage("bomb.png");
  //PImage face = loadImage("( ﾟДﾟ).png");
  int yomei;  //life = falseから余命時間でエフェクト

  Beauty(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
    life = true;
    yomei = 10;
  }

  void update() {
    move();
    roll();
    outCheck();
    draw();
    effect();
  }

  void move() {
    /*
    float dir = random(6.284);
     float num = 5;
     
     vx = num * cos(dir);
     vy = num * sin(dir);
     if (x <= r || (x+r) >= width)
     vx = (0-vx);
     if (y <= r || (y+r) >= height)
     vy = (0-vy);
     */

    vx = random(16)-8;
    vy = random(16)-8;
    x += vx;
    y += vy;
  }

  void roll() {
    //rotate(null);
    //rotate()使って回転させたい
  } 

  void draw() {
    if (life == true)
      image (smile, x, y, 2*r, 2*r);
  }

  void effect() {
    if ((life == false) && (yomei > 0)) {
      image (bomb, x, y, 2*r, 2*r);
      yomei --;
    }
  }

  void outCheck() {
    if (((x+r)<0) || ((x-r)>width))
      kill();
    if (((y+r)<0) || ((y-r)>width))
      kill();
  }

  void hitCheck() {
    if (sqrt(pow(mouseX-x, 2)+pow(mouseY-y, 2)) <= r) {
      kill();
      killNum++;
    }
  }

  void kill() {
    life = false;
  }
}

class Beauty1 extends Beauty {
  Stage stage;
  ArrayList<Beauty> B;

  Beauty1(float x, float y, float r,ArrayList<Beauty> B) {
    super(x, y, r);
    this.B = B;
  }

  void draw() {
    if (life == true)
      image (smile, x, y, 2*r, 2*r);
  }


  void effect() {
    if ((life == false) && (yomei > 0)) {
      B.add(new Beauty(x+15, y+15, 32));
      B.add(new Beauty(x+15, y-15, 32));
      B.add(new Beauty(x-15, y+15, 32));
      B.add(new Beauty(x-15, y-15, 32));
      yomei = 0;
    }
  }
}

boolean shift, p, q;

void keyPressed() {
  switch (keyCode) {
  case SHIFT:
    shift = true;
    break;
  case 80:
    p = true;
    break;
  case 81:
    q = true;
    break;
  }
}

void keyReleased() {
  switch (keyCode) {
  case SHIFT:
    shift = false;
    break;
  case 80:
    p = false;
    break;
  case 81:
    q = false;
    break;
  }
}

boolean mouseflag = true;

void mousePressed() {
  if (mouseflag) {
    stage.hentaiHit();
  }
  mouseflag = false;
}

void mouseReleased() {
  mouseflag = true;
}

class Effect {
  float x, y, r;
  int count;
  boolean life;
  PImage bomb = loadImage("bomb.png");

  Effect(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
    count = 20;
  }

  void update() {
    count--;
    lifeCheck();
    draw();
  }

  void draw() {
    image (bomb, x, y, 2*r, 2*r);
  }
  
  void lifeCheck(){
    if (count <= 0)
      kill();
  }
  
  void kill(){
    life = false;
  }
  
}

class Stage {
  int sponecounter, limit;
  int sponelevel = 60, tmp = 0;
  ArrayList<Beauty> B = new ArrayList<Beauty>();
  ArrayList<Effect> E = new ArrayList<Effect>();


  Stage() {
    sponecounter = 30;
    limit = 50;
  }

  void update() {
    background(255);
    endCheck();
    levelup();
    pauseIn();
    spone();
    effect();
    death();
    draw();
  }

  void endCheck() {
    if (B.size() >= 50)
      sysflag = 9;
  }

  void levelup() {
    int tmp1;
    if ((tmp != killNum) && ((killNum % 10) == 0)) {
      tmp1 = (sponelevel/5);
      sponelevel -= tmp1;
      tmp = killNum;
    }
  }

  void pauseIn() {
    if (p) {
      pauseflag = true;
    }
  }

  void spone() {
    if (sponecounter > 0 && limit > 0)
      sponecounter--;
    if ((sponecounter == 0) && (B.size() < limit)) {
      if (((int)random(80)%3) == 0)
        spone1(random(500), random(500));
      else
        sponeNormal(random(500), random(500), 64);
      sponecounter = sponelevel;
    }
  }

  void effect() {
    for (Effect effect : E) {
    }
  }

  void sponeNormal(float x, float y, float r) {
    B.add(new Beauty(x, y, r));
  }

  void spone1(float x, float y) {
    B.add(new Beauty1(x, y, 64, B));
  }

  void death() {
    for (int i = B.size ()-1; i >= 0; i--) {
      if (B.get(i).yomei == 0) 
        B.remove(i);
    }
  }

  void draw() {
    beautyUpdate();
    state();
  }

  void beautyUpdate() {
    for (int i = 0; i < B.size (); i++) {
      B.get(i).update();
    }
  }

  void hentaiHit() {
    for (Beauty beauty : B)
      beauty.hitCheck();
  }

  void state() {
    fill(0);
    text("やぎ : "+B.size(), 0, 10);
    text("fps : " + frameRate, 0, 30);
    text("mouseon : " + mouseflag, 0, 50);
    text("KillMark : " + killNum, 0, 70);
    text("間隔 : " + sponelevel, 0, 90);
    text("残り時間 : " + sponecounter, 0, 110);
  }
}


