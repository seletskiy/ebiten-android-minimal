// Copyright 2016 Hajime Hoshi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package game

import (
	"fmt"

	"github.com/hajimehoshi/ebiten"
	"github.com/hajimehoshi/ebiten/ebitenutil"
	"github.com/hajimehoshi/ebiten/mobile"
)

type game struct{}

func (game *game) Update(screen *ebiten.Image) error {
	if ebiten.IsDrawingSkipped() {
		return nil
	}

	ebitenutil.DebugPrint(
		screen,
		fmt.Sprintf("TPS: %0.2f\n", ebiten.CurrentTPS()),
	)

	return nil
}

func (game *game) Layout(width int, height int) (int, int) {
	return width, height
}

func init() {
	mobile.SetGame(&game{})
}

// At least one exported function is required by gomobile.
func Export() {}
