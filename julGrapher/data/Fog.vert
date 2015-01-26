uniform mat4 transform;
uniform mat4 modelview;
attribute vec4 vertex;
attribute vec4 color;

varying vec4 vertColor;

void main() {
  gl_Position = transform * vertex;
  //vertColor = color;

  //vertex in 'eye' or camera space
  vec3 ecVertex = vec3(modelview * vertex); 

  float dist = -ecVertex.z/4000.0;
  vertColor = color - vec4(0.0, 0.0, 0.0, dist);
}
