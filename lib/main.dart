import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(PuzzleApp());
}

class PuzzleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PuzzleWidget(),
    );
  }
}

class PuzzleWidget extends StatefulWidget {
  @override
  _PuzzleWidgetState createState() => _PuzzleWidgetState();
}

class _PuzzleWidgetState extends State<PuzzleWidget> {
  // 盤面を表す2次元配列
  List<List<int>> board = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 0],
  ];
  // ゲームが完了したかどうかを表すフラグ
  bool isCompleted = false;
  // 空のタイルの位置を表す座標
  int emptyTileX = 3;
  int emptyTileY = 3;

  @override
  void initState() {
    super.initState();
    // 盤面をシャッフルする
    shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('15 Puzzle'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: List.generate(16, (index) {
                  final x = index % 4;
                  final y = index ~/ 4;
                  final value = board[y][x];
                  return GestureDetector(
                    onTap: () {
                      // 空のタイルとタップされたタイルが隣り合っている場合にのみ、タイルを移動させる
                      if ((emptyTileX == x &&
                              (emptyTileY == y - 1 || emptyTileY == y + 1)) ||
                          (emptyTileY == y &&
                              (emptyTileX == x - 1 || emptyTileX == x + 1))) {
                        // 空のタイルを移動させる
                        //int temp = board[y][x];
                        //board[y][x] = board[emptyTileY][emptyTileX];
                        //board[emptyTileY][emptyTileX] = temp;
                        // 空のタイルの位置を更新する
                        emptyTileX = x;
                        emptyTileY = y;
                        board[x][y] = 0;
                        // 盤面を更新する
                        setState(() {});
                        // ゲームが完了したかどうかを判定する
                        checkCompleted();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: value == 0
                          ? null
                          : Center(
                              child: Text(
                                '$value',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                    ),
                  );
                }),
              ),
            ),
            // お祝いの表示を追加する
            if (isCompleted)
              Text(
                'Congratulations!',
                style: TextStyle(fontSize: 20),
              ),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                child: Text(
                  'Shuffle',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  // 盤面をシャッフルする
                  shuffle();
                  // ゲームを初期化する
                  isCompleted = false;
                  // 盤面を更新する
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 盤面が初期状態と同じかどうかを判定する
  bool isBoardCompleted() {
    for (int y = 0; y < 4; y++) {
      for (int x = 0; x < 4; x++) {
        // 空のタイルは特別扱いする
        if (x == 3 && y == 3) {
          continue;
        }
        if (board[y][x] != y * 4 + x + 1) {
          return false;
        }
      }
    }
    return true;
  }

  // ゲームが完了したかどうかを判定し、isCompleted 変数を更新する
  void checkCompleted() {
    isCompleted = isBoardCompleted();
    setState(() {});
  }

  // 盤面をシャッフルする
  void shuffle() {
    // 空のタイルを含むリストを作成する
    List<int> tiles = List.generate(16, (i) => i);
    tiles.remove(0);
    tiles.add(0);
    // シャッフルする
    tiles.shuffle();
    // シャッフルされたリストをもとに、盤面を更新する
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        board[i][j] = tiles[i * 4 + j];
        // 空のタイルの位置を記録する
        if (board[i][j] == 0) {
          emptyTileX = j;
          emptyTileY = i;
        }
      }
    }
    // 盤面を更新する
    setState(() {});
  }
}
