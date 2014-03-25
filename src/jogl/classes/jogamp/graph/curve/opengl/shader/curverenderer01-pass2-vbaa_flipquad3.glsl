
        // Pass-2: AA on Texture
        // Note: gcv_TexCoord is in center of sample pixels, origin is bottom left!
        // 
        // Same as flipquad - but w/ rgss coordinates

        const float sampleCount = gcu_TextureSize.z;
        const vec2 psize = 1.0 / gcu_TextureSize.xy; // pixel size

        const vec2 normFragCoord = gl_FragCoord.xy - vec2(0.5, 0.5); // normalize center 0.5/0.5 -> 0/0
        const vec2 modPos = mod(normFragCoord, 2.0);
        const float orient = mod(modPos.x + modPos.y, 2.0); // mirrored on all odd columns, alternating each row (checker-board pattern)

        const vec2 texCoord = gcv_TexCoord.st;
        vec4 t;

// #define GetSample(texUnit, texCoord, psize, cx, cy, offX, offY) texture2D(texUnit, texCoord + psize *  vec2(cx+offX, cy+offY))

        if( 1 == sampleCount ) {
            t = texture2D(gcu_TextureUnit, texCoord);

        } else if( 4 > sampleCount ) {
            // SampleCount 2 -> 2p 
            const float weight = 1.0 / 2.0;
            const float edge = ( sampleCount / 2.0 ) - 1.0;

            t  = GetSample(gcu_TextureUnit, texCoord, psize,      -edge,       edge, -0.5,  0.5)*weight;  // center
            t += GetSample(gcu_TextureUnit, texCoord, psize,       edge,      -edge,  0.5, -0.5)*weight;  // center

        } else if( 8 > sampleCount ) {
            // SampleCount 4 -> 4p
            const float weight = 1.0 / 4.0;
            const float edgeS4_1Q = ( sampleCount / 2.0 ) - 1.0;

            if( 0 == orient ) {
                                                                                                           // SWIPE LEFT -> RIGHT
                t  = GetSample(gcu_TextureUnit, texCoord, psize, -edgeS4_1Q,        0.0, -0.5,  0.5)*weight; // upper-left  [p1]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0, -edgeS4_1Q, -0.5, -0.5)*weight; // lower-left  [p3]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0,  edgeS4_1Q,  0.5,  0.5)*weight; // upper-right [p2]
                t += GetSample(gcu_TextureUnit, texCoord, psize,  edgeS4_1Q,        0.0,  0.5, -0.5)*weight; // lower-right [p4]
            } else {
                t  = GetSample(gcu_TextureUnit, texCoord, psize, -edgeS4_1Q,        0.0, -0.5, -0.5)*weight; // lower-left  [p4]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0,  edgeS4_1Q, -0.5,  0.5)*weight; // upper-left  [p3]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0, -edgeS4_1Q,  0.5, -0.5)*weight; // lower-right [p2]
                t += GetSample(gcu_TextureUnit, texCoord, psize,  edgeS4_1Q,        0.0,  0.5,  0.5)*weight; // upper-right [p1]
            }
        } else {
            // SampleCount 8 -> 16p
            const float weight = 1.0 / 16.0;
            const float edgeS4_1Q = 1.0;

            if( 0 == orient ) {
                                                                                                           // SWIPE LEFT -> RIGHT
                t  = GetSample(gcu_TextureUnit, texCoord, psize, -edgeS4_1Q,        0.0, -2.0-0.5, -2.0+0.5)*weight; // upper-left  [p1]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0, -edgeS4_1Q, -2.0-0.5, -2.0-0.5)*weight; // lower-left  [p3]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0,  edgeS4_1Q, -2.0-0.5, -2.0-0.5)*weight; // upper-right [p2]
                t += GetSample(gcu_TextureUnit, texCoord, psize,  edgeS4_1Q,        0.0, -2.0-0.5, -2.0-0.5)*weight; // lower-right [p4]

                t += GetSample(gcu_TextureUnit, texCoord, psize, -edgeS4_1Q,        0.0, -2.0-0.5,  2.0-0.5)*weight; // lower-left  [p4]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0,  edgeS4_1Q, -2.0-0.5,  2.0+0.5)*weight; // upper-left  [p3]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0, -edgeS4_1Q, -2.0+0.5,  2.0-0.5)*weight; // lower-right [p2]
                t += GetSample(gcu_TextureUnit, texCoord, psize,  edgeS4_1Q,        0.0, -2.0+0.5,  2.0+0.5)*weight; // upper-right [p1]

                t += GetSample(gcu_TextureUnit, texCoord, psize, -edgeS4_1Q,        0.0,  2.0-0.5, -2.0-0.5)*weight; // lower-left  [p4]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0,  edgeS4_1Q,  2.0-0.5, -2.0+0.5)*weight; // upper-left  [p3]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0, -edgeS4_1Q,  2.0+0.5, -2.0-0.5)*weight; // lower-right [p2]
                t += GetSample(gcu_TextureUnit, texCoord, psize,  edgeS4_1Q,        0.0,  2.0+0.5, -2.0+0.5)*weight; // upper-right [p1]

                t += GetSample(gcu_TextureUnit, texCoord, psize, -edgeS4_1Q,        0.0,  2.0-0.5,  2.0+0.5)*weight; // upper-left  [p1]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0, -edgeS4_1Q,  2.0-0.5,  2.0-0.5)*weight; // lower-left  [p3]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0,  edgeS4_1Q,  2.0-0.5,  2.0-0.5)*weight; // upper-right [p2]
                t += GetSample(gcu_TextureUnit, texCoord, psize,  edgeS4_1Q,        0.0,  2.0-0.5,  2.0-0.5)*weight; // lower-right [p4]
            } else {
                t  = GetSample(gcu_TextureUnit, texCoord, psize, -edgeS4_1Q,        0.0, -2.0-0.5, -2.0-0.5)*weight; // lower-left  [p4]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0,  edgeS4_1Q, -2.0-0.5, -2.0+0.5)*weight; // upper-left  [p3]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0, -edgeS4_1Q, -2.0+0.5, -2.0-0.5)*weight; // lower-right [p2]
                t += GetSample(gcu_TextureUnit, texCoord, psize,  edgeS4_1Q,        0.0, -2.0+0.5, -2.0+0.5)*weight; // upper-right [p1]

                t += GetSample(gcu_TextureUnit, texCoord, psize, -edgeS4_1Q,        0.0, -2.0-0.5,  2.0+0.5)*weight; // upper-left  [p1]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0, -edgeS4_1Q, -2.0-0.5,  2.0-0.5)*weight; // lower-left  [p3]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0,  edgeS4_1Q, -2.0-0.5,  2.0-0.5)*weight; // upper-right [p2]
                t += GetSample(gcu_TextureUnit, texCoord, psize,  edgeS4_1Q,        0.0, -2.0-0.5,  2.0-0.5)*weight; // lower-right [p4]

                t += GetSample(gcu_TextureUnit, texCoord, psize, -edgeS4_1Q,        0.0,  2.0-0.5, -2.0+0.5)*weight; // upper-left  [p1]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0, -edgeS4_1Q,  2.0-0.5, -2.0-0.5)*weight; // lower-left  [p3]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0,  edgeS4_1Q,  2.0-0.5, -2.0-0.5)*weight; // upper-right [p2]
                t += GetSample(gcu_TextureUnit, texCoord, psize,  edgeS4_1Q,        0.0,  2.0-0.5, -2.0-0.5)*weight; // lower-right [p4]

                t += GetSample(gcu_TextureUnit, texCoord, psize, -edgeS4_1Q,        0.0,  2.0-0.5,  2.0-0.5)*weight; // lower-left  [p4]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0,  edgeS4_1Q,  2.0-0.5,  2.0+0.5)*weight; // upper-left  [p3]
                t += GetSample(gcu_TextureUnit, texCoord, psize,        0.0, -edgeS4_1Q,  2.0+0.5,  2.0-0.5)*weight; // lower-right [p2]
                t += GetSample(gcu_TextureUnit, texCoord, psize,  edgeS4_1Q,        0.0,  2.0+0.5,  2.0+0.5)*weight; // upper-right [p1]
            }
        }

        #if 0
        if(t.w == 0.0){
            discard; // discard freezes NV tegra2 compiler
        }
        #endif
        
        color = t.rgb;
        alpha = gcu_Alpha * t.a;
