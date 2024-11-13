int[][] table = new int[6][6]; // 儲存格子的狀態
boolean gameStart = false ;//遊戲是否開始
boolean[][] revealed = new boolean[6][6]; // 儲存格子是否已被揭露
int numMines = 5; // 地雷數量
boolean gameOver = false; // 遊戲是否結束

void setup() {
  size(600, 700);
  textSize(50);
  textAlign(CENTER, CENTER);
  // 初始化地雷表
  placeMines();
}

void draw() {
  background(#FFFFF2);
  if (!gameStart) {
    fill(150, 150, 150);
    rect(150, 275, 300, 50);
    fill(0, 0, 255);
    text("Press to Start!", 300, 300);
  } else if (gameStart) {
    background(#FFFFF2);
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 6; j++) {
        if (revealed[i][j]) {
          if (table[i][j] == -1) {
            fill(255, 0, 0); // 地雷顏色
            rect(j * 100, i * 100, 100, 100);
            fill(0);
            text("X", 50 + j * 100, 50 + i * 100);
          } else {
            fill(255); // 安全格子顏色
            rect(j * 100, i * 100, 100, 100);
            fill(0);
            text("" + table[i][j], 50 + j * 100, 50 + i * 100);
          }
        } else {
          fill(225); // 未揭露格子顏色
          rect(j * 100, i * 100, 100, 100);
        }
      }
    }

    if (gameOver) {

      fill(150, 150, 150);
      rect(175, 275, 250, 50);
      fill(255, 0, 0);
      text("Game Over!", 300, 300);
      fill(150, 150, 150);
      rect(175, 630, 250, 50);
      fill(0, 255, 0);
      text("Replay", 300, 650);
    }
  }
}
void mousePressed() {
  int i = mouseY / 100, j = mouseX / 100;
  if (!gameStart) {
    if (mouseX>=150 && mouseX<=450 && mouseY>=275 && mouseY<=325) {
      gameStart = true;}
    } else if (i >= 0 && i < 6 && j >= 0 && j < 6 && !gameOver && gameStart) {
      if (table[i][j] == -1) {
        revealAll(); // 揭露所有格子
        gameOver = true; // 點擊到地雷，結束遊戲
      } else {
        reveal(i, j); // 揭露安全格子
      }
    } else if (gameOver) {
      if (mouseX>=175 && mouseX<=425 && mouseY>=630 && mouseY<=680) {
        resetGame();
      }
    }
  }

  // 隨機放置地雷
  void placeMines() {
    int minesPlaced = 0;
    while (minesPlaced < numMines) {
      int i = int(random(6));
      int j = int(random(6));
      if (table[i][j] != -1) {
        table[i][j] = -1; // 放置地雷
        minesPlaced++;
        incrementNeighborCounts(i, j); // 更新周圍格子的地雷數
      }
    }
  }

  // 更新周圍格子的地雷數
  void incrementNeighborCounts(int x, int y) {
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (x + i >= 0 && x + i < 6 && y + j >= 0 && y + j < 6 && table[x + i][y + j] != -1) {
          table[x + i][y + j]++;
        }
      }
    }
  }

  // 揭露格子
  void reveal(int x, int y) {
    if (x < 0 || x >= 6 || y < 0 || y >= 6 || revealed[x][y]) return;
    revealed[x][y] = true; // 揭露格子

    // 如果該格子是0，則遞歸揭露鄰近格子
    if (table[x][y] == 0) {
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          reveal(x + i, y + j);
        }
      }
    }
  }

  // 揭露所有格子
  void revealAll() {
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 6; j++) {
        revealed[i][j] = true; // 揭露所有格子
      }
    }
  }
  void resetGame() {
    // 重置遊戲相關變數
    table = new int[6][6];  // 重新初始化地雷表
    revealed = new boolean[6][6];  // 重新初始化揭露狀態
    gameOver = false;  // 遊戲結束狀態設為 false
    placeMines();  // 重新放置地雷
  }
