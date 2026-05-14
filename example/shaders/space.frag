#include <flutter/runtime_effect.glsl>

uniform vec2  uSize;
uniform float time;
uniform float scrollOffset;  // Accumulated scroll distance (pre-calculated on CPU)

out vec4 fragColor;

// ----------------------- Helpers (mobile-friendly) -----------------------
float saturate(float x) { return clamp(x, 0.0, 1.0); }

float hash12(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

// Value noise (cheap, 2D)
float vnoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);

    float a = hash12(i);
    float b = hash12(i + vec2(1.0, 0.0));
    float c = hash12(i + vec2(0.0, 1.0));
    float d = hash12(i + vec2(1.0, 1.0));

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

vec3 palette(float t) {
    // Vibrant retro palette
    if (t < 0.25) return vec3(0.40, 0.85, 1.20); // electric cyan
    if (t < 0.50) return vec3(1.30, 0.85, 0.45); // hot amber
    if (t < 0.75) return vec3(1.10, 0.50, 1.30); // magenta
    return vec3(0.60, 1.30, 0.85);               // neon mint
}

// Pixel-art star layer: stars are placed in macro-cells with tiny plus-shapes
vec3 starLayer(vec2 fragCoord, float px, float cellSize, float density, float scrollMult, float layerSeed) {
    // Apply scroll in screen space BEFORE pixelation for smooth movement
    vec2 scroll = vec2(0.0, -scrollOffset * scrollMult * px);
    vec2 scrolledCoord = fragCoord + scroll;
    
    // Now pixelate the scrolled coordinates
    vec2 gp = floor(scrolledCoord / px);

    vec2 cell = floor(gp / cellSize);
    vec2 local = gp - cell * cellSize; // 0..cellSize-1 in pixel units

    float r = hash12(cell + vec2(layerSeed, layerSeed * 2.13));
    if (r < (1.0 - density)) return vec3(0.0);

    // Star position inside the cell
    float rx = hash12(cell + vec2(11.7 + layerSeed, 3.1));
    float ry = hash12(cell + vec2( 4.2 + layerSeed, 9.9));
    vec2 sPos = floor(vec2(rx, ry) * cellSize);

    // Star brightness + color
    float b = 0.55 + 0.45 * hash12(cell + vec2(7.7, 8.8) + layerSeed);
    vec3  c = palette(hash12(cell + vec2(5.3, 1.9) + layerSeed));

    // Pixel-art shapes (center + optional cross)
    vec2 d = abs(local - sPos);
    float center = (d.x + d.y < 0.5) ? 1.0 : 0.0;

    // Occasionally make a plus/cross star
    float big = step(0.80, hash12(cell + vec2(2.2, 6.6) + layerSeed));
    float cross =
        (big > 0.5) ?
        (
            // vertical arm
            ((d.x < 0.5) && (d.y < 2.5)) ? 1.0 :
            // horizontal arm
            ((d.y < 0.5) && (d.x < 2.5)) ? 1.0 : 0.0
        )
        : 0.0;

    // Tiny "twinkle" (quantized so it still feels pixel-art)
    float tw = 0.80 + 0.20 * hash12(vec2(r, floor(time * 6.0)));
    float a = (center > 0.5 ? 1.0 : (cross > 0.5 ? 0.55 : 0.0)) * b * tw;

    return c * a;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;

    // Pixelation amount: increase for chunkier pixels
    float px = max(2.0, floor(min(uSize.x, uSize.y) / 220.0)); // ~2..6 on phones
    vec2 gPix = floor(fragCoord / px); // "pixel grid" coordinates

    // Base background (vibrant cosmic gradient)
    vec2 uv = fragCoord / max(uSize, vec2(1.0));
    vec3 bgTop = vec3(0.18, 0.06, 0.45);   // deep violet
    vec3 bgMid = vec3(0.55, 0.10, 0.55);   // magenta
    vec3 bgBot = vec3(0.05, 0.20, 0.55);   // ocean blue
    float ty = saturate(uv.y);
    vec3 col = ty < 0.5
        ? mix(bgTop, bgMid, ty * 2.0)
        : mix(bgMid, bgBot, (ty - 0.5) * 2.0);

    // Pixel-art nebula (blocky noise, slow downward drift)
    // Apply scroll before pixelation for smooth movement
    vec2 nebScroll = vec2(0.0, -scrollOffset * 4.0 * px);
    vec2 nebPix = floor((fragCoord + nebScroll) / px);
    vec2 nP = nebPix * 0.06;
    float n1 = vnoise(nP);
    float n2 = vnoise(nP * 2.1 + 17.3);
    float neb = saturate((n1 * 0.7 + n2 * 0.3) - 0.52);

    // Quantize nebula for pixel-art blocks
    neb = floor(neb * 5.0) / 5.0;

    vec3 nebColA = vec3(0.55, 0.18, 0.85);   // vibrant violet
    vec3 nebColB = vec3(0.10, 0.55, 0.90);   // vivid blue
    vec3 nebCol = mix(nebColA, nebColB, n2);
    col += nebCol * neb * 1.25;

    // Stars (parallax layers — extra layer + denser for richer skies)
    col += starLayer(fragCoord, px, 26.0, 0.18,  2.5,  7.0); // farthest, sparse
    col += starLayer(fragCoord, px, 20.0, 0.24,  4.0, 13.0); // far
    col += starLayer(fragCoord, px, 14.0, 0.32,  6.5, 29.0); // mid
    col += starLayer(fragCoord, px,  9.0, 0.40, 10.0, 41.0); // near, dense

    // Optional: mild vignette to frame the ship
    vec2 p = uv * 2.0 - 1.0;
    p.x *= uSize.x / max(uSize.y, 1.0);
    float vig = 1.0 - 0.22 * dot(p, p);
    col *= saturate(vig);

    // Output opaque (premultiplied alpha = 1)
    fragColor = vec4(col, 1.0);
}
