String[] lines;
int index = 0;

// time values
float[] t;
float minTime = 99999999.0, maxTime = 0.0;
// pitch values for each voice
int[][] p;
int minPitch = 128, maxPitch = 0;

// normalised values for ploting
float[] x;
float[][] y;

PianoSynthJava myPiano;

float currTime = 0;
float timeStep = 0.02;
int tmpTimeIDX= 0;

// for drawing in real time
float[] prevX_glob = {-1.0, -1.0, -1.0, -1.0};
float[] prevY_glob = {-1.0, -1.0, -1.0, -1.0};

void setup() {
  size(1000, 200);
  background(0);
  stroke(255);
  lines = loadStrings("BC_001_026900B_a1.txt");
  
  myPiano = new PianoSynthJava();
  
  process_piece_data();
  draw_piece();
}

void draw() {
  if (t[tmpTimeIDX] <= currTime){
    for (int i=0; i<4; i++){
      if (p[i][tmpTimeIDX] > 0){
        myPiano.noteOn(p[i][tmpTimeIDX], 90);
        plot_voice_time_step(i, tmpTimeIDX);
      }
    }
    tmpTimeIDX++;
  }
  currTime += timeStep;
}

void process_piece_data(){
  // get onset times
  t = new float[lines.length];
  x = new float[lines.length];
  // get pitches for each voice
  p = new int[4][lines.length];
  y = new float[4][lines.length];
  for (int i=0; i<lines.length; i++){
    String[] cols = split(lines[i], '\t');
    // start getting from 2nd bar
    if (parseFloat(cols[0]) > 0.0){
      t[i] = parseFloat(cols[5]);
      if (minTime > t[i]) minTime = t[i];
      if (maxTime < t[i]) maxTime = t[i];
      for (int j=0; j<4; j++) p[j][i] = 0;
      p[ parseInt(cols[3])%4 ][i] = parseInt(cols[4]);
      if (minPitch > p[ parseInt(cols[3])%4 ][i]) minPitch = p[ parseInt(cols[3])%4 ][i];
      if (maxPitch < p[ parseInt(cols[3])%4 ][i]) maxPitch = p[ parseInt(cols[3])%4 ][i];
    }
  }
  // make ploting values
  for (int i=0; i<t.length; i++){
    x[i] = map(t[i], minTime, maxTime, 5.0, width-5.0);
    for (int j=0; j<4; j++) y[j][i] = map(p[j][i], minPitch, maxPitch, 5.0, height-5.0);
  }
}

void draw_piece(){
  float prevY, prevX;
  // plot per voice
  stroke(70, 70, 130);
  fill(60, 60, 100);
  for (int j=0; j<4; j++){
    prevY = -1.0;
    prevX = -1.0;
    for (int i=0; i<x.length; i++){
      if (y[j][i] > 0){
        if (prevY == -1){
          ellipse(x[i], y[j][i], 3,3);
        }else{
          ellipse(x[i], y[j][i], 3,3);
          line(x[i], y[j][i], prevX, prevY);
        }
        prevY = y[j][i];
        prevX = x[i];
      }
    }
  }
}

void plot_voice_time_step(int v_idx, int t_idx){
  stroke(250, 130, 130);
  fill(200, 100, 100);
  if (y[v_idx][t_idx] > 0){
    if (prevY_glob[v_idx] == -1){
      ellipse(x[t_idx], y[v_idx][t_idx], 3,3);
    }else{
      ellipse(x[t_idx], y[v_idx][t_idx], 3,3);
      line(x[t_idx], y[v_idx][t_idx], prevX_glob[v_idx], prevY_glob[v_idx]);
    }
    prevY_glob[v_idx] = y[v_idx][t_idx];
    prevX_glob[v_idx] = x[t_idx];
  }
}