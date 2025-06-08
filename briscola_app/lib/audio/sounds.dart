// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.deal:
      return const [
        'card-deal.wav',
      ];
    case SfxType.drop:
      return const [
        'card-drop.wav',
      ];
    case SfxType.gameOver:
      return [
        'game-over.wav',
      ];
    case SfxType.cheer:
      return [
        'cheer.wav',
      ];
  }
}

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.deal:
    case SfxType.cheer:
      return 1.0;
    case SfxType.drop:
      return 5.0;
    case SfxType.gameOver:
      return 5.0;
  }
}

enum SfxType {
  deal,
  drop,
  gameOver,
  cheer,
}
