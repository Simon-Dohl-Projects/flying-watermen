shader_type canvas_item;
uniform float speed  = 0.5;
uniform float dis = 3.5;

void vertex() {
	VERTEX.x += sin(TIME * speed) * dis * (UV.y-1.0);
}
