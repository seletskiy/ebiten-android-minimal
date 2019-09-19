package io.reconquest.app;

import android.app.Activity;
import android.os.Bundle;

import go.Seq;
import io.reconquest.app.game.EbitenView;

public class MainActivity extends Activity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main);
    Seq.setContext(getApplicationContext());
  }

  private EbitenView getEbitenView() {
    return (EbitenView) this.findViewById(R.id.ebitenview);
  }

  @Override
  protected void onPause() {
    super.onPause();
    this.getEbitenView().suspendGame();
  }

  @Override
  protected void onResume() {
    super.onResume();
    this.getEbitenView().resumeGame();
  }
}
