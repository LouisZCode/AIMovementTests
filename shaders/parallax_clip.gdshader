  shader_type canvas_item;

  uniform float clip_threshold = 1500.0;
  uniform float repeat_size = 1400.0;  // Match your Repeat Size x value
  uniform float scroll_offset_x = 2400.0;  // Match your Scroll Offset x value

  varying vec2 world_pos;

  void vertex() {
      world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
  }

  void fragment() {
      // Calculate which repeat instance this fragment belongs to
      float relative_x = world_pos.x - scroll_offset_x;
      float instance_number = floor(relative_x / repeat_size);

      // Calculate where this repeat instance starts in world space
      float instance_start_x = scroll_offset_x + (instance_number * repeat_size);

      // Discard if this repeat instance starts before the threshold
      if (instance_start_x < clip_threshold) {
          discard;
      }
  }